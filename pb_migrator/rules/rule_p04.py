"""
P-04 (최종): dw_cond를 dw_input으로 대체하는 규칙

목적:
PowerBuilder 10.5 버전에서 새로 추가된 dw_input 데이터윈도우가 기존 dw_cond의 역할을 대체함에 따라,
dw_cond 관련 코드를 제거하고 dw_input으로 안전하게 전환하여 프로그램 오류를 방지합니다.

전제 조건:
- 소스 코드 내에 'dw_input'이라는 문자열이 존재하지 않을 경우에만 실행됩니다.

작동 방식:
1. Forward 선언 삭제: `forward ... end forward` 블록 내의 `type dw_cond ... end type`을 삭제합니다.
2. 컨트롤 재정의: 메인 `type dw_cond ... end type` 블록의 첫 번째 라인만 `type dw_input from w_inherite`dw_input within [윈도우ID]`로 대체합니다.
3. 변수 선언 삭제: `global type ... end type` 블록 내의 `dw_cond dw_cond` 라인을 삭제합니다.
4. Create 이벤트 수정: `on create` 이벤트 내의 `dw_cond` 생성 및 `Control` 배열 할당 라인을 삭제합니다.
5. Control 배열 재채번: `on create` 이벤트 내의 `Control` 배열 인덱스를 1부터 순차적으로 다시 정렬합니다.
6. Destroy 이벤트 수정: `on destroy` 이벤트 내의 `destroy(this.dw_cond)` 라인을 삭제합니다.
7. 일괄 변경: 위 모든 작업 후, 코드에 남아있는 모든 `dw_cond` 문자열을 `dw_input`으로 일괄 변경합니다.
"""
import re

class P04Rule:
    def apply(self, source_code: str, logger=None) -> tuple:
        if logger is None:
            logger = print

        # 전제 조건: dw_input이 이미 존재하는지 확인
        if 'dw_input' in source_code:
            report = {"rule": "P-04", "status": "Skipped", "details": "Source code already contains 'dw_input'."}
            logger("INFO: P-04 - Skipped: Source code already contains 'dw_input'.")
            return source_code, [report]

        # dw_cond가 존재하는지 확인
        if 'dw_cond' not in source_code:
            report = {"rule": "P-04", "status": "Skipped", "details": "No 'dw_cond' found in the source code."}
            return source_code, [report]

        modified_code = source_code
        changes_made = []

        # 1. Forward 선언 삭제
        # forward 블록 전체를 찾고, 그 안에서 dw_cond type 정의를 제거
        forward_block_pattern = re.compile(r"(forward\s*.*?end forward)", re.DOTALL | re.IGNORECASE)
        
        def remove_dw_cond_from_forward(match):
            forward_block_content = match.group(1)
            # dw_cond type 정의 라인만 제거
            new_forward_block_content = re.sub(
                r"^\s*type\s+dw_cond\s+from\s+[\w_`]+\s+within\s+[\w_`]+\s*end type\s*$", 
                "", 
                forward_block_content, 
                flags=re.MULTILINE | re.IGNORECASE
            )
            return new_forward_block_content

        modified_code, count = forward_block_pattern.subn(remove_dw_cond_from_forward, modified_code)
        if count > 0:
            changes_made.append("Removed 'dw_cond' from forward block.")

        # 2. 컨트롤 재정의 (메인 type dw_cond 블록의 첫 라인만 대체)
        # 'type dw_cond from ... within [윈도우ID]' 패턴을 찾아 첫 라인만 교체
        control_redef_pattern = re.compile(
            r"^(type\s+dw_cond\s+from\s+[\w_`]+\s+within\s+([\w_`]+))", 
            re.MULTILINE | re.IGNORECASE
        )
        match = control_redef_pattern.search(modified_code)
        if match:
            window_id = match.group(2) # 윈도우 ID 추출
            replacement_line = f"type dw_input from w_inherite`dw_input within {window_id}"
            modified_code = control_redef_pattern.sub(replacement_line, modified_code, count=1)
            changes_made.append(f"Redefined 'dw_cond' as 'dw_input' (first line: {replacement_line}).")

        # 3. 변수 선언 삭제 (global type 블록 내)
        # global type 블록 전체를 찾고, 그 안에서 dw_cond 변수 선언 제거
        global_type_block_pattern = re.compile(r"(global\s+type\s+[\w_`]+\s+from\s+[\w_`]+\s*.*?end\s+type)", re.DOTALL | re.IGNORECASE)

        def remove_dw_cond_var_decl(match):
            global_block_content = match.group(1)
            new_global_block_content = re.sub(
                r"^\s*dw_cond\s+dw_cond\s*$", 
                "", 
                global_block_content, 
                flags=re.MULTILINE | re.IGNORECASE
            )
            return new_global_block_content
        
        modified_code, count = global_type_block_pattern.subn(remove_dw_cond_var_decl, modified_code)
        if count > 0:
            changes_made.append("Removed 'dw_cond' variable declaration from global type block.")

        # 4, 5, 6. create/destroy 이벤트 수정 및 재채번
        # create 이벤트 블록 처리
        create_block_pattern = re.compile(r"(on\s+[\w_`]+\.create\s*.*?end\s+on)", re.DOTALL | re.IGNORECASE)
        
        def process_create_block(match):
            create_block_content = match.group(1)
            lines = create_block_content.splitlines()
            new_lines = []
            control_array_lines = []
            
            # dw_cond 관련 라인 제거 및 Control 배열 라인 분리
            for line in lines:
                if re.search(r"this\.dw_cond\s*=\s*create\s+dw_cond", line, re.IGNORECASE):
                    changes_made.append("Removed 'this.dw_cond=create dw_cond' from create event.")
                    continue
                if re.search(r"this\.Control\[iCurrent\s*\+\s*\d+\]\s*=\s*this\.dw_cond", line, re.IGNORECASE):
                    changes_made.append("Removed 'this.Control[iCurrent+X]=this.dw_cond' from create event.")
                    continue
                if re.search(r"this\.Control\[iCurrent\s*\+\s*\d+\]\s*=", line, re.IGNORECASE):
                    control_array_lines.append(line)
                else:
                    new_lines.append(line)
            
            # Control 배열 재채번
            renumbered_control_array_lines = []
            if control_array_lines:
                for i, line in enumerate(control_array_lines):
                    # iCurrent+X 부분만 재채번
                    renumbered_line = re.sub(r"(this\.Control\[iCurrent\s*\+\s*)(\d+)(\]\s*=)", rf"\g<1>{i+1}\g<3>", line, flags=re.IGNORECASE)
                    renumbered_control_array_lines.append(renumbered_line)
                changes_made.append("Renumbered 'this.Control' array in create event.")
            
            # 재구성
            final_create_lines = []
            for line in new_lines:
                final_create_lines.append(line)
                if "iCurrent=UpperBound(this.Control)" in line: # UpperBound 라인 다음에 Control 배열 추가
                    final_create_lines.extend(renumbered_control_array_lines)
                    renumbered_control_array_lines = [] # 이미 추가했으므로 비움
            
            # 만약 UpperBound 라인이 없어서 Control 배열이 추가되지 않았다면, 마지막에 추가
            if renumbered_control_array_lines:
                final_create_lines.extend(renumbered_control_array_lines)

            return "\n".join(final_create_lines)

        modified_code, count = create_block_pattern.subn(process_create_block, modified_code)
        
        # destroy 이벤트 블록 처리
        destroy_block_pattern = re.compile(r"(on\s+[\w_`]+\.destroy\s*.*?end\s+on)", re.DOTALL | re.IGNORECASE)

        def process_destroy_block(match):
            destroy_block_content = match.group(1)
            new_destroy_block_content = re.sub(
                r"^\s*destroy\s*\(\s*this\.dw_cond\s*\)\s*$", 
                "", 
                destroy_block_content, 
                flags=re.MULTILINE | re.IGNORECASE
            )
            if destroy_block_content != new_destroy_block_content:
                changes_made.append("Removed 'destroy(this.dw_cond)' from destroy event.")
            return new_destroy_block_content
        
        modified_code, count = destroy_block_pattern.subn(process_destroy_block, modified_code)

        # 7. 일괄 변경
        if changes_made:
            modified_code = modified_code.replace('dw_cond', 'dw_input')
            changes_made.append("Replaced all remaining 'dw_cond' with 'dw_input'.")
            logger("INFO: P-04 - Successfully applied.")
            final_report = {"rule": "P-04", "status": "Success", "details": " | ".join(changes_made)}
            return modified_code, [final_report]
        else:
            report = {"rule": "P-04", "status": "Skipped", "details": "No applicable 'dw_cond' patterns found."}
            return source_code, [report]
