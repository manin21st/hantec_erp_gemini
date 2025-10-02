import re
from pb_migrator.rules import p05_controls

def get_control_properties(control_block):
    props = {"x": 0, "y": 0, "width": 0, "height": 0}
    x_match = re.search(r'x\s*=\s*(\d+)', control_block, re.IGNORECASE)
    y_match = re.search(r'y\s*=\s*(\d+)', control_block, re.IGNORECASE)
    width_match = re.search(r'width\s*=\s*(\d+)', control_block, re.IGNORECASE)
    height_match = re.search(r'height\s*=\s*(\d+)', control_block, re.IGNORECASE)
    
    if x_match: props["x"] = int(x_match.group(1))
    if y_match: props["y"] = int(y_match.group(1))
    if width_match: props["width"] = int(width_match.group(1))
    if height_match: props["height"] = int(height_match.group(1))
    return props

def reposition_control(code, control_name, original_window_props, target_rect_props, original_control_props, padding=10):
    """Helper function to reposition a single control by modifying its properties."""
    pattern = re.compile(f'(type\s+{control_name}\s+from[\s\S]*?)(end type)', re.IGNORECASE)
    match = pattern.search(code)
    
    if not match:
        return code, False

    control_block_full = match.group(0)
    control_block_start = match.group(1)
    control_block_end = match.group(2)

    # Calculate new properties based on relative positioning
    # Calculate original relative position within the original window
    rel_x = original_control_props["x"] / original_window_props["width"]
    rel_y = original_control_props["y"] / original_window_props["height"]

    # Calculate new absolute position within the target rectangle
    new_x = target_rect_props["x"] + int(rel_x * target_rect_props["width"])
    new_y = target_rect_props["y"] + int(rel_y * target_rect_props["height"])

    new_width = original_control_props["width"]
    new_height = original_control_props["height"]

    # Special handling for main datawindows: scale to fill target rectangle with padding
    if control_name.startswith('dw_list') or control_name.startswith('dw_detail') or \
       control_name.startswith('dw_ip') or control_name.startswith('dw_cond'):
        new_x = target_rect_props["x"] + padding
        new_y = target_rect_props["y"] + padding
        new_width = target_rect_props["width"] - 2 * padding
        new_height = target_rect_props["height"] - 2 * padding

    # Ensure controls don't go out of bounds or become too small
    new_width = max(1, new_width) # Minimum width of 1
    new_height = max(1, new_height) # Minimum height of 1

    # Remove old properties
    control_block_start = re.sub(r'integer\s+x\s*=\s*\d+\r?\n', '', control_block_start)
    control_block_start = re.sub(r'integer\s+y\s*=\s*\d+\r?\n', '', control_block_start)
    control_block_start = re.sub(r'integer\s+width\s*=\s*\d+\r?\n', '', control_block_start)
    control_block_start = re.sub(r'integer\s+height\s*=\s*\d+\r?\n', '', control_block_start)

    # Add new properties
    new_properties_str = f'''
    integer x = {new_x}
    integer y = {new_y}
    integer width = {new_width}
    integer height = {new_height}'''
    
    new_control_block_content = control_block_start.strip() + new_properties_str + '\n' + control_block_end
    
    return code.replace(control_block_full, new_control_block_content), True

def apply(code, **kwargs):
    """Applies P-07 rule: Restructures the window layout and repositions key controls."""
    
    window_name_match = re.search(r'global type (\w+?) from \w+\s*\n\s*integer width = (\d+)\s*\n\s*integer height = (\d+)', code, re.DOTALL)
    if not window_name_match:
        return code, {"rule": "P-07", "status": "Error", "details": "Could not determine window name or dimensions."}
    
    window_name = window_name_match.group(1)
    original_window_props = {
        "width": int(window_name_match.group(2)),
        "height": int(window_name_match.group(3))
    }

    code, p05_report = p05_controls.apply(code)
    
    # Define fixed properties for r_head and r_detail
    r_head_props = {"x": 32, "y": 32, "width": 4562, "height": 308}
    r_detail_props = {"x": 32, "y": 352, "width": 4562, "height": 1964}

    r_head_def = f'''type r_head from rectangle within {window_name}
long linecolor = 28543105
integer linethickness = 4
long fillcolor = 12639424
integer x = {r_head_props["x"]}
integer y = {r_head_props["y"]}
integer width = {r_head_props["width"]}
integer height = {r_head_props["height"]}
end type'''

    r_detail_def = f'''type r_detail from rectangle within {window_name}
long linecolor = 28543105
integer linethickness = 4
long fillcolor = 16777215
integer x = {r_detail_props["x"]}
integer y = {r_detail_props["y"]}
integer width = {r_detail_props["width"]}
integer height = {r_detail_props["height"]}
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
    
    # Find all control definitions
    control_defs_matches = re.findall(r'(type\s+(\w+)\s+from[\s\S]*?end type)', code)

    for control_block_full, control_name in control_defs_matches:
        # Skip r_head and r_detail themselves
        if control_name in ['r_head', 'r_detail']:
            continue

        original_control_props = get_control_properties(control_block_full)
        
        target_rect = None
        # Heuristic: if original y is in the top 30% of the window, put in r_head, else r_detail
        if original_control_props["y"] < original_window_props["height"] * 0.3:
            target_rect = r_head_props
        else:
            target_rect = r_detail_props

        if target_rect:
            code, success = reposition_control(code, control_name, original_window_props, target_rect, original_control_props)
            if success: repositioned.append(control_name)

    # Clean up empty lines
    code = re.sub(r'(\r?\n){3,}', '\r\n\r\n', code)

    details = p05_report.get("details", "") + f" Added r_head, r_detail. Repositioned: {', '.join(repositioned)}."

    report = {"rule": "P-07", "status": "Applied", "details": details}

    return code, report