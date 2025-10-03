# -*- coding: utf-8 -*-
"""
마이그레이션 규칙: P-08 표준 MDI 이벤트 연동
"""

import re

def apply(code, **kwargs):
    """
    P-08 규칙: 윈도우 내부의 버튼 이벤트를 MDI 공통 툴바와 연동하기 위한 표준 사용자 이벤트를 추가합니다.

    MDI 공통 툴바의 버튼(조회, 수정, 삭제 등)을 클릭하면, 현재 활성화된 윈도우의 표준 사용자 이벤트
    (ue_retrieve, ue_update 등)가 호출됩니다. 이 규칙은 해당 표준 사용자 이벤트를 생성하고,
    그 이벤트의 스크립트가 기존의 숨겨진 PictureButton(p_inq, p_mod 등)의 `Clicked!` 이벤트를
    호출하도록 하여, 기존 로직을 수정 없이 재사용합니다.

    Args:
        code (str): 변환할 원본 소스 코드입니다.
        **kwargs: 추가 파라미터입니다. (이 규칙에서는 사용되지 않음)

    Returns:
        tuple: 변환된 코드와 실행 결과 리포트를 담은 튜플을 반환합니다.
    """
    
    # 표준 사용자 이벤트와, 그에 대응하는 레거시 PictureButton의 이름 매핑
    events_to_add = {
        "ue_retrieve": "p_inq",    # 조회
        "ue_update": "p_mod",      # 수정/저장
        "ue_delete": "p_del",      # 삭제
        "ue_append": "p_addrow",   # 행추가
        "ue_cancel": "p_can",      # 취소
        "ue_print": "p_print",     # 출력
        "ue_excel": "p_xls"        # 엑셀
    }

    # 이벤트 프로토타입을 추가할 `forward prototypes` 섹션을 찾습니다.
    prototypes_section_match = re.search(r'(forward prototypes)(.*?)(end prototypes)', code, re.DOTALL | re.IGNORECASE)
    if not prototypes_section_match:
        return code, {"rule": "P-08", "status": "건너뜀", "details": "'forward prototypes' 섹션을 찾지 못했습니다."}

    prototypes_content = prototypes_section_match.group(2)
    original_prototypes_block = prototypes_section_match.group(0)
    added_events = []
    
    # 이벤트 스크립트를 추가할 위치를 찾습니다. (보통 `end variables` 바로 다음)
    injection_point_match = re.search(r'end variables\s*?(\r?\n)', code, re.IGNORECASE)
    if not injection_point_match:
        return code, {"rule": "P-08", "status": "건너뜀", "details": "'end variables' 섹션을 찾지 못했습니다."}
    
    injection_code = ""

    for event, button in events_to_add.items():
        # 1. 해당 이벤트가 이미 선언되어 있는지 확인합니다.
        if f'event {event}' not in prototypes_content.lower():
            # 2. 대응하는 레거시 버튼이 윈도우에 존재하는지 확인합니다.
            if f'type {button} from' in code.lower():
                # 3. 조건이 모두 만족되면, 프로토타입과 이벤트 스크립트를 추가합니다.
                prototypes_content += f'\r\nevent {event}()'
                
                # 이벤트 스크립트는 해당 버튼의 Clicked! 이벤트를 트리거하는 역할을 합니다.
                injection_code += f'''\r\n\r\nevent {event};if IsValid({button}) then {button}.TriggerEvent(Clicked!)end event'''
                added_events.append(event)

    if not added_events:
        return code, {"rule": "P-08", "status": "해당 없음", "details": "모든 표준 이벤트가 이미 존재하거나, 대상 버튼을 찾지 못했습니다."}

    # 새로 추가된 프로토타입으로 `forward prototypes` 블록을 재구성합니다.
    new_prototypes_block = f'forward prototypes{prototypes_content}\r\nend prototypes'
    new_code = code.replace(original_prototypes_block, new_prototypes_block)

    # 생성된 이벤트 스크립트들을 `end variables` 다음에 삽입합니다.
    new_code = new_code.replace(injection_point_match.group(0), injection_point_match.group(0) + injection_code + '\r\n')

    report = {
        "rule": "P-08",
        "status": "적용됨",
        "details": f"{len(added_events)}개의 표준 MDI 이벤트를 추가했습니다: {', '.join(added_events)}"
    }

    return new_code, report
