import re

def apply(code, **kwargs):
    """Applies P-03 rule: Adds missing user event prototypes to the forward declaration section."""
    
    # 1. Find all defined user events (like ue_retrieve, ue_update)
    defined_events = set(re.findall(r'^event\s+(ue_\w+)', code, re.MULTILINE | re.IGNORECASE))
    
    if not defined_events:
        return code, {"rule": "P-03", "status": "Not Applicable", "details": "No user events (ue_*) found in script."}

    # 2. Find the forward prototypes section
    prototypes_match = re.search(r'(forward prototypes)(.*?)(end prototypes)', code, re.DOTALL | re.IGNORECASE)
    
    if not prototypes_match:
        # If there are events but no prototype block, that's an issue, but this rule's job is to add to the block.
        # For now, we will skip. A more advanced rule could create the block.
        return code, {"rule": "P-03", "status": "Skipped", "details": "'forward prototypes' section not found."}

    prototype_block = prototypes_match.group(0)
    prototypes_content = prototypes_match.group(2)

    # 3. Find events already declared in the prototype
    declared_events = set(re.findall(r'event\s+(ue_\w+)', prototypes_content, re.IGNORECASE))

    # 4. Find missing event declarations
    missing_events = defined_events - declared_events

    if not missing_events:
        return code, {"rule": "P-03", "status": "Not Applicable", "details": "All user events are already declared."}

    # 5. Inject the missing event declarations
    new_prototypes_content = prototypes_content
    for event in sorted(list(missing_events)):
        # Simple declaration, assuming no arguments for now.
        new_prototypes_content += f'\r\nevent {event} ( )'
    
    new_prototype_block = f'forward prototypes{new_prototypes_content}\r\nend prototypes'
    new_code = code.replace(prototype_block, new_prototype_block)

    report = {
        "rule": "P-03",
        "status": "Applied",
        "details": f"Added {len(missing_events)} missing event prototypes: {', '.join(sorted(list(missing_events)))}"
    }

    return new_code, report