import os
import re
from datetime import datetime
# parse_pb_source and PBWindowInfo will be moved to engine.py, so we import them from there.
# This import will be updated after engine.py is refactored.
from pb_migrator.engine import parse_pb_source, PBWindowInfo

class P01Rule:
    """
    P-01: 부모-자식 윈도우 동기화 규칙을 적용하는 클래스.
    """
    def apply(self, source_code: str, reference_folder: str, logger=None) -> tuple:
        if logger is None:
            logger = print

        reports = []

        try:
            # 1. 자식 윈도우 정보 파싱
            child_info = parse_pb_source(source_code)
            logger(f"DEBUG: P01 - Child Info: {child_info}")
            if not child_info.name:
                reports.append({"rule": "P-01", "status": "Skipped", "details": "Not an inheritance window or parsing failed for child."})
                return source_code, reports

            # 2. 부모 윈도우 정보 파싱
            parent_source_path = os.path.join(reference_folder, f"{child_info.parent}.srw")
            
            try:
                with open(parent_source_path, 'r', encoding='utf-16', errors='strict') as f:
                    parent_source_code = f.read()
            except (FileNotFoundError, UnicodeDecodeError):
                with open(parent_source_path, 'r', encoding='cp949', errors='ignore') as f:
                    parent_source_code = f.read()
            
            parent_info = parse_pb_source(parent_source_code)
            logger(f"DEBUG: P01 - Parent Info: {parent_info}")
            if not parent_info.name:
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
        
        logger(f"DEBUG: P01 - Obsolete Control Names: {obsolete_control_names}")
        if not obsolete_control_names:
            reports.append({"rule": "P-01", "status": "Skipped", "details": "No controls to comment out."})
            return source_code, reports

        child_lines = source_code.splitlines()
        
        blocks_to_comment = [] 

        for control_name in obsolete_control_names:
            control_block_start_pattern = re.compile(r"^type\s+" + re.escape(control_name) + r"\s+from\s+[\w`]+\s*(?:within\s+[\w`]+)?", re.IGNORECASE)
            control_block_end_pattern = re.compile(r"^end type", re.IGNORECASE)
            
            start_index = -1
            for i, line in enumerate(child_lines):
                if control_block_start_pattern.search(line):
                    start_index = i
                elif start_index != -1 and control_block_end_pattern.search(line):
                    blocks_to_comment.append((start_index, i, control_name))
                    start_index = -1

        for control_name in obsolete_control_names:
            event_block_start_pattern = re.compile(r"^event\s+" + re.escape(control_name) + r"(?:`[\w`]+)?::[\w`]+;", re.IGNORECASE)
            event_block_end_pattern = re.compile(r"^end event", re.IGNORECASE)

            start_index = -1
            for i, line in enumerate(child_lines):
                if event_block_start_pattern.search(line):
                    start_index = i
                elif start_index != -1 and event_block_end_pattern.search(line):
                    blocks_to_comment.append((start_index, i, control_name))
                    start_index = -1
        
        declaration_lines_to_comment = []
        for control_name in obsolete_control_names:
            declaration_pattern = re.compile(r"^\s*" + re.escape(control_name) + r"\s+" + re.escape(control_name) + r"\s*$", re.IGNORECASE)
            create_pattern = re.compile(r"^\s*this\." + re.escape(control_name) + r"\s*=\s*create\s+" + re.escape(control_name) + r"\s*$", re.IGNORECASE)
            destroy_pattern = re.compile(r"^\s*destroy\s*\(\s*this\." + re.escape(control_name) + r"\s*\)\s*$", re.IGNORECASE)
            control_array_pattern = re.compile(r"^\s*this\.Control\[.+\]\s*=\s*this\." + re.escape(control_name) + r"\s*$", re.IGNORECASE)

            for i, line in enumerate(child_lines):
                if declaration_pattern.search(line) or \
                   create_pattern.search(line) or \
                   destroy_pattern.search(line) or \
                   control_array_pattern.search(line):
                    declaration_lines_to_comment.append(i)

        modified_lines = []
        
        lines_to_comment_set = set(declaration_lines_to_comment)
        for block_start, block_end, _ in blocks_to_comment:
            for i in range(block_start, block_end + 1):
                lines_to_comment_set.add(i)
        logger(f"DEBUG: P01 - Lines to Comment Set: {sorted(list(lines_to_comment_set))}")

        for i, line in enumerate(child_lines):
            if i in lines_to_comment_set:
                modified_lines.append(f"//& {line}")
            else:
                modified_lines.append(line)

        if obsolete_control_names:
            current_date = datetime.now().strftime("%Y-%m-%d")
            header_comment = f"//& PBMigrator에 의해 주석 처리된 더 이상 사용되지 않는 컨트롤 및 이벤트 ({current_date})."
            
            forward_index = -1
            for i, line in enumerate(modified_lines):
                if line.strip().lower() == "forward":
                    forward_index = i
                    break
            
            if forward_index != -1:
                modified_lines.insert(forward_index + 1, header_comment)
            else:
                if len(modified_lines) > 2:
                    modified_lines.insert(2, header_comment)
                else:
                    modified_lines.append(header_comment)

        details = f"Commented out obsolete controls, events, and all related references: {', '.join(obsolete_control_names)}"
        reports.append({"rule": "P-01", "status": "Success", "details": details})

        return '\n'.join(modified_lines), reports
