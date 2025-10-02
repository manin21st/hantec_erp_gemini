import re

def apply(code, **kwargs):
    """Applies P-04 rule: Adds standard resize and activate event scripts."""
    
    added_events = []
    
    # --- Standard Resize Event ---
    if 'event resize;' not in code and 'r_head' in code and 'r_detail' in code:
        # Try to find a main datawindow to resize
        main_dw_match = re.search(r'type\s+(dw_list|dw_detail)\s+from', code)
        dw_resize_script = ""
        if main_dw_match:
            main_dw_name = main_dw_match.group(1)
            dw_resize_script = f'''
{main_dw_name}.width = this.width - {main_dw_name}.x - 70
{main_dw_name}.height = this.height - {main_dw_name}.y - 70
'''

        resize_script = f'''
event resize;r_head.width = this.width - r_head.x - 30
r_detail.width = this.width - r_detail.x - 30
r_detail.height = this.height - r_detail.y - 65
{dw_resize_script}
end event'''
        code += resize_script
        added_events.append("resize")

    # --- Standard Activate Event ---
    if 'event activate;' not in code:
        activate_script = '''
event activate;gw_window = this

w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("ȸ") + "(&Q)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("߰") + "(&A)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("") + "(&D)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("") + "(&S)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("") + "(&Z)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("") + "(&P)", true)

w_mdi_frame.st_window.Text = Upper(is_window_id)
end event'''
        code += activate_script
        added_events.append("activate")

    if not added_events:
        return code, {"rule": "P-04", "status": "Not Applicable", "details": "Standard events already exist."}

    report = {
        "rule": "P-04",
        "status": "Applied",
        "details": f"Added standard events: {', '.join(added_events)}"
    }

    return code, report