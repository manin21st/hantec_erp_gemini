"""
P-03: 오래된 이미지 버튼 참조 수정 규칙 (Obsolete Image Button Reference Refinement Rule)

목적:
P-02 규칙에 의해 마이그레이션된 이벤트 코드 내에서, 더 이상 사용되지 않는 이미지 버튼 컨트롤(예: p_print)에 대한
특정 속성 접근 구문을 새로운 표준 함수 호출로 대체하거나 주석 처리하여 컴파일 오류를 방지합니다.
이는 P-01 규칙이 해당 이미지 버튼 컨트롤 자체를 주석 처리하기 전에, 그 사용처를 정리하는 역할을 합니다.

작동 방식:
1.  미리 정의된 이미지 버튼 컨트롤 목록(예: `p_retrieve`, `p_print` 등)을 사용합니다.
2.  소스 코드 전체를 스캔하여 다음 패턴을 찾습니다:
    a.  **`.Enabled` 속성 변경:** `p_print.Enabled = True/False` 형태의 구문을 찾습니다.
        이를 `w_mdi_frame.uo_toolbarstrip.of_SetEnabled("메뉴텍스트", true/false)` 형태의 함수 호출로 대체합니다.
        `메뉴텍스트`는 컨트롤에 매핑된 특정 문자열(예: "출력(&P)")을 사용하고, 불리언 값은 소문자로 변환합니다.
    b.  **`.PictureName` 속성 변경:** `p_print.PictureName = '...'` 형태의 구문을 찾습니다.
        이러한 구문은 대체할 표준 함수가 없으므로, 해당 라인 전체를 `//& `를 붙여 주석 처리합니다.
3.  이 규칙은 P-02 규칙이 이벤트 로직을 마이그레이션한 후에 실행되어, 마이그레이션된 코드 내의 참조를 정리합니다.

처리 순서:
-   P-02 (이미지 버튼 이벤트 마이그레이션) 규칙이 적용된 후에 실행됩니다.
-   P-01 (오래된 상속 컨트롤 정리) 규칙이 적용되기 전에 실행됩니다.
"""
import re

class P03Rule:
    """
    P-03: 오래된 이미지 버튼 참조 수정 규칙
    - .Enabled 속성 변경은 of_SetEnabled() 호출로 대체
    - .PictureName 속성 변경은 주석 처리
    """
    MAPPING = {
        'p_retrieve': '조회(&Q)',
        'p_inq': '조회(&Q)',
        'p_ins': '추가(&A)',
        'p_del': '삭제(&D)',
        'p_mod': '저장(&S)',
        'p_xls': '엑셀변환(&E)',
        'p_print': '출력(&P)',
        'p_preview': '미리보기(&R)',
        'p_search': '찾기(&T)',
    }

    def apply(self, source_code: str, logger=None) -> tuple:
        if logger is None:
            logger = print

        reports = []
        lines = source_code.splitlines()
        new_lines = []
        
        # .PictureName 패턴
        picture_name_pattern = re.compile(r"^\s*(" + "|".join(re.escape(k) for k in self.MAPPING.keys()) + r")\.PictureName\s*=", re.IGNORECASE)
        
        # .Enabled 패턴
        enabled_pattern = re.compile(r"^\s*(" + "|".join(re.escape(k) for k in self.MAPPING.keys()) + r")\.Enabled\s*=\s*(True|False)\s*$", re.IGNORECASE)

        for line in lines:
            # Enabled 속성 대체
            enabled_match = enabled_pattern.search(line)
            if enabled_match:
                control_name = enabled_match.group(1).lower()
                bool_val = enabled_match.group(2).lower()
                menu_text = self.MAPPING.get(control_name)
                
                if menu_text:
                    indentation = line[:line.find(control_name)]
                    new_line = f'{indentation}w_mdi_frame.uo_toolbarstrip.of_SetEnabled("{menu_text}", {bool_val})'
                    new_lines.append(new_line)
                    
                    details = f"Replaced '{line.strip()}' with '{new_line.strip()}'"
                    reports.append({"rule": "P-03", "status": "Success", "details": details})
                    logger(f"INFO: P-03 - {details}")
                    continue

            # PictureName 속성 주석 처리
            picture_name_match = picture_name_pattern.search(line)
            if picture_name_match:
                new_line = f"//& {line}"
                new_lines.append(new_line)

                details = f"Commented out PictureName assignment: '{line.strip()}'"
                reports.append({"rule": "P-03", "status": "Success", "details": details})
                logger(f"INFO: P-03 - {details}")
                continue

            new_lines.append(line)

        if not reports:
            reports.append({"rule": "P-03", "status": "Skipped", "details": "No applicable property assignments found."})

        return '\n'.join(new_lines), reports
