# -*- coding: utf-8 -*-
"""
마이그레이션 규칙: P-03 사용자 이벤트 프로토타입 선언
"""

import re

def apply(code, **kwargs):
    """
    P-03 규칙: 윈도우에 정의된 사용자 정의 이벤트(ue_*)가 `forward` 또는 `forward prototypes` 섹션에 선언되어 있지 않으면 추가합니다.

    PowerBuilder 10.5에서는 프로토타입이 선언되지 않은 사용자 이벤트를 호출할 경우 컴파일 오류가 발생할 수 있습니다.
    이 규칙은 스크립트 전체에서 `event ue_...` 정의를 찾아, 선언부에 누락된 것들을 자동으로 추가합니다.
    """
    
    # 1. 스크립트 전체에서 정의된 모든 사용자 이벤트(ue_*)를 찾습니다.
    defined_events = set(re.findall(r'^event\s+(ue_\w+)', code, re.MULTILINE | re.IGNORECASE))
    
    if not defined_events:
        return code, {"rule": "P-03", "status": "해당 없음", "details": "스크립트에서 사용자 이벤트(ue_*)를 찾지 못했습니다."}

    # 2. `forward prototypes` 또는 `forward` 섹션을 찾습니다.
    proto_match = re.search(r'(forward prototypes)(.*?)(end prototypes)', code, re.DOTALL | re.IGNORECASE)
    forward_match = None
    if not proto_match:
        forward_match = re.search(r'(^forward\r?\n)([\s\S]*?)(^end forward\r?\n)', code, re.MULTILINE | re.IGNORECASE)

    declared_events = set()
    prototypes_content = ""
    if proto_match:
        prototypes_content = proto_match.group(2)
        declared_events = set(re.findall(r'event\s+(ue_\w+)', prototypes_content, re.IGNORECASE))
    elif forward_match:
        prototypes_content = forward_match.group(2)
        declared_events = set(re.findall(r'event\s+(ue_\w+)', prototypes_content, re.IGNORECASE))

    # 3. 정의된 이벤트와 선언된 이벤트를 비교하여, 선언이 누락된 이벤트를 찾습니다.
    missing_events = defined_events - declared_events

    if not missing_events:
        return code, {"rule": "P-03", "status": "해당 없음", "details": "모든 사용자 이벤트가 이미 선언되어 있습니다."}

    # 4. 누락된 이벤트를 프로토타입 블록에 추가합니다.
    new_declarations = ""
    for event in sorted(list(missing_events)):
        new_declarations += f'\r\nevent {event} ( )'
    
    new_code = code
    if proto_match:
        new_prototype_block = f'forward prototypes{prototypes_content}{new_declarations}\r\nend prototypes'
        new_code = code.replace(proto_match.group(0), new_prototype_block)
    elif forward_match:
        new_block_content = prototypes_content.rstrip() + new_declarations + '\r\n'
        new_prototype_block = f'forward\r\n{new_block_content}end forward\r\n'
        new_code = code.replace(forward_match.group(0), new_prototype_block)
    else:
        # forward 블록이 없으면 새로 생성
        new_prototype_block = f'forward{new_declarations}\r\nend forward\r\n\r\n'
        header_match = re.search(r'(\$PBExportHeader\$.*?\$PBExportComments\$.*?[\r\n]{1,2})', code, re.DOTALL)
        if header_match:
            insert_pos = header_match.end()
            new_code = code[:insert_pos] + new_prototype_block + code[insert_pos:]
        else:
            new_code = new_prototype_block + code # 헤더가 없는 경우 맨 앞에 추가

    report = {
        "rule": "P-03",
        "status": "적용됨",
        "details": f"{len(missing_events)}개의 누락된 이벤트 프로토타입을 추가했습니다: {', '.join(sorted(list(missing_events)))}"
    }

    return new_code, report
