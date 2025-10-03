# -*- coding: utf-8 -*-
"""
리포트 생성 모듈

이 모듈은 파일 변환 작업의 결과를 요약하는 마크다운(Markdown) 형식의 리포트를 생성하는 기능을 제공합니다.
"""

import os
import datetime

def generate_report(source_path, target_path, reports):
    """
    단일 파일 마이그레이션 작업에 대한 마크다운 리포트를 생성합니다.

    생성된 리포트 파일은 target 파일과 동일한 경로의 하위 폴더인 'reports'에 저장됩니다.
    파일 이름은 `[원본파일이름]_[타임스탬프].md` 형식입니다.

    Args:
        source_path (str): 원본 파일의 전체 경로입니다.
        target_path (str): 저장된 대상 파일의 전체 경로입니다.
        reports (list): 엔진에서 반환된, 각 규칙의 실행 결과가 담긴 딕셔너리 리스트입니다.

    Returns:
        str: 성공 시 생성된 리포트 파일의 경로, 실패 시 오류 메시지를 반환합니다.
    """
    
    # 리포트가 저장될 디렉토리 경로를 설정합니다. (예: .../target/ac0001/reports)
    report_dir = os.path.join(os.path.dirname(target_path), "reports")
    # 디렉토리가 존재하지 않으면 생성합니다.
    if not os.path.exists(report_dir):
        os.makedirs(report_dir)
        
    # 파일 이름에 사용할 타임스탬프를 생성합니다. (예: 20231026_153000)
    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    report_filename = f"{os.path.basename(target_path)}_{timestamp}.md"
    report_filepath = os.path.join(report_dir, report_filename)

    # --- 리포트 내용 구성 --- #
    content = f"# Migration Report for {os.path.basename(target_path)}\n\n"
    content += f"- **Timestamp:** {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n"
    content += f"- **Source File:** `{source_path}`\n"
    content += f"- **Target File:** `{target_path}`\n\n"
    content += "## Applied Rules Summary\n\n"
    content += "| Rule ID | Status    | Details                               |\n"
    content += "|:--------|:----------|:--------------------------------------|\n"

    # 각 규칙의 실행 결과를 테이블 형식으로 추가합니다.
    for report in reports:
        # 파이프(|) 문자가 테이블 형식을 깨뜨리지 않도록 HTML 코드로 대체합니다.
        details = str(report.get('details', '')).replace("|", "&#124;")
        content += f"| {report.get('rule', 'N/A')} | {report.get('status', 'N/A')} | {details} |\n"

    try:
        # 완성된 내용을 UTF-8 인코딩으로 파일에 씁니다.
        with open(report_filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        return report_filepath
    except Exception as e:
        # 파일 쓰기 실패 시 오류를 반환합니다.
        return str(e)