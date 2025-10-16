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

    # 2. `forward prototypes` 또는 `forward` 섹션에 이미 선언된 이벤트를 찾습니다.
    forward_block_match = re.search(r'(^forward\n|forward prototypes)([\s\S]*?)(^end forward\n|end prototypes)', code, re.MULTILINE | re.IGNORECASE)
    declared_events = set()
    if forward_block_match:
        prototypes_content = forward_block_match.group(2)
        declared_events = set(re.findall(r'event\s+(ue_\w+)', prototypes_content, re.IGNORECASE))

    # 3. 정의된 이벤트와 선언된 이벤트를 비교하여, 선언이 누락된 이벤트를 찾습니다.
    missing_events = defined_events - declared_events

    if not missing_events:
        return code, {"rule": "P-03", "status": "해당 없음", "details": "모든 사용자 이벤트가 이미 선언되어 있습니다."}

    # 4. 누락된 이벤트를 프로토타입 선언문으로 만듭니다.
    new_declarations = ""
    for event in sorted(list(missing_events)):
        new_declarations += f'event {event} ( )\n'

    new_code = code
    
    # 5. 기존 forward 블록에 삽입하거나, 없으면 새로 생성합니다.
    # `forward prototypes` 블록이 있으면 그 안에 추가합니다.
    proto_match = re.search(r'(forward prototypes)', new_code, re.IGNORECASE)
    if proto_match:
        # `forward prototypes` 바로 다음 줄에 누락된 선언들을 삽입합니다.
        new_code = re.sub(r'(forward prototypes)', r'\1\n' + new_declarations.strip(), new_code, count=1, flags=re.IGNORECASE)
    else:
        # `forward` 블록이 있으면 그 안에 추가합니다.
        forward_match = re.search(r'(^forward\n)', new_code, re.MULTILINE | re.IGNORECASE)
        if forward_match:
            # `forward` 바로 다음 줄에 누락된 선언들을 삽입합니다.
            new_code = re.sub(r'(^forward\n)', r'\1' + new_declarations, new_code, count=1, flags=re.MULTILINE | re.IGNORECASE)
        else:
            # forward 블록이 없으면 새로 생성합니다.
            new_prototype_block = f'forward\n{new_declarations}end forward\n\n'
            header_match = re.search(r'(\$PBExportHeader\$.*?\$PBExportComments\$.*?(\n){1,2})', new_code, re.DOTALL)
            if header_match:
                insert_pos = header_match.end()
                new_code = new_code[:insert_pos] + new_prototype_block + new_code[insert_pos:]
            else:
                new_code = new_prototype_block + new_code # 헤더가 없는 경우 맨 앞에 추가

    report = {
        "rule": "P-03",
        "status": "적용됨",
        "details": f"{len(missing_events)}개의 누락된 이벤트 프로토타입을 추가했습니다: {', '.join(sorted(list(missing_events)))}"
    }

    return new_code, report