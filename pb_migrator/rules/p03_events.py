# -*- coding: utf-8 -*-
"""
마이그레이션 규칙: P-03 사용자 이벤트 프로토타입 선언
"""

import re

def apply(code, **kwargs):
    """
    P-03 규칙: 윈도우에 정의된 사용자 정의 이벤트(ue_*)가 `forward prototypes` 섹션에 선언되어 있지 않으면 추가합니다.

    PowerBuilder 10.5에서는 프로토타입이 선언되지 않은 사용자 이벤트를 호출할 경우 컴파일 오류가 발생할 수 있습니다.
    이 규칙은 스크립트 전체에서 `event ue_...` 정의를 찾아, 선언부에 누락된 것들을 자동으로 추가합니다.

    Args:
        code (str): 변환할 원본 소스 코드입니다.
        **kwargs: 추가 파라미터입니다. (이 규칙에서는 사용되지 않음)

    Returns:
        tuple: 변환된 코드와 실행 결과 리포트를 담은 튜플을 반환합니다.
    """
    
    # 1. 스크립트 전체에서 정의된 모든 사용자 이벤트(ue_*)를 찾습니다.
    defined_events = set(re.findall(r'^event\s+(ue_\w+)', code, re.MULTILINE | re.IGNORECASE))
    
    if not defined_events:
        return code, {"rule": "P-03", "status": "해당 없음", "details": "스크립트에서 사용자 이벤트(ue_*)를 찾지 못했습니다."}

    # 2. `forward prototypes` 섹션을 찾습니다.
    prototypes_match = re.search(r'(forward prototypes)(.*?)(end prototypes)', code, re.DOTALL | re.IGNORECASE)
    
    if not prototypes_match:
        # 프로토타입 블록이 없는 경우, 이 규칙은 아무 작업도 수행하지 않습니다.
        # (더 발전된 규칙은 블록을 직접 생성할 수도 있겠지만, 현재는 있는 블록에 추가만 합니다.)
        return code, {"rule": "P-03", "status": "건너뜀", "details": "'forward prototypes' 섹션을 찾지 못했습니다."}

    prototype_block = prototypes_match.group(0) # `forward`부터 `end`까지 전체 블록
    prototypes_content = prototypes_match.group(2) # 블록 내부의 실제 내용

    # 3. 프로토타입 블록 내에 이미 선언된 이벤트를 찾습니다.
    declared_events = set(re.findall(r'event\s+(ue_\w+)', prototypes_content, re.IGNORECASE))

    # 4. 정의된 이벤트와 선언된 이벤트를 비교하여, 선언이 누락된 이벤트를 찾습니다.
    missing_events = defined_events - declared_events

    if not missing_events:
        return code, {"rule": "P-03", "status": "해당 없음", "details": "모든 사용자 이벤트가 이미 선언되어 있습니다."}

    # 5. 누락된 이벤트를 프로토타입 블록에 추가합니다.
    new_prototypes_content = prototypes_content
    for event in sorted(list(missing_events)):
        # 현재는 인자(argument)가 없는 간단한 형태로 선언합니다.
        new_prototypes_content += f'\r\nevent {event} ( )'
    
    # 기존 프로토타입 블록을 새로 구성된 블록으로 교체합니다.
    new_prototype_block = f'forward prototypes{new_prototypes_content}\r\nend prototypes'
    new_code = code.replace(prototype_block, new_prototype_block)

    report = {
        "rule": "P-03",
        "status": "적용됨",
        "details": f"{len(missing_events)}개의 누락된 이벤트 프로토타입을 추가했습니다: {', '.join(sorted(list(missing_events)))}"
    }

    return new_code, report
