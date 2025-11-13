import os
import re
from collections import namedtuple
from datetime import datetime

# PBWindowInfo는 파싱된 윈도우의 핵심 정보를 담는 간단한 튜플입니다.
PBWindowInfo = namedtuple("PBWindowInfo", ["name", "parent", "control_names"])

def parse_pb_source(source_code: str) -> PBWindowInfo:
    """
    PowerBuilder 소스 코드를 파싱하여 윈도우 이름, 부모 이름, 컨트롤 이름 목록을 반환합니다.
    이 함수는 복잡한 객체 모델을 구축하는 대신 필요한 정보만 추출합니다.
    """
    window_name = ""
    parent_name = ""
    control_names = set()

    # 1. 윈도우 이름 및 부모 파악
    # 'global type WindowName from ParentName' 또는 'global type WindowName from window' 형태를 모두 처리
    global_type_match = re.search(r"global\s+type\s+([\w`]+)\s+from\s+([\w`]+)", source_code, re.IGNORECASE)
    if global_type_match:
        window_name = global_type_match.group(1).lower()
        parent_name = global_type_match.group(2) # 부모 이름은 소문자로 변환하지 않음

    # 2. 컨트롤 이름 추출
    # 'type ControlName from ...' 형태의 블록에서 컨트롤 이름 추출
    # 윈도우 자체의 type 블록은 제외
    control_pattern = re.compile(r"^type\s+([\w`]+)\s+from\s+[\w`]+", re.IGNORECASE | re.MULTILINE)
    for match in control_pattern.finditer(source_code):
        name = match.group(1).lower()
        if name != window_name: # 윈도우 자체의 type 블록이 아닌 경우에만 추가
            control_names.add(name)

    return PBWindowInfo(window_name, parent_name, control_names)

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

# Import the P01Rule from the new rules module
from .rules.rule_p01 import P01Rule

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

        # Dispatch rules based on selected_rules
        if "P-01" in selected_rules:
            logger(f"INFO: Applying P-01 rule...")
            p01_rule_instance = P01Rule()
            modified_source_code, p01_reports = p01_rule_instance.apply(modified_source_code, reference_folder, logger)
            reports.extend(p01_reports)
            logger(f"INFO: P-01 rule applied. Status: {p01_reports[-1]['status']}")
        
        # Add more rules here as needed (e.g., if "P-02" in selected_rules: ...)

        return modified_source_code, reports