# -*- coding: utf-8 -*-
"""
마이그레이션 규칙: P-01 인코딩 & 줄바꿈
"""

def apply(code, **kwargs):
    """
    P-01 규칙: 파일 인코딩을 UTF-16 LE로, 줄바꿈 문자를 CRLF로 변환합니다.

    [중요] 이 규칙의 실제 로직은 `gui.py`의 파일 저장 기능(`save_file`, `process_batch`)에 구현되어 있습니다.
    파일을 저장할 때 `encoding='utf-16-le'`와 `newline='\r\n'` 옵션을 사용하여 처리합니다.

    따라서 이 모듈은 실제 코드 변환을 수행하지 않고, 해당 처리가 저장 시점에 이루어진다는 것을
    리포트에 명시하는 역할만 합니다.

    Args:
        code (str): 변환할 원본 소스 코드입니다. (이 규칙에서는 사용되지 않음)
        **kwargs: 추가 파라미터입니다. (이 규칙에서는 사용되지 않음)

    Returns:
        tuple: 원본 코드와, 규칙 처리 방식을 설명하는 리포트를 담은 튜플을 반환합니다.
    """
    report = {
        "rule": "P-01", 
        "status": "저장 시 처리", 
        "details": "파일 저장 시점에 인코딩은 UTF-16 LE, 줄바꿈은 CRLF로 자동 변환됩니다."
    }
    # 코드 변환 없이 그대로 반환합니다.
    return code, report

