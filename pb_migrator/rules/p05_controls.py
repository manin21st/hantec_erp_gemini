import re

def apply(code, **kwargs):
    """Applies P-05 rule: Removes decorative controls like rr_*, ln_*, gb_*."""
    
    original_code = code
    removed_controls = []

    # 1. Find all decorative control names
    control_names = re.findall(r'type\s+((?:rr_|ln_|gb_)\w+)\s+from', code)
    
    if not control_names:
        return code, {"rule": "P-05", "status": "Not Applicable", "details": "No decorative controls found."}

    for name in control_names:
        # 2. Remove forward declaration
        code = re.sub(r'''type\s+%s\s+from\s+\w+\s+within\s+\w+.*?(?:\r?\n)end type''' % name, '''''', code, flags=re.DOTALL)

        # 3. Remove instance variable declaration
        code = re.sub(r'''^\s*%s\s+%s\s*?$\r?\n''' % (name, name), '''''', code, flags=re.MULTILINE)

        # 4. Remove from create event
        code = re.sub(r'''this\.Control\[\w+\]=this\.%s\s*?$\r?\n''' % name, '''''', code, flags=re.MULTILINE)
        code = re.sub(r'''this\.%s=create\s+%s\s*?$\r?\n''' % (name, name), '''''', code, flags=re.MULTILINE)

        # 5. Remove from destroy event
        code = re.sub(r'''destroy\(this\.%s\)\s*?$\r?\n''' % name, '''''', code, flags=re.MULTILINE)

        # 6. Remove the main definition block
        # This regex is tricky because of nested type...end type. We will do a simple one for now.
        # A more robust solution might need parsing rather than just regex.
        code = re.sub(r'''type\s+%s\s+from\s+\w+.*?end type''' % name, '''''', code, flags=re.DOTALL)
        
        removed_controls.append(name)

    # Clean up empty lines
    code = re.sub(r'''(\r?\n){2,}''', '''\r\n''', code)

    report = {
        "rule": "P-05",
        "status": "Applied",
        "details": f"Removed {len(removed_controls)} decorative controls: {', '.join(removed_controls)}"
    }

    return code, report