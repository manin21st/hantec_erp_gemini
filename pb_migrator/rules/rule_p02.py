"""
P-02: 이미지 버튼 클릭 이벤트 마이그레이션 규칙 (Image Button Click Event Migration Rule)

목적:
PowerBuilder 10에서 사용되던 이미지 버튼(예: p_retrieve)의 `clicked` 이벤트 로직을
PowerBuilder 10.5의 표준 사용자 이벤트(UE, 예: ue_retrieve)로 마이그레이션합니다.
이를 통해 10.5 환경에서 권장되는 이벤트 처리 방식으로 전환합니다.

작동 방식:
1.  미리 정의된 매핑(예: `p_retrieve` -> `ue_retrieve`)에 따라 소스 코드 내에서
    `event <이미지_버튼>::clicked;` 형태의 이벤트 블록을 찾습니다.
2.  해당 이벤트 블록 내부에 실제 로직(빈 내용이 아닌 경우)이 존재하는지 확인합니다.
3.  로직이 존재하는 경우, 이벤트 선언을 `event <매핑된_UE>;` 형태로 변경하고,
    이벤트 내부의 `call super::clicked;` 구문도 `call super::<매핑된_UE>;` 형태로 변경합니다.
4.  이벤트 블록 내부에 로직이 없는 경우(빈 이벤트), 해당 이벤트 블록은 변경하지 않고 그대로 둡니다.
    이후 P-01 규칙에 의해 해당 이미지 버튼 컨트롤과 함께 주석 처리될 것입니다.

처리 순서:
-   P-03 (오래된 이미지 버튼 참조 수정) 규칙이 적용되기 전에 실행됩니다.
-   P-01 (오래된 상속 컨트롤 정리) 규칙이 적용되기 전에 실행됩니다.
"""
import re

class P02Rule:
    """
    P-02: 이미지 버튼 클릭 이벤트를 사용자 이벤트(UE)로 마이그레이션하는 규칙.
    """
    MAPPING = {
        'p_retrieve': 'ue_retrieve',
        'p_inq': 'ue_retrieve',
        'p_ins': 'ue_append',
        'p_del': 'ue_delete',
        'p_mod': 'ue_update',
        'p_can': 'ue_cancel',
        'p_xls': 'ue_excel',
        'p_print': 'ue_print',
        'p_preview': 'ue_preview',
        'p_search': 'ue_seek',
    }

    def apply(self, source_code: str, logger=None) -> tuple:
        if logger is None:
            logger = print

        reports = []
        modified_source_code = source_code
        
        for old_control, new_event in self.MAPPING.items():
            # Regex to find the entire event block
            event_pattern = re.compile(
                r"^(event\s+" + re.escape(old_control) + r"::clicked;)(.*?)(^end event)$",
                re.IGNORECASE | re.MULTILINE | re.DOTALL
            )

            def replacer(match):
                header = match.group(1)
                content = match.group(2)
                footer = match.group(3)

                # Trim whitespace to check if content is empty
                trimmed_content = content.strip()
                if not trimmed_content:
                    # If content is empty, do not change anything. P-01 will handle it.
                    return match.group(0)

                # Migrate the event
                new_header = f"event {new_event};"
                
                # Migrate "call super::clicked;" to "call super::new_event;"
                migrated_content = re.sub(
                    r"call\s+super::clicked;",
                    f"call super::{new_event};",
                    content,
                    flags=re.IGNORECASE
                )
                
                logger(f"INFO: P-02 - Migrating event '{old_control}::clicked' to '{new_event}'.")
                reports.append({
                    "rule": "P-02",
                    "status": "Success",
                    "details": f"Migrated event '{old_control}::clicked' to '{new_event}'."
                })
                
                return new_header + migrated_content + footer

            modified_source_code = event_pattern.sub(replacer, modified_source_code)

        if not reports:
            reports.append({"rule": "P-02", "status": "Skipped", "details": "No applicable events found to migrate."})

        return modified_source_code, reports
