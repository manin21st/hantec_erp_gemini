"""
P-02: 이미지 버튼 클릭 이벤트 마이그레이션 및 재배치 규칙

[목적]
PowerBuilder 10의 이미지 버튼(p_retrieve 등) `clicked` 이벤트를 10.5의 표준 사용자 이벤트(ue_retrieve 등)로 변환하고,
변환된 이벤트 블록을 윈도우의 올바른 위치로 재배치합니다.

[작동 방식]
1. 한 줄씩 코드를 순회하며 `event <이미지_버튼>::clicked;`로 시작하고 `end event`로 끝나는 이벤트 블록을 식별합니다.
2. 이벤트 블록 내부에 `call super::clicked;` 외의 실제 처리 로직이 있는지 확인합니다.
3. 로직이 있는 블록만 변환 대상으로 삼습니다.
4. 변환된 블록은 별도의 리스트에 저장하고, 원본 블록의 라인들은 삭제 목록에 추가합니다.
5. 모든 라인 순회가 끝나면, 삭제 목록의 라인들을 제외하여 새 코드 본문을 만듭니다.
6. `type [컨트롤명] from [부모객체] within [윈도우명]` 패턴을 찾아 첫 번째 컨트롤 정의 시작점을 찾습니다.
7. 이 시작점 바로 앞에, 변환된 이벤트 블록들을 앞뒤 한 줄 공백과 함께 삽입합니다.
"""
import re

class P02Rule:
    """
    P-02: 이미지 버튼 이벤트를 변환하고 올바른 위치로 재배치하는 규칙.
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

    def _has_logic(self, event_block_lines):
        """
        이벤트 블록에 'call super::clicked;' 외의 실제 로직이 있는지 확인합니다.
        주석이나 공백 라인을 제외하고 실제 코드 라인 수를 셉니다.
        """
        logic_lines = 0
        for line in event_block_lines[1:-1]: # event, end event 제외
            stripped_line = line.strip()
            if not stripped_line:
                continue
            if stripped_line.startswith('//'):
                continue
            if re.fullmatch(r"call\s+super::clicked\s*;", stripped_line, re.IGNORECASE):
                continue
            logic_lines += 1
        return logic_lines > 0

    def apply(self, source_code: str, logger=None) -> tuple:
        if logger is None:
            logger = lambda *args, **kwargs: None

        # 원본 줄바꿈 문자 보존을 위해 keepends=True 사용
        lines = source_code.splitlines(keepends=True)
        # 소스코드에서 가장 많이 사용된 줄바꿈 문자를 감지하여 새로 추가하는 줄에 사용
        crlf_count = source_code.count('\r\n')
        lf_count = source_code.count('\n') - crlf_count
        newline_char = '\r\n' if crlf_count >= lf_count else '\n'

        reports = []
        migrated_event_blocks = []
        lines_to_delete_indices = set()
        
        in_event_block = False
        current_block_lines = []
        current_block_start_idx = -1
        
        # --- Phase 1: Extract, Transform, and Mark for Deletion ---
        for i, line in enumerate(lines):
            stripped_line_lower = line.strip().lower()

            if not in_event_block:
                for old_control in self.MAPPING.keys():
                    if stripped_line_lower.startswith(f"event {old_control}::clicked;"):
                        in_event_block = True
                        current_block_start_idx = i
                        current_block_lines = [] # 버그 수정: 빈 리스트로 초기화
                        break
            
            if in_event_block:
                current_block_lines.append(line) # 버그 수정: 라인 중복 검사 없이 추가

                if stripped_line_lower == "end event":
                    in_event_block = False
                    
                    old_control_name = ""
                    # 시작 라인에서 정확한 컨트롤 이름 다시 찾기
                    start_line_lower = lines[current_block_start_idx].strip().lower()
                    for p_ctrl in self.MAPPING:
                         if start_line_lower.startswith(f"event {p_ctrl}::clicked;"):
                              old_control_name = p_ctrl
                              break
                    
                    if not old_control_name:
                        current_block_lines = []
                        current_block_start_idx = -1
                        continue

                    new_event_name = self.MAPPING[old_control_name]

                    if self._has_logic(current_block_lines):
                        transformed_block = []
                        # 버그 수정: 모든 라인에 대해 변환 로직 적용
                        for idx, block_line in enumerate(current_block_lines):
                            processed_line = block_line
                            # 1. 헤더 변환 (첫 번째 라인에만)
                            if idx == 0:
                                processed_line = re.sub(
                                    f"event\\s+{re.escape(old_control_name)}::clicked\\s*;",
                                    f"event {new_event_name};",
                                    processed_line,
                                    count=1,
                                    flags=re.IGNORECASE
                                )
                            
                            # 2. 'call super::clicked' 변환 (모든 라인에)
                            processed_line = re.sub(
                                r"call\s+super::clicked\s*;",
                                f"call super::{new_event_name};",
                                processed_line,
                                flags=re.IGNORECASE
                            )
                            transformed_block.append(processed_line)
                        
                        migrated_event_blocks.append("".join(transformed_block))
                        lines_to_delete_indices.update(range(current_block_start_idx, i + 1))
                        
                        reports.append({
                            "rule": "P-02", "status": "Success",
                            "details": f"Migrated and marked event '{old_control_name}::clicked' for relocation."
                        })

                    current_block_lines = []
                    current_block_start_idx = -1

        # --- Phase 2: Rebuild code with relocations ---
        if not migrated_event_blocks:
            return source_code, reports

        final_lines = [line for i, line in enumerate(lines) if i not in lines_to_delete_indices]

        insertion_idx = -1
        search_start_index = 0
        for i, line in enumerate(final_lines):
            if line.strip().lower() == "end forward":
                search_start_index = i + 1
                break
        
        window_name = ""
        for line in final_lines:
            match = re.search(r"global\s+type\s+(\w+)\s+from", line, re.IGNORECASE)
            if match:
                window_name = match.group(1)
                break
        
        if window_name:
            pattern = re.compile(r"^\s*type\s+\S+\s+from\s+\S+\s+within\s+" + re.escape(window_name), re.IGNORECASE)
            for i in range(search_start_index, len(final_lines)):
                line = final_lines[i]
                if pattern.search(line):
                    insertion_idx = i
                    break
        
        if insertion_idx == -1:
            insertion_idx = len(final_lines)

        full_migrated_block_str = (newline_char * 2).join(migrated_event_blocks)

        # 줄바꿈 보존을 위해 로직 단순화
        if insertion_idx > 0:
            final_lines.insert(insertion_idx, newline_char)
            insertion_idx += 1

        final_lines.insert(insertion_idx, full_migrated_block_str)
        
        if insertion_idx < len(final_lines):
             final_lines.insert(insertion_idx + 1, newline_char)

        return "".join(final_lines), reports
