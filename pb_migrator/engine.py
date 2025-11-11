import os
import re
from datetime import datetime # Import datetime module
from .spec import parse_pb_source, PBWindowInfo

class MigrationEngine:
    """
    마이그레이션 규칙을 소스 코드에 적용하는 핵심 엔진 클래스 (절차적, 라인 기반).
    """
    def apply_rules(self, source_code: str, selected_rules: list, reference_folder: str) -> tuple:
        """
        선택된 마이그레이션 규칙들을 소스 코드에 적용합니다.
        """
        reports = []
        
        if "P-01" not in selected_rules:
            reports.append({"rule": "N/A", "status": "Skipped", "details": "P-01 rule not selected."})
            return source_code, reports

        try:
            # 1. 자식 윈도우 정보 파싱
            child_info = parse_pb_source(source_code)
            if not child_info.name: # 윈도우 이름이 없으면 파싱 실패 또는 상속 윈도우 아님
                reports.append({"rule": "P-01", "status": "Skipped", "details": "Not an inheritance window or parsing failed for child."})
                return source_code, reports

            # 2. 부모 윈도우 정보 파싱
            parent_source_path = os.path.join(reference_folder, f"{child_info.parent}.srw")
            
            # 인코딩: utf-16 먼저 시도, 실패 시 cp949 (PowerBuilder 파일 특성 고려)
            try:
                with open(parent_source_path, 'r', encoding='utf-16', errors='strict') as f:
                    parent_source_code = f.read()
            except (FileNotFoundError, UnicodeDecodeError):
                with open(parent_source_path, 'r', encoding='cp949', errors='ignore') as f:
                    parent_source_code = f.read()
            
            parent_info = parse_pb_source(parent_source_code)
            if not parent_info.name: # 부모 윈도우 이름이 없으면 파싱 실패
                reports.append({"rule": "P-01", "status": "Error", "details": f"Parent window parsing failed: {parent_source_path}"})
                return source_code, reports

        except FileNotFoundError:
            details = f"Parent window source file not found: {parent_source_path}"
            reports.append({"rule": "P-01", "status": "Error", "details": details})
            return source_code, reports
        except Exception as e:
            reports.append({"rule": "P-01", "status": "Error", "details": f"Parsing failed: {e}"})
            return source_code, reports

        # 3. P-01 규칙 적용: 부모에 없는 컨트롤 및 관련 이벤트 주석 처리
        parent_control_names = parent_info.control_names
        obsolete_control_names = []

        for control_name in child_info.control_names:
            if control_name not in parent_control_names:
                obsolete_control_names.append(control_name)
        
        if not obsolete_control_names:
            reports.append({"rule": "P-01", "status": "Skipped", "details": "No controls to comment out."})
            return source_code, reports

        # 소스 코드를 라인별로 분리 (CRLF 유지)
        child_lines = source_code.split('\r\n')
        
        # 주석 처리할 블록의 시작/끝 라인 인덱스 저장
        # (start_index, end_index, control_name)
        blocks_to_comment = [] 

        # 컨트롤 블록 찾기
        for control_name in obsolete_control_names:
            control_block_start_pattern = re.compile(r"^type\s+" + re.escape(control_name) + r"\s+from\s+[\w`]+", re.IGNORECASE)
            control_block_end_pattern = re.compile(r"^end type", re.IGNORECASE)
            
            start_index = -1
            for i, line in enumerate(child_lines):
                if control_block_start_pattern.search(line):
                    start_index = i
                elif start_index != -1 and control_block_end_pattern.search(line):
                    blocks_to_comment.append((start_index, i, control_name))
                    start_index = -1 # 다음 블록을 위해 초기화

        # 이벤트 블록 찾기
        for control_name in obsolete_control_names:
            event_block_start_pattern = re.compile(r"^event\s+" + re.escape(control_name) + r"(?:`[\w`]+)?::[\w`]+;", re.IGNORECASE)
            event_block_end_pattern = re.compile(r"^end event", re.IGNORECASE)

            start_index = -1
            for i, line in enumerate(child_lines):
                if event_block_start_pattern.search(line):
                    start_index = i
                elif start_index != -1 and event_block_end_pattern.search(line):
                    blocks_to_comment.append((start_index, i, control_name))
                    start_index = -1 # 다음 블록을 위해 초기화
        
        # 변수 선언 라인 찾기
        declaration_lines_to_comment = []
        for control_name in obsolete_control_names:
            # 1. 변수 선언 (e.g., rr_1 rr_1)
            declaration_pattern = re.compile(r"^\s*" + re.escape(control_name) + r"\s+" + re.escape(control_name) + r"\s*$", re.IGNORECASE)
            # 2. create 문 (e.g., this.rr_1=create rr_1)
            create_pattern = re.compile(r"^\s*this\." + re.escape(control_name) + r"\s*=\s*create\s+" + re.escape(control_name) + r"\s*$", re.IGNORECASE)
            # 3. destroy 문 (e.g., destroy(this.rr_1))
            destroy_pattern = re.compile(r"^\s*destroy\s*\(\s*this\." + re.escape(control_name) + r"\s*\)\s*$", re.IGNORECASE)
            # 4. Control 배열 할당 (e.g., this.Control[...]=this.rr_1)
            control_array_pattern = re.compile(r"^\s*this\.Control\[.+\]\s*=\s*this\." + re.escape(control_name) + r"\s*$", re.IGNORECASE)

            for i, line in enumerate(child_lines):
                if declaration_pattern.search(line) or \
                   create_pattern.search(line) or \
                   destroy_pattern.search(line) or \
                   control_array_pattern.search(line):
                    declaration_lines_to_comment.append(i)

        # 실제 주석 처리된 라인 생성
        modified_lines = []
        
        # 주석 처리할 모든 라인 인덱스를 집합으로 관리
        lines_to_comment_set = set(declaration_lines_to_comment)
        for block_start, block_end, _ in blocks_to_comment:
            for i in range(block_start, block_end + 1):
                lines_to_comment_set.add(i)

        # 기본 주석 처리 적용
        for i, line in enumerate(child_lines):
            if i in lines_to_comment_set:
                modified_lines.append(f"//& {line}")
            else:
                modified_lines.append(line)

        # 오래된 컨트롤이 있는 경우, 설명 주석 추가
        if obsolete_control_names:
            current_date = datetime.now().strftime("%Y-%m-%d")
            header_comment = f"//& PBMigrator에 의해 주석 처리된 더 이상 사용되지 않는 컨트롤 및 이벤트 ({current_date})."
            
            # 'forward' 라인 찾기
            forward_index = -1
            for i, line in enumerate(modified_lines):
                if line.strip().lower() == "forward":
                    forward_index = i
                    break
            
            if forward_index != -1:
                modified_lines.insert(forward_index + 1, header_comment)
            else: # 'forward'가 없으면 파일의 3번째 라인에 삽입 (폴백)
                if len(modified_lines) > 2:
                    modified_lines.insert(2, header_comment)
                else:
                    modified_lines.append(header_comment)

        details = f"Commented out obsolete controls, events, and all related references: {', '.join(obsolete_control_names)}"
        reports.append({"rule": "P-01", "status": "Success", "details": details})

        return '\r\n'.join(modified_lines), reports
