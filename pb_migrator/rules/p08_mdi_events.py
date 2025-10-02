import re

def apply(code, **kwargs):
    """Applies P-08 rule: Adds standard MDI user events (ue_retrieve, ue_update, etc.)."""
    
    events_to_add = {
        "ue_retrieve": "p_inq",
        "ue_update": "p_mod",
        "ue_delete": "p_del",
        "ue_append": "p_addrow",
        "ue_cancel": "p_can",
        "ue_print": "p_print",
        "ue_excel": "p_xls"
    }

    prototypes_section_match = re.search(r'(forward prototypes)(.*?)(end prototypes)', code, re.DOTALL)
    
    if not prototypes_section_match:
        # If no prototype section, we can't safely add events yet. Defer this.
        return code, {"rule": "P-08", "status": "Skipped", "details": "forward prototypes section not found."}

    prototypes_content = prototypes_section_match.group(2)
    added_events = []
    
    # Find the end of the global variables section to inject event scripts
    injection_point_match = re.search(r'end variables\s*?(\r?\n)', code, re.IGNORECASE)
    if not injection_point_match:
        return code, {"rule": "P-08", "status": "Skipped", "details": "'end variables' section not found."}
    
    injection_code = ""

    for event, button in events_to_add.items():
        # Check if event prototype exists
        if f'event {event}' not in prototypes_content:
            # Check if the corresponding button exists in the code
            if f'type {button} from' in code:
                # Add prototype
                prototypes_content += f'\r\nevent {event}()'
                # Add event script
                injection_code += f'''\r\nevent {event};call super::{event};if IsValid({button}) then {button}.TriggerEvent(Clicked!)end event'''
                added_events.append(event)

    if not added_events:
        return code, {"rule": "P-08", "status": "Not Applicable", "details": "All standard events already exist or target buttons not found."}

    # Reconstruct the prototype block
    new_prototypes_block = f'forward prototypes{prototypes_content}\r\nend prototypes'
    code = code.replace(prototypes_section_match.group(0), new_prototypes_block)

    # Inject the event scripts
    code = code.replace(injection_point_match.group(0), injection_point_match.group(0) + injection_code + '\r\n')

    report = {
        "rule": "P-08",
        "status": "Applied",
        "details": f"Added {len(added_events)} standard MDI events: {', '.join(added_events)}"
    }

    return code, report