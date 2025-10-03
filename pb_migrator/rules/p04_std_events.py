# -*- coding: utf-8 -*-
"""
마이그레이션 규칙: P-04 표준 이벤트 스크립트 추가
"""

import re

def apply(code, **kwargs):
    """
    P-04 규칙: 윈도우에 표준 `resize`와 `activate` 이벤트 스크립트가 없으면 추가합니다.

    - `resize` 이벤트: P-07 규칙에 따라 새로 추가된 `r_head`, `r_detail` 레이아웃 컨트롤과
      메인 DataWindow(`dw_list` 또는 `dw_detail`)의 크기를 윈도우 크기 변경에 맞춰 동적으로 조절합니다.
    - `activate` 이벤트: 윈도우가 활성화될 때 MDI 프레임의 공통 툴바 버튼 상태를 제어하고,
      MDI 상태바에 현재 윈도우의 ID를 표시합니다.

    Args:
        code (str): 변환할 원본 소스 코드입니다.
        **kwargs: 추가 파라미터입니다. (이 규칙에서는 사용되지 않음)

    Returns:
        tuple: 변환된 코드와 실행 결과 리포트를 담은 튜플을 반환합니다.
    """
    
    added_events = []
    new_code = code
    
    # --- 표준 resize 이벤트 추가 ---
    # `resize` 이벤트가 없고, P-07에 의해 추가되는 r_head, r_detail 컨트롤이 존재할 경우에만 추가합니다.
    if 'event resize;' not in new_code.lower() and 'r_head' in new_code and 'r_detail' in new_code:
        # 리사이즈할 메인 DataWindow를 찾습니다. (일반적으로 dw_list 또는 dw_detail)
        main_dw_match = re.search(r'type\s+(dw_list|dw_detail)\s+from', new_code, re.IGNORECASE)
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
        new_code += resize_script
        added_events.append("resize")

    # --- 표준 activate 이벤트 추가 ---
    # `activate` 이벤트가 없을 경우에만 추가합니다.
    if 'event activate;' not in new_code.lower():
        # 참고: 아래 스크립트의 깨진 한글 문자열은 원본 소스의 일부이며, 의도적으로 유지되었습니다.
        # (f_get_trans_word 함수가 내부적으로 처리하는 것으로 보입니다.)
        activate_script = '''

event activate;gw_window = this

w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("조회") + "(&Q)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("추가") + "(&A)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("삭제") + "(&D)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("저장") + "(&S)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("취소") + "(&Z)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("출력") + "(&P)", true)

w_mdi_frame.st_window.Text = Upper(is_window_id)
end event'''
        new_code += activate_script
        added_events.append("activate")

    if not added_events:
        return code, {"rule": "P-04", "status": "해당 없음", "details": "표준 이벤트(resize, activate)가 이미 존재합니다."}

    report = {
        "rule": "P-04",
        "status": "적용됨",
        "details": f"표준 이벤트를 추가했습니다: {', '.join(added_events)}"
    }

    return new_code, report
