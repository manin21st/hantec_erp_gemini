# -*- coding: utf-8 -*-
"""
마이그레이션 규칙: P-02 상속 컨트롤 재정의
"""

import re

def apply(code, **kwargs):
    """
    P-02 규칙: 부모 윈도우(w_inherite)로부터 상속받은 컨트롤의 속성 변경을 처리합니다.

    `visible = false` 속성은 PowerBuilder 10.5에서 오류를 유발할 수 있으므로,
    이 속성을 사용하는 대신 컨트롤의 x, y 좌표를 화면 밖의 큰 값으로 변경하여 숨깁니다.

    Args:
        code (str): 변환할 원본 소스 코드입니다.
        **kwargs: 추가 파라미터입니다. (이 규칙에서는 사용되지 않음)

    Returns:
        tuple: 변환된 코드와 실행 결과 리포트를 담은 튜플을 반환합니다.
    """
    
    # `visible = false`를 포함하는 상속된 컨트롤의 `type...end type` 블록을 찾는 정규식입니다.
    # 그룹 1: `type`부터 `visible` 직전까지
    # 그룹 2: 컨트롤 이름
    # 그룹 3: `visible = false` 구문
    # 그룹 4: `visible` 이후부터 `end type` 까지
    pattern = re.compile(r'(type\s+([\w_]+)\s+from\s+w_inherite`[\w_]+.*?)(visible\s*=\s*false)(.*?end type)', re.DOTALL | re.IGNORECASE)
    
    modified_controls = []
    
    def replace_visibility(match):
        """정규식에 매치된 부분을 새로운 좌표 값으로 교체하는 함수입니다."""
        control_name = match.group(2)
        if control_name not in modified_controls:
            modified_controls.append(control_name)
        
        block_start = match.group(1)
        block_end = match.group(4)
        
        # 기존의 x, y 좌표 할당 구문이 있다면 충돌을 피하기 위해 제거합니다.
        block_start = re.sub(r'\s*integer\s+x\s*=\s*\d+', '', block_start, flags=re.IGNORECASE)
        block_start = re.sub(r'\s*integer\s+y\s*=\s*\d+', '', block_start, flags=re.IGNORECASE)
        block_end = re.sub(r'\s*integer\s+x\s*=\s*\d+', '', block_end, flags=re.IGNORECASE)
        block_end = re.sub(r'\s*integer\s+y\s*=\s*\d+', '', block_end, flags=re.IGNORECASE)

        # `visible = false` 대신 화면 밖 좌표를 설정하는 코드로 교체합니다.
        replacement = 'x = 2727\n\t\ty = 1500'
        return block_start + replacement + block_end

    # 코드 내에 여러 개의 대상이 있을 수 있으므로, 더 이상 변경이 없을 때까지 반복적으로 치환을 수행합니다.
    new_code = code
    while True:
        new_code, count = pattern.subn(replace_visibility, new_code)
        if count == 0:
            break

    if not modified_controls:
        return code, {"rule": "P-02", "status": "해당 없음", "details": "'visible = false' 속성을 가진 상속 컨트롤을 찾지 못했습니다."}

    report = {
        "rule": "P-02",
        "status": "적용됨",
        "details": f"{len(modified_controls)}개의 상속된 컨트롤을 화면 밖으로 이동시켰습니다: {', '.join(modified_controls)}"
    }

    return new_code, report