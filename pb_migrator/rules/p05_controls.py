# -*- coding: utf-8 -*-
"""
마이그레이션 규칙: P-05 불필요한 장식용 컨트롤 삭제
"""

import re

def apply(code, **kwargs):
    """
    P-05 규칙: 미적인 용도로만 사용되는 레거시 그래픽 컨트롤을 삭제합니다.

    대상 컨트롤: `rr_*` (RoundRectangle), `ln_*` (Line), `gb_*` (GroupBox)
    이 컨트롤들은 P-07 규칙에서 새로운 `Rectangle` 기반 레이아웃으로 대체됩니다.
    이 규칙은 해당 컨트롤의 선언부, 정의부, 관련 이벤트 스크립트(create, destroy)를 찾아 삭제합니다.

    Args:
        code (str): 변환할 원본 소스 코드입니다.
        **kwargs: 추가 파라미터입니다. (이 규칙에서는 사용되지 않음)

    Returns:
        tuple: 변환된 코드와 실행 결과 리포트를 담은 튜플을 반환합니다.
    """
    
    removed_controls = []

    # 1. 삭제 대상인 모든 장식용 컨트롤의 이름을 찾습니다. (rr_*, ln_*, gb_*)
    # `type ... from ...` 구문을 기반으로 컨트롤의 타입과 이름을 식별합니다.
    control_names = re.findall(r'type\s+((?:rr_|ln_|gb_)[\w_]+)\s+from', code, re.IGNORECASE)
    
    if not control_names:
        return code, {"rule": "P-05", "status": "해당 없음", "details": "삭제할 장식용 컨트롤을 찾지 못했습니다."}

    modified_code = code
    # 중복 제거를 위해 set으로 변환 후 다시 list로 만듭니다.
    for name in sorted(list(set(control_names))):
        # 2. 컨트롤의 메인 정의 블록 (`type ... end type`)을 삭제합니다.
        # re.DOTALL 플래그를 사용하여 여러 줄에 걸친 블록을 한 번에 찾습니다.
        # 참고: 이 정규식은 중첩된 `type...end type` 구조가 있을 경우 완벽하게 동작하지 않을 수 있습니다.
        # 가장 바깥쪽의 `end type`을 기준으로 매칭하기 때문입니다.
        pattern_main_def = re.compile(r'type\s+%s\s+from\s+\w+.*?end type' % name, re.DOTALL | re.IGNORECASE)
        modified_code = pattern_main_def.sub('''''', modified_code)
        
        # 3. `forward prototypes` 내의 선언을 삭제합니다. (메인 정의와 유사한 형태)
        pattern_forward_def = re.compile(r'type\s+%s\s+from\s+\w+\s+within\s+\w+.*?end type' % name, re.DOTALL | re.IGNORECASE)
        modified_code = pattern_forward_def.sub('''''', modified_code)

        # 4. 인스턴스 변수 선언 (`[control_type] [control_name]`)을 삭제합니다.
        # PowerBuilder에서는 컨트롤을 스크립트에서 직접 참조하기 위해 인스턴스 변수로 선언하는 경우가 있습니다.
        pattern_ivar = re.compile(r'^\s*\w+\s+%s\s*?$\r?\n' % name, re.MULTILINE | re.IGNORECASE)
        modified_code = pattern_ivar.sub('''''', modified_code)

        # 5. create 이벤트 내의 생성 관련 코드를 삭제합니다.
        pattern_create1 = re.compile(r'^\s*this\.Control\[\w+\]\s*=\s*this\.%s\s*?$\r?\n' % name, re.MULTILINE | re.IGNORECASE)
        pattern_create2 = re.compile(r'^\s*this\.%s\s*=\s*create\s+%s\s*?$\r?\n' % (name, name), re.MULTILINE | re.IGNORECASE)
        modified_code = pattern_create1.sub('''''', modified_code)
        modified_code = pattern_create2.sub('''''', modified_code)

        # 6. destroy 이벤트 내의 파괴 관련 코드를 삭제합니다.
        pattern_destroy = re.compile(r'^\s*destroy\s*\(\s*this\.%s\s*\)\s*?$\r?\n' % name, re.MULTILINE | re.IGNORECASE)
        modified_code = pattern_destroy.sub('''''', modified_code)

        removed_controls.append(name)

    # 여러 컨트롤이 삭제되면서 생긴 연속된 빈 줄들을 하나로 정리합니다.
    modified_code = re.sub(r'(\r?\n){3,}', '\r\n\r\n', modified_code)

    if not removed_controls:
         return code, {"rule": "P-05", "status": "해당 없음", "details": "삭제할 장식용 컨트롤을 찾지 못했습니다."}

    report = {
        "rule": "P-05",
        "status": "적용됨",
        "details": f"{len(removed_controls)}개의 장식용 컨트롤을 삭제했습니다: {', '.join(sorted(removed_controls))}"
    }

    return modified_code, report
