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
    
    events_to_add = {
        "ue_retrieve": "p_inq",
        "ue_update": "p_mod",
        "ue_delete": "p_del",
        "ue_append": "p_addrow",
        "ue_cancel": "p_can",
        "ue_print": "p_print",
        "ue_excel": "p_xls"
    }

    forward_block_match = re.search(r'(^forward\n|forward prototypes)([\s\S]*?)(^end forward\n|end prototypes)', code, re.MULTILINE | re.IGNORECASE)
    prototypes_content = ""
    if forward_block_match:
        prototypes_content = forward_block_match.group(2)

    injection_point_match = re.search(r'(end variables\s*?(\n))', code, re.IGNORECASE)
    if not injection_point_match:
        injection_point_match = re.search(r'(global type w_\w+\s+from\s+window.*?end type\s*?(\n))', code, re.DOTALL | re.IGNORECASE)

    if not injection_point_match:
        return code, {"rule": "P-08", "status": "건너뜀", "details": "이벤트 스크립트를 추가할 위치를 찾지 못했습니다."}

    added_events = []
    new_event_prototypes = ""
    injection_code = ""
    new_code = code

    for event, button in events_to_add.items():
        if f'event {event}' not in prototypes_content.lower():
            if f'type {button} from' in code.lower():
                new_event_prototypes += f'event {event}()\n'
                injection_code += f'\n\nevent {event};if IsValid({button}) then {button}.TriggerEvent(Clicked!)end event'
                added_events.append(event)

    if not added_events:
        return code, {"rule": "P-08", "status": "해당 없음", "details": "모든 표준 이벤트가 이미 존재하거나, 대상 버튼을 찾지 못했습니다."}

    if new_event_prototypes:
        proto_match = re.search(r'(forward prototypes)', new_code, re.IGNORECASE)
        if proto_match:
            new_code = re.sub(r'(forward prototypes)', r'\1\n' + new_event_prototypes.strip(), new_code, count=1, flags=re.IGNORECASE)
        else:
            forward_match = re.search(r'(^forward\n)', new_code, re.MULTILINE | re.IGNORECASE)
            if forward_match:
                new_code = re.sub(r'(^forward\n)', r'\1' + new_event_prototypes, new_code, count=1, flags=re.MULTILINE | re.IGNORECASE)
            else:
                new_prototype_block = f'forward\n{new_event_prototypes}end forward\n\n'
                header_match = re.search(r'(\$PBExportHeader\$.*?\$PBExportComments\$.*?(\n){1,2})', new_code, re.DOTALL)
                if header_match:
                    insert_pos = header_match.end()
                    new_code = new_code[:insert_pos] + new_prototype_block + new_code[insert_pos:]
                else:
                    new_code = new_prototype_block + new_code

    final_code = new_code.replace(injection_point_match.group(0), injection_point_match.group(0) + injection_code + '\n')

    report = {
        "rule": "P-08",
        "status": "적용됨",
        "details": f"{len(added_events)}개의 표준 MDI 이벤트를 추가했습니다: {', '.join(added_events)}"
    }

    return final_code, report