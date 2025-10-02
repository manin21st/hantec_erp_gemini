import re
from pb_migrator.rules import p05_controls

def reposition_control(code, control_name, new_pos):
    """Helper function to reposition a single control by modifying its properties."""
    pattern = re.compile(f'(type\s+{control_name}\s+from[\s\S]*?)(end type)', re.IGNORECASE)
    match = pattern.search(code)
    
    if not match:
        return code, False

    control_block = match.group(1)
    
    # Remove old properties
    control_block = re.sub(r'integer\s+x\s*=\s*\d+', '', control_block)
    control_block = re.sub(r'integer\s+y\s*=\s*\d+', '', control_block)
    control_block = re.sub(r'integer\s+width\s*=\s*\d+', '', control_block)
    control_block = re.sub(r'integer\s+height\s*=\s*\d+', '', control_block)

    # Add new properties
    new_properties = f'''\
    integer x = {new_pos["x"]} \
    integer y = {new_pos["y"]} \
    integer width = {new_pos["width"]} \
    integer height = {new_pos["height"]}'''
    
    new_control_block = control_block.rstrip() + new_properties + "\n"
    
    return code.replace(match.group(0), new_control_block + match.group(2)), True


def apply(code, **kwargs):
    """Applies P-07 rule: Restructures the window layout and repositions key controls."""
    
    window_name_match = re.search(r'global type (\w+?) from', code)
    if not window_name_match:
        return code, {"rule": "P-07", "status": "Error", "details": "Could not determine window name."}
    window_name = window_name_match.group(1)

    code, p05_report = p05_controls.apply(code)
    
    r_head_def = f'''type r_head from rectangle within {window_name}
long linecolor = 28543105
integer linethickness = 4
long fillcolor = 12639424
integer x = 32
integer y = 32
integer width = 4562
integer height = 308
end type'''

    r_detail_def = f'''type r_detail from rectangle within {window_name}
long linecolor = 28543105
integer linethickness = 4
long fillcolor = 16777215
integer x = 32
integer y = 352
integer width = 4562
integer height = 1964
end type'''

    # Inject new controls
    if 'r_head' not in code:
        code = re.sub(r'(global type \w+ from \w+)', r'\1\n r_head r_head', code, 1)
        code = re.sub(r'(on \w+\.create(?:.|\n)*?call super::create)', r'\1\nthis.r_head=create r_head', code, flags=re.DOTALL)
        code = re.sub(r'(on \w+\.destroy(?:.|\n)*?call super::destroy)', r'\1\ndestroy(this.r_head)', code, flags=re.DOTALL)
        code += "\n\n" + r_head_def

    if 'r_detail' not in code:
        code = re.sub(r'(global type \w+ from \w+)', r'\1\n r_detail r_detail', code, 1)
        code = re.sub(r'(on \w+\.create(?:.|\n)*?call super::create)', r'\1\nthis.r_detail=create r_detail', code, flags=re.DOTALL)
        code = re.sub(r'(on \w+\.destroy(?:.|\n)*?call super::destroy)', r'\1\ndestroy(this.r_detail)', code, flags=re.DOTALL)
        code += "\n\n" + r_detail_def

    # Reposition key controls
    repositioned = []
    # Header controls
    for dw_name in ['dw_ip', 'dw_cond', 'dw_1']:
        code, success = reposition_control(code, dw_name, {"x": 41, "y": 52, "width": 3489, "height": 284})
        if success: repositioned.append(dw_name)

    # Detail/List controls
    for dw_name in ['dw_list', 'dw_detail']:
        code, success = reposition_control(code, dw_name, {"x": 41, "y": 372, "width": 4549, "height": 1964})
        if success: repositioned.append(dw_name)

    details = p05_report.get("details", "") + f" Added r_head, r_detail. Repositioned: {', '.join(repositioned)}."

    report = {"rule": "P-07", "status": "Applied", "details": details}

    return code, report