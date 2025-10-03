# -*- coding: utf-8 -*-
"""
PBMigrator 애플리케이션 메인 진입점

이 스크립트는 PBMigrator 애플리케이션을 시작하는 역할을 합니다.
"""

import sys
import os

# --- Python 경로 설정 ---
# 이 스크립트가 다른 경로에서 실행되더라도 (예: pyinstaller로 빌드된 .exe)
# pb_migrator.gui, pb_migrator.engine 등의 모듈을 정상적으로 찾을 수 있도록
# 프로젝트의 루트 디렉토리를 Python 경로에 추가합니다.
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
if project_root not in sys.path:
    sys.path.insert(0, project_root)

import tkinter as tk
from pb_migrator.gui import MainApplication

def main():
    """애플리케이션의 메인 함수입니다."""
    # Tkinter의 최상위 윈도우를 생성합니다.
    root = tk.Tk()
    # 메인 애플리케이션 클래스의 인스턴스를 생성합니다.
    app = MainApplication(root)
    # 애플리케이션을 윈도우에 채우고 크기 조절에 따라 확장되도록 설정합니다.
    app.pack(side="top", fill="both", expand=True)
    # Tkinter 이벤트 루프를 시작하여 GUI를 화면에 표시하고 사용자 입력을 대기합니다.
    root.mainloop()

# 이 스크립트가 직접 실행되었을 때만 main() 함수를 호출합니다.
# 다른 스크립트에서 이 파일을 모듈로 임포트할 경우에는 main()이 자동으로 실행되지 않습니다.
if __name__ == "__main__":
    main()