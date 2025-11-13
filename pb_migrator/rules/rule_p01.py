"""
P-01: 오래된 상속 컨트롤 정리 규칙 (Obsolete Inherited Control Cleanup Rule)

목적:
자식 윈도우에서 더 이상 부모 윈도우에 존재하지 않는 '오래된 상속 컨트롤'과
그에 대한 모든 참조를 주석 처리하여 PowerBuilder 10.5 환경에서의 컴파일 오류를 방지합니다.
P-02, P-03 규칙이 처리하지 않는 모든 종류의 오래된 상속 컨트롤을 최종적으로 정리하는 역할을 합니다.

작동 방식:
1.  자식 윈도우의 소스 코드를 파싱하여 윈도우 이름, 부모 윈도우 이름, 그리고 모든 컨트롤 정보를 추출합니다.
2.  `target/_reference` 폴더에서 해당 부모 윈도우의 최신 소스 코드를 읽어와 동일한 방식으로 컨트롤 정보를 추출합니다.
3.  자식 윈도우의 컨트롤 중 'from 타입'에 부모 윈도우 이름이 포함된 경우를 '상속 컨트롤'로 식별합니다.
4.  식별된 '상속 컨트롤'이 현재 부모 윈도우에 존재하지 않으면 '오래된 컨트롤'로 간주하고, 이들의 전체 목록을 생성합니다.
5.  **1단계 (정의 블록 주석 처리):** 생성된 '오래된 컨트롤' 목록을 사용하여, 해당 컨트롤들의 `type...end type` 블록과 `event...end type` 블록 전체를 찾아 주석 처리할 라인으로 표시합니다. 이렇게 하면 PowerBuilder 파서가 해당 블록을 무시하게 됩니다.
6.  **2단계 (개별 참조 라인 주석 처리):** 위에서 블록 단위로 처리되지 않은 코드 라인들 중에서 '오래된 컨트롤'을 참조하는 개별 라인들을 찾아 주석 처리할 라인으로 추가 표시합니다.
7.  최종적으로 표시된 모든 라인에 `//& `를 붙여 주석 처리합니다.
8.  마지막으로, PBMigrator가 파일을 수정했음을 알리는 헤더 주석을 파일 상단에 추가합니다.

처리 순서:
-   P-02 (이미지 버튼 이벤트 마이그레이션) 및 P-03 (오래된 이미지 버튼 참조 수정) 규칙이 모두 적용된 후에 실행됩니다.
"""
import os
import re
from datetime import datetime
# parse_pb_source and PBWindowInfo will be moved to engine.py, so we import them from there.
# This import will be updated after engine.py is refactored.
from pb_migrator.engine import parse_pb_source, PBWindowInfo, ControlInfo

class P01Rule:
    """
    P-01: 부모-자식 윈도우 동기화 규칙을 적용하는 클래스.
    """
    def apply(self, source_code: str, reference_folder: str, logger=None) -> tuple:
        if logger is None:
            logger = print

        reports = []

        try:
            # 1. 자식 및 부모 윈도우 정보 파싱
            child_info = parse_pb_source(source_code)
            if not child_info.name:
                reports.append({"rule": "P-01", "status": "Skipped", "details": "Not an inheritance window or parsing failed for child."})
                return source_code, reports

            parent_source_path = os.path.join(reference_folder, f"{child_info.parent}.srw")
            try:
                with open(parent_source_path, 'r', encoding='utf-16', errors='strict') as f:
                    parent_source_code = f.read()
            except (FileNotFoundError, UnicodeDecodeError):
                with open(parent_source_path, 'r', encoding='cp949', errors='ignore') as f:
                    parent_source_code = f.read()
            
            parent_info = parse_pb_source(parent_source_code)
            if not parent_info.name:
                reports.append({"rule": "P-01", "status": "Error", "details": f"Parent window parsing failed: {parent_source_path}"})
                return source_code, reports

        except FileNotFoundError:
            reports.append({"rule": "P-01", "status": "Error", "details": f"Parent window source file not found: {parent_source_path}"})
            return source_code, reports
        except Exception as e:
            reports.append({"rule": "P-01", "status": "Error", "details": f"Parsing failed: {e}"})
            return source_code, reports

        # 2. 모든 '오래된 상속 컨트롤' 식별
        parent_control_names = {ctrl.name for ctrl in parent_info.controls}
        parent_name = child_info.parent.lower()
        obsolete_control_names = []

        for child_control in child_info.controls:
            is_inherited = parent_name in child_control.from_type
            if is_inherited and child_control.name not in parent_control_names:
                obsolete_control_names.append(child_control.name)
        
        if not obsolete_control_names:
            reports.append({"rule": "P-01", "status": "Skipped", "details": "No inherited controls to comment out."})
            return source_code, reports

        lines = source_code.splitlines()
        lines_to_comment_indices = set() # 주석 처리할 라인의 인덱스를 저장

        # 3. Phase 1: 정의 블록 (type...end type, event...end event) 주석 처리
        for control_name in obsolete_control_names:
            # type...end type 블록 찾기
            control_block_start_pattern = re.compile(r"^type\s+" + re.escape(control_name) + r"\s+from\s+[\w`]+\s*(?:within\s+[\w`]+)?", re.IGNORECASE)
            control_block_end_pattern = re.compile(r"^end type", re.IGNORECASE)
            
            in_block = False
            for i, line in enumerate(lines):
                if control_block_start_pattern.search(line):
                    in_block = True
                    lines_to_comment_indices.add(i)
                elif in_block:
                    lines_to_comment_indices.add(i)
                    if control_block_end_pattern.search(line):
                        in_block = False
            
            # event...end event 블록 찾기
            event_block_start_pattern = re.compile(r"^event\s+" + re.escape(control_name) + r"(?:`[\w`]+)?::[\w`]+;", re.IGNORECASE)
            event_block_end_pattern = re.compile(r"^end event", re.IGNORECASE)

            in_block = False
            for i, line in enumerate(lines):
                if event_block_start_pattern.search(line):
                    in_block = True
                    lines_to_comment_indices.add(i)
                elif in_block:
                    lines_to_comment_indices.add(i)
                    if event_block_end_pattern.search(line):
                        in_block = False
        
        # 4. Phase 2: 개별 참조 라인 주석 처리 (아직 주석 처리되지 않은 라인 중)
        obsolete_refs_pattern = re.compile(r"\b(" + "|".join(re.escape(name) for name in obsolete_control_names) + r")\b", re.IGNORECASE)

        for i, line in enumerate(lines):
            if i not in lines_to_comment_indices: # 이미 블록으로 주석 처리될 라인이 아니면서
                if not line.strip().startswith('//') and obsolete_refs_pattern.search(line): # 주석이 아니고 오래된 컨트롤 참조가 있다면
                    lines_to_comment_indices.add(i)
        
        # 5. 최종적으로 주석 처리 적용
        modified_lines = []
        commented_line_found = False
        for i, line in enumerate(lines):
            if i in lines_to_comment_indices:
                modified_lines.append(f"//& {line}")
                commented_line_found = True
            else:
                modified_lines.append(line)

        # 6. PBMigrator 헤더 주석 추가
        if commented_line_found:
            current_date = datetime.now().strftime("%Y-%m-%d")
            header_comment = f"//& PBMigrator에 의해 주석 처리된 더 이상 사용되지 않는 컨트롤 및 이벤트 ({current_date})."
            
            try:
                forward_index = next(i for i, line in enumerate(modified_lines) if line.strip().lower() == "forward")
                modified_lines.insert(forward_index + 1, header_comment)
            except StopIteration:
                insert_pos = 2 if len(modified_lines) > 2 else len(modified_lines)
                modified_lines.insert(insert_pos, header_comment)

        details = f"Commented out all references to obsolete controls: {', '.join(obsolete_control_names)}"
        reports.append({"rule": "P-01", "status": "Success", "details": details})

        return '\n'.join(modified_lines), reports
