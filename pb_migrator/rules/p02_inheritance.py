import re

def apply(code, **kwargs):
    """Applies P-02 rule: Handles inherited controls, specifically hiding them by moving them off-screen."""
    
    # Regex to find all inherited control blocks that have `visible = false`
    # It captures the control name and the content of the block.
    pattern = re.compile(r'(type\s+([\w_]+)\s+from\s+w_inherite`[\w_]+.*?)(visible\s*=\s*false)(.*?end type)', re.DOTALL | re.IGNORECASE)
    
    modified_controls = []
    
    def replace_visibility(match):
        control_name = match.group(2)
        if control_name not in modified_controls:
            modified_controls.append(control_name)
        
        # Replace 'visible = false' with off-screen coordinates
        # We also remove any existing x or y coordinates to avoid conflicts.
        block_start = match.group(1)
        block_end = match.group(4)
        
        # Remove existing x and y assignments
        block_start = re.sub(r'\s*integer\s+x\s*=\s*\d+', '', block_start)
        block_start = re.sub(r'\s*integer\s+y\s*=\s*\d+', '', block_start)
        block_end = re.sub(r'\s*integer\s+x\s*=\s*\d+', '', block_end)
        block_end = re.sub(r'\s*integer\s+y\s*=\s*\d+', '', block_end)

        replacement = '''x = 2727\n		y = 1500'''
        return block_start + replacement + block_end

    # Repeatedly apply the substitution until no more matches are found
    new_code = code
    while True:
        new_code, count = pattern.subn(replace_visibility, new_code)
        if count == 0:
            break

    if not modified_controls:
        return code, {"rule": "P-02", "status": "Not Applicable", "details": "No inherited controls with 'visible = false' found."}

    report = {
        "rule": "P-02",
        "status": "Applied",
        "details": f"Moved {len(modified_controls)} inherited controls off-screen: {', '.join(modified_controls)}"
    }

    return new_code, report
