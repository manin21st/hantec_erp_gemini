# -*- coding: utf-8 -*-
"""
마이그레이션 엔진 모듈

이 모듈은 PBMigrator의 핵심 로직을 담당하는 `MigrationEngine` 클래스를 포함합니다.
엔진은 정의된 순서에 따라 개별 마이그레이션 규칙을 동적으로 불러와 소스 코드에 적용합니다.
"""

import importlib

class MigrationEngine:
    """
    마이그레이션 규칙을 소스 코드에 적용하는 핵심 엔진 클래스입니다.
    """
    def __init__(self):
        """
        MigrationEngine의 생성자입니다.

        - 규칙 적용 순서 정의: 규칙들은 상호 의존성을 가질 수 있으므로, 정의된 순서가 매우 중요합니다.
          (예: 장식용 컨트롤(P-05)을 삭제한 후, 새로운 UI 레이아웃(P-07)을 적용해야 함)
        - 규칙 ID와 실제 파이썬 모듈을 매핑합니다.
        """
        # 규칙 적용 순서입니다. 이 순서는 매우 중요합니다.
        # 예를 들어, 오래된 컨트롤을 삭제(P-05)한 후에 새로운 컨트롤의 크기를 조정(P-07)해야 합니다.
        self.rule_order = [
            "P-05", # 장식용 컨트롤 삭제
            "P-07", # 새로운 사각형(Rectangle)으로 UI 구조 재구성
            "P-02", # 상속받은 컨트롤 처리 (화면 밖으로 이동)
            "P-08", # 표준 MDI 이벤트 추가
            "P-03", # 이벤트 프로토타입 선언 추가
            "P-04", # resize/activate 등 표준 이벤트 스크립트 추가
            "P-01", # 인코딩 처리 (개념적으로, 파일 저장 시점에 적용됨)
            # P-06 (깨진 한글 수정)은 파일을 CP949로 읽는 과정에서 이미 처리되므로, 엔진 규칙에는 포함되지 않습니다.
        ]

        # 규칙 ID와 해당 규칙을 구현한 파이썬 모듈을 매핑하는 딕셔너리입니다.
        # 이를 통해 규칙을 동적으로 임포트하여 적용할 수 있습니다.
        self.rule_module_map = {
            "P-01": "pb_migrator.rules.p01_encoding",
            "P-02": "pb_migrator.rules.p02_inheritance",
            "P-03": "pb_migrator.rules.p03_events",
            "P-04": "pb_migrator.rules.p04_std_events",
            "P-05": "pb_migrator.rules.p05_controls",
            "P-07": "pb_migrator.rules.p07_gui_modernization",
            "P-08": "pb_migrator.rules.p08_mdi_events",
        }

    def apply_rules(self, code, selected_rules, **kwargs):
        """
        선택된 마이그레이션 규칙들을 미리 정의된 순서에 따라 소스 코드에 적용합니다.

        Args:
            code (str): 변환할 원본 소스 코드입니다.
            selected_rules (list): 적용할 규칙 ID의 리스트입니다. (예: ['P-01', 'P-02'])
            **kwargs: 각 규칙의 apply 함수에 전달될 추가적인 파라미터입니다.

        Returns:
            tuple: 변환된 소스 코드(str)와 실행 결과 리포트 리스트(list of dict)를 담은 튜플을 반환합니다.
        """
        reports = []
        transformed_code = code

        # 정의된 순서(self.rule_order)에 따라 규칙을 하나씩 적용합니다.
        for rule_id in self.rule_order:
            # 이 규칙이 사용자가 선택한 규칙 목록에 있는지 확인합니다.
            if rule_id in selected_rules:
                try:
                    # 규칙 ID에 해당하는 모듈 이름을 가져옵니다.
                    module_name = self.rule_module_map[rule_id]
                    # importlib를 사용하여 모듈을 동적으로 임포트합니다.
                    rule_module = importlib.import_module(module_name)
                    # 해당 모듈의 apply 함수를 호출하여 변환을 수행합니다.
                    transformed_code, report = rule_module.apply(transformed_code, **kwargs)
                    reports.append(report)
                except ImportError:
                    reports.append({"rule": rule_id, "status": "Error", "details": f"모듈을 임포트할 수 없습니다: {module_name}."})
                except Exception as e:
                    reports.append({"rule": rule_id, "status": "Error", "details": f"규칙 적용 중 오류 발생: {e}"})
        
        return transformed_code, reports