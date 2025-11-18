import os
import re
from collections import namedtuple
from datetime import datetime

# 파싱된 컨트롤의 상세 정보를 담는 튜플
ControlInfo = namedtuple("ControlInfo", ["name", "from_type"])
# 파싱된 윈도우의 핵심 정보를 담는 튜플
PBWindowInfo = namedtuple("PBWindowInfo", ["name", "parent", "controls"])

def parse_pb_source(source_code: str) -> PBWindowInfo:
    """
    PowerBuilder 소스 코드를 파싱하여 윈도우 이름, 부모 이름, 컨트롤 목록(이름, 기반타입 포함)을 반환합니다.
    """
    window_name = ""
    parent_name = ""
    controls = []

    # 1. 윈도우 이름 및 부모 파악
    # 'global type WindowName from ParentName' 또는 'global type WindowName from window' 형태를 모두 처리
    global_type_match = re.search(r"global\s+type\s+([\w`]+)\s+from\s+([\w`]+)", source_code, re.IGNORECASE)
    if global_type_match:
        window_name = global_type_match.group(1).lower()
        parent_name = global_type_match.group(2) # 부모 이름은 소문자로 변환하지 않음

    # 2. 컨트롤 정보(이름, 기반타입) 추출
    # 'type ControlName from FromType' 형태의 블록에서 이름과 기반타입 추출
    # 윈도우 자체의 type 블록은 제외
    control_pattern = re.compile(r"^type\s+([\w`]+)\s+from\s+([\w`]+)", re.IGNORECASE | re.MULTILINE)
    for match in control_pattern.finditer(source_code):
        name = match.group(1).lower()
        from_type = match.group(2).lower()
        if name != window_name: # 윈도우 자체의 type 블록이 아닌 경우에만 추가
            controls.append(ControlInfo(name, from_type))

    return PBWindowInfo(window_name, parent_name, controls)

def get_control_block_regex(control_name: str):
    """
    주어진 컨트롤 이름에 대한 'type ... end type' 블록을 찾는 정규식 패턴을 반환합니다.
    """
    escaped_control_name = re.escape(control_name)
    return re.compile(
        r"^(type\s+" + escaped_control_name + r"\s+from\s+[\w`]+\s*(?:within\s+[\w`]+)?.*?^end type)$",
        re.IGNORECASE | re.MULTILINE | re.DOTALL
    )

def get_event_block_regex(control_name: str):
    """
    주어진 컨트롤 이름에 대한 'event ControlName::EventName; ... end event' 블록을 찾는 정규식 패턴을 반환합니다.
    """
    escaped_control_name = re.escape(control_name)
    return re.compile(
        r"^(event\s+" + escaped_control_name + r"(?:`[\w`]+)?::[\w`]+;.*?^end event)$",
        re.IGNORECASE | re.MULTILINE | re.DOTALL
    )

# Import rules from the new rules module
from .rules.rule_p01 import P01Rule
from .rules.rule_p02 import P02Rule
from .rules.rule_p03 import P03Rule
from .rules.rule_p04 import P04Rule

class MigrationEngine:
    """
    마이그레이션 규칙을 소스 코드에 적용하는 핵심 엔진 클래스 (절차적, 라인 기반).
    """
    def apply_rules(self, source_code: str, selected_rules: list, reference_folder: str, logger=None) -> tuple:
        """
        선택된 마이그레이션 규칙들을 소스 코드에 적용합니다.
        """
        if logger is None:
            logger = print # Fallback to print if no logger is provided
        
        reports = []
        modified_source_code = source_code # Start with the original source code

        # P-04 (dw_cond -> dw_input 대체) -> P-02 (이벤트 마이그레이션) -> P-03 (오래된 이미지 버튼 참조 수정) -> P-01 (오래된 컨트롤 정의 제거) 순서로 적용
        # 이 순서는 각 규칙의 역할과 의존성을 고려하여 결정되었습니다.
        if "P-04" in selected_rules:
            logger(f"INFO: Applying P-04 rule...")
            p04_rule_instance = P04Rule()
            modified_source_code, p04_reports = p04_rule_instance.apply(modified_source_code, logger)
            reports.extend(p04_reports)
            if p04_reports and p04_reports[-1].get('status') != 'Skipped':
                 logger(f"INFO: P-04 rule applied. Status: {p04_reports[-1]['status']}")

        if "P-02" in selected_rules:
            logger(f"INFO: Applying P-02 rule...")
            p02_rule_instance = P02Rule()
            modified_source_code, p02_reports = p02_rule_instance.apply(modified_source_code, logger)
            reports.extend(p02_reports)
            if p02_reports and p02_reports[-1].get('status') != 'Skipped':
                 logger(f"INFO: P-02 rule applied. Status: {p02_reports[-1]['status']}")

        if "P-03" in selected_rules:
            logger(f"INFO: Applying P-03 rule...")
            p03_rule_instance = P03Rule()
            modified_source_code, p03_reports = p03_rule_instance.apply(modified_source_code, logger)
            reports.extend(p03_reports)
            if p03_reports and p03_reports[-1].get('status') != 'Skipped':
                logger(f"INFO: P-03 rule applied. Status: {p03_reports[-1]['status']}")

        if "P-01" in selected_rules:
            logger(f"INFO: Applying P-01 rule...")
            p01_rule_instance = P01Rule()
            modified_source_code, p01_reports = p01_rule_instance.apply(modified_source_code, reference_folder, logger)
            reports.extend(p01_reports)
            if p01_reports and p01_reports[-1].get('status') != 'Skipped':
                logger(f"INFO: P-01 rule applied. Status: {p01_reports[-1]['status']}")
        
        return modified_source_code, reports