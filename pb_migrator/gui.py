# -*- coding: utf-8 -*-
"""
PBMigrator GUI 모듈

이 모듈은 PBMigrator 애플리케이션의 사용자 인터페이스(UI)를 생성하고 관리합니다.
Tkinter를 사용하여 GUI를 구축하며, 다음과 같은 주요 기능을 포함합니다:
- 파일 목록 표시 및 선택
- 마이그레이션 규칙 선택
- 원본과 변환 후의 소스 코드 비교
- 단일 파일 및 일괄 파일 변환 실행
- 처리 과정 로깅
"""

import tkinter as tk
from tkinter import ttk, messagebox
import os
import re
import difflib
import sys
from .engine import MigrationEngine
from . import reporting

class MainApplication(tk.Frame):
    """
    메인 애플리케이션 클래스.

    PBMigrator의 모든 UI 컴포넌트를 초기화하고, 사용자 상호작용을 처리합니다.
    """
    def __init__(self, parent, *args, **kwargs):
        """
        MainApplication의 생성자입니다.

        - 기본 윈도우 설정 (제목, 크기 등)
        - 프로젝트 루트 경로 설정 (개발/배포 환경 모두 지원)
        - 마이그레이션 엔진 초기화
        - 메뉴, 상태바, 메인 위젯 생성 및 초기화
        """
        tk.Frame.__init__(self, parent, *args, **kwargs)
        self.parent = parent
        self.parent.title("PBMigrator v2.0")
        try:
            # 창을 최대화 상태로 시작합니다.
            self.parent.state('zoomed')
        except tk.TclError:
            # 'zoomed' 상태를 지원하지 않는 일부 환경(예: Linux)을 위한 대체 설정입니다.
            self.parent.geometry("1600x900")

        if getattr(sys, 'frozen', False):
            # --- Bundled Executable Path ---
            # The executable can be in the 'dist' folder or moved to the project root.
            # We need to find the 'source' directory relative to the executable.
            exe_dir = os.path.dirname(sys.executable)
            
            # 1. Check if 'source' directory exists alongside the executable.
            if os.path.isdir(os.path.join(exe_dir, 'source')):
                self.project_root = exe_dir
            # 2. If not, check if it exists one level up (for when the exe is in 'dist').
            elif os.path.isdir(os.path.join(exe_dir, '..', 'source')):
                self.project_root = os.path.abspath(os.path.join(exe_dir, '..'))
            else:
                # As a fallback, assume the project root is the executable's directory.
                # This might fail, but it's a sensible default.
                self.project_root = exe_dir
        else:
            # --- Development Environment Path ---
            # The script is in 'pb_migrator', so the project root is one level up.
            self.project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
        
        # worklist.md 파일의 경로를 설정합니다. (현재는 사용되지 않음)
        self.worklist_path = os.path.join(self.project_root, "worklist.md")

        # 마이그레이션 로직을 처리할 엔진 클래스를 인스턴스화합니다.
        self.engine = MigrationEngine()
        # 마지막 변환 리포트를 저장할 변수입니다.
        self.last_reports = []

        # --- UI 컴포넌트 생성 ---
        self.create_menu()          # 상단 메뉴 생성
        self.create_statusbar()     # 하단 상태바 생성
        self.create_widgets()       # 메인 위젯 (탭, 버튼 등) 생성
        
        self.setup_diff_highlighting() # 소스 비교 탭의 하이라이팅 색상 설정
        self.load_worklist()        # 'source' 폴더에서 파일 목록을 불러옵니다.

    def create_menu(self):
        """상단 메뉴 바를 생성합니다."""
        menubar = tk.Menu(self.parent)
        self.parent.config(menu=menubar)
        file_menu = tk.Menu(menubar, tearoff=0)
        file_menu.add_command(label="Reload File List", command=self.load_worklist)
        file_menu.add_separator()
        file_menu.add_command(label="Exit", command=self.parent.quit)
        menubar.add_cascade(label="File", menu=file_menu)

    def create_statusbar(self):
        """하단 상태바를 생성합니다."""
        self.status_var = tk.StringVar()
        self.status_var.set("Ready")
        statusbar = ttk.Label(self, textvariable=self.status_var, anchor=tk.W, relief=tk.SUNKEN)
        statusbar.pack(side=tk.BOTTOM, fill=tk.X)

    def create_widgets(self):
        """메인 UI 위젯들을 생성하고 배치합니다."""
        # 메인 탭 컨트롤을 생성합니다.
        self.notebook = ttk.Notebook(self)
        self.notebook.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)

        # '설정 및 실행' 탭과 '소스 비교' 탭을 생성하여 노트북에 추가합니다.
        self.settings_tab = ttk.Frame(self.notebook)
        self.compare_tab = ttk.Frame(self.notebook)
        self.notebook.add(self.settings_tab, text='설정 및 실행')
        self.notebook.add(self.compare_tab, text='소스 비교')

        # --- "설정 및 실행" 탭 구성 ---
        settings_main_pane = ttk.PanedWindow(self.settings_tab, orient=tk.HORIZONTAL)
        settings_main_pane.pack(fill=tk.BOTH, expand=True)

        # 파일 목록 (왼쪽)
        file_list_frame = ttk.Labelframe(settings_main_pane, text="File List", width=350)
        settings_main_pane.add(file_list_frame, weight=1)
        self.file_listbox, _, _ = self.create_scrolled_listbox(file_list_frame)
        self.file_listbox.bind('<<ListboxSelect>>', self.on_file_select)

        # 컨트롤 및 로그 (오른쪽)
        controls_log_pane = ttk.PanedWindow(settings_main_pane, orient=tk.VERTICAL)
        settings_main_pane.add(controls_log_pane, weight=3)

        control_frame = ttk.Labelframe(controls_log_pane, text="Controls")
        controls_log_pane.add(control_frame, weight=1)
        
        log_frame = ttk.Labelframe(controls_log_pane, text="Log")
        controls_log_pane.add(log_frame, weight=2)

        self.log_text, _, _ = self.create_scrolled_text(log_frame, wrap=tk.WORD)

        # --- 컨트롤 프레임 내부 구성 ---
        # 마이그레이션 규칙 체크박스
        rules_frame = ttk.Frame(control_frame)
        rules_frame.pack(side=tk.LEFT, fill=tk.Y, padx=10, pady=5, anchor='nw')
        
        self.rules_vars = {}
        rule_descriptions = {
            "P-01": "Encoding & Line Endings", "P-02": "Inherited Controls",
            "P-03": "User Event Prototypes", "P-04": "Standard Events",
            "P-05": "Remove Decorative Controls", "P-07": "UI/UX Modernization",
            "P-08": "Standard MDI Events"
        }
        rule_ids = sorted(rule_descriptions.keys())
        for rule_id in rule_ids:
            var = tk.BooleanVar(value=True)
            self.rules_vars[rule_id] = var
            chk_text = f"{rule_id}: {rule_descriptions.get(rule_id, '')}"
            chk = ttk.Checkbutton(rules_frame, text=chk_text, variable=var)
            chk.pack(anchor=tk.W)

        # 실행 버튼 (미리보기, 저장, 일괄처리)
        self.buttons_frame = ttk.Frame(control_frame)
        self.buttons_frame.pack(side=tk.RIGHT, fill=tk.Y, padx=10, pady=5, anchor='ne')
        preview_button = ttk.Button(self.buttons_frame, text="Preview Changes", command=self.preview_changes)
        preview_button.pack(fill=tk.X, pady=5, ipady=5)
        save_button = ttk.Button(self.buttons_frame, text="Save to Target", command=self.save_file)
        save_button.pack(fill=tk.X, pady=5, ipady=5)
        batch_button = ttk.Button(self.buttons_frame, text="Process Batch", command=self.process_batch)
        batch_button.pack(fill=tk.X, pady=5, ipady=5)

        # --- "소스 비교" 탭 구성 ---
        # 범례(Legend) 프레임
        legend_frame = ttk.Frame(self.compare_tab)
        legend_frame.pack(fill=tk.X, padx=10, pady=(5, 0))

        legend_title = ttk.Label(legend_frame, text="범례:")
        legend_title.pack(side=tk.LEFT, padx=(0, 5))

        legend_items = {
            "수정": "#ffffdd",
            "삭제 (Original)": "#ffdddd",
            "추가 (Migrated)": "#ddffdd"
        }

        for text, color in legend_items.items():
            label_frame = ttk.Frame(legend_frame)
            label_frame.pack(side=tk.LEFT, padx=5)
            color_swatch = tk.Label(label_frame, text="", background=color, width=2, relief="sunken", borderwidth=1)
            color_swatch.pack(side=tk.LEFT)
            text_label = ttk.Label(label_frame, text=text)
            text_label.pack(side=tk.LEFT, padx=(2, 0))

        # 원본/변환본 비교를 위한 PanedWindow
        diff_paned_window = ttk.PanedWindow(self.compare_tab, orient=tk.HORIZONTAL)
        diff_paned_window.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)

        original_frame = ttk.Labelframe(diff_paned_window, text="Original")
        diff_paned_window.add(original_frame, weight=1)
        self.original_text, v_scroll_orig, _ = self.create_scrolled_text(original_frame)
        
        migrated_frame = ttk.Labelframe(diff_paned_window, text="Migrated (Preview)")
        diff_paned_window.add(migrated_frame, weight=1)
        self.migrated_text, v_scroll_mig, _ = self.create_scrolled_text(migrated_frame)

        # 양쪽 텍스트 창의 스크롤을 동기화합니다.
        self.original_text.config(yscrollcommand=self.sync_scroll(v_scroll_orig, self.migrated_text))
        self.migrated_text.config(yscrollcommand=self.sync_scroll(v_scroll_mig, self.original_text))
        v_scroll_orig.config(command=self.sync_scroll_command(self.original_text, self.migrated_text))
        v_scroll_mig.config(command=self.sync_scroll_command(self.migrated_text, self.original_text))

    def create_scrolled_text(self, parent, wrap=tk.NONE):
        """스크롤바가 있는 텍스트 위젯을 생성하는 헬퍼 함수입니다."""
        text_frame = ttk.Frame(parent)
        text_frame.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)
        text_widget = tk.Text(text_frame, wrap=wrap, height=1, width=1)
        v_scroll = ttk.Scrollbar(text_frame, orient=tk.VERTICAL, command=text_widget.yview)
        h_scroll = ttk.Scrollbar(text_frame, orient=tk.HORIZONTAL, command=text_widget.xview)
        text_widget.configure(yscrollcommand=v_scroll.set, xscrollcommand=h_scroll.set)
        v_scroll.pack(side=tk.RIGHT, fill=tk.Y)
        h_scroll.pack(side=tk.BOTTOM, fill=tk.X)
        text_widget.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        return text_widget, v_scroll, h_scroll

    def create_scrolled_listbox(self, parent):
        """스크롤바가 있는 리스트박스 위젯을 생성하는 헬퍼 함수입니다."""
        list_frame = ttk.Frame(parent)
        list_frame.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)
        # `selectmode=tk.EXTENDED`로 다중 선택을 활성화합니다.
        listbox = tk.Listbox(list_frame, exportselection=False, selectmode=tk.EXTENDED)
        v_scroll = ttk.Scrollbar(list_frame, orient=tk.VERTICAL, command=listbox.yview)
        h_scroll = ttk.Scrollbar(list_frame, orient=tk.HORIZONTAL, command=listbox.xview)
        listbox.configure(yscrollcommand=v_scroll.set, xscrollcommand=h_scroll.set)
        v_scroll.pack(side=tk.RIGHT, fill=tk.Y)
        h_scroll.pack(side=tk.BOTTOM, fill=tk.X)
        listbox.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        return listbox, v_scroll, h_scroll

    def sync_scroll(self, scrollbar, other_widget):
        """한쪽 텍스트 위젯의 스크롤을 다른 쪽 위젯에 동기화하는 클로저를 반환합니다."""
        def _sync(first, last):
            scrollbar.set(first, last)
            other_widget.yview_moveto(first)
        return _sync

    def sync_scroll_command(self, *widgets):
        """스크롤바 명령을 여러 위젯에 동시에 적용하는 클로저를 반환합니다."""
        def _sync(*args):
            for widget in widgets:
                widget.yview(*args)
        return _sync

    def setup_diff_highlighting(self):
        """소스 비교를 위한 텍스트 태그의 배경색을 설정합니다."""
        self.original_text.tag_configure("delete", background="#ffdddd")  # 삭제된 라인 (원본)
        self.migrated_text.tag_configure("insert", background="#ddffdd")  # 추가된 라인 (변환본)
        self.original_text.tag_configure("replace", background="#ffffdd") # 수정된 라인
        self.migrated_text.tag_configure("replace", background="#ffffdd") # 수정된 라인

    def highlight_diff(self, original_code, migrated_code):
        """두 코드의 차이점을 비교하고 하이라이트 태그를 적용합니다."""
        self.original_text.delete('1.0', tk.END)
        self.migrated_text.delete('1.0', tk.END)
        self.original_text.insert('1.0', original_code)
        self.migrated_text.insert('1.0', migrated_code)

        original_lines = original_code.splitlines(True)
        migrated_lines = migrated_code.splitlines(True)

        # difflib를 사용하여 라인별로 변경점을 찾습니다.
        d = difflib.SequenceMatcher(None, original_lines, migrated_lines)
        for tag, i1, i2, j1, j2 in d.get_opcodes():
            if tag == 'replace':
                self.original_text.tag_add("replace", f"{i1 + 1}.0", f"{i2}.0 + {len(original_lines[i2-1])} chars")
                self.migrated_text.tag_add("replace", f"{j1 + 1}.0", f"{j2}.0 + {len(migrated_lines[j2-1])} chars")
            elif tag == 'delete':
                self.original_text.tag_add("delete", f"{i1 + 1}.0", f"{i2}.0 + {len(original_lines[i2-1])} chars")
            elif tag == 'insert':
                self.migrated_text.tag_add("insert", f"{j1 + 1}.0", f"{j2}.0 + {len(migrated_lines[j2-1])} chars")

    def load_worklist(self):
        """'source' 디렉토리에서 .srw 파일 목록을 재귀적으로 불러와 리스트박스에 채웁니다."""
        source_dir = os.path.join(self.project_root, "source")
        self.log(f"Loading files from: {source_dir}")
        self.file_listbox.delete(0, tk.END)
        
        try:
            file_count = 0
            file_list = []
            for root, _, files in os.walk(source_dir):
                for file in files:
                    if file.endswith(".srw"):
                        file_list.append(os.path.join(root, file))
            
            # 일관된 순서를 위해 파일 목록을 정렬합니다.
            file_list.sort()

            for file_path in file_list:
                self.file_listbox.insert(tk.END, file_path)
                file_count += 1
            
            self.log(f"Successfully loaded {file_count} files.")
        except Exception as e:
            error_msg = f"An error occurred while loading files: {e}"
            self.log(error_msg)
            messagebox.showerror("Error", error_msg)

    def on_file_select(self, event):
        """파일 리스트에서 파일을 선택했을 때 호출되는 이벤트 핸들러입니다."""
        selected_indices = self.file_listbox.curselection()
        if not selected_indices:
            return

        # 다중 선택 시에는 첫 번째 선택 항목을 기준으로 미리보기를 표시합니다.
        self.notebook.select(self.settings_tab)
        selected_path = self.file_listbox.get(selected_indices[0])
        self.status_var.set(f"Selected: {os.path.basename(selected_path)}")
        self.log(f"Selected file: {selected_path}")

        try:
            # PowerBuilder 소스 파일은 주로 CP949 인코딩을 사용합니다.
            with open(selected_path, 'r', encoding='cp949') as f:
                file_content = f.read()
            
            self.original_text.delete('1.0', tk.END)
            self.original_text.insert('1.0', file_content)
            self.migrated_text.delete('1.0', tk.END)
            self.log("Successfully loaded and displayed original file content.")

        except FileNotFoundError:
            self.log(f"Error: Could not find file {selected_path}")
            messagebox.showerror("Error", f"Could not find the selected file:\n{selected_path}")
        except Exception as e:
            # CP949로 파일을 읽지 못할 경우를 대비한 예외 처리입니다.
            self.log(f"Error reading file with CP949 encoding: {e}")
            messagebox.showerror("Error", f"An error occurred while reading the file:\n{e}")

    def preview_changes(self):
        """'Preview Changes' 버튼 클릭 시 호출됩니다. 선택된 파일에 마이그레이션 규칙을 적용하고 결과를 '소스 비교' 탭에 표시합니다."""
        self.log("Preview Changes button clicked.")
        source_code = self.original_text.get("1.0", tk.END)
        if not source_code.strip():
            self.log("No source code to preview.")
            return

        selected_rules = [rule_id for rule_id, var in self.rules_vars.items() if var.get()]
        self.log(f"Applying selected rules: {', '.join(selected_rules)}")

        # 엔진을 통해 변환을 수행합니다.
        transformed_code, reports = self.engine.apply_rules(source_code, selected_rules)
        self.last_reports = reports

        # 변환 전후 코드를 비교하여 하이라이트 처리합니다.
        self.highlight_diff(source_code, transformed_code)
        # 자동으로 '소스 비교' 탭으로 전환합니다.
        self.notebook.select(self.compare_tab)

        self.log('--- Transformation Report ---')
        for report in reports:
            self.log(f"Rule: {report.get('rule', 'N/A')}, Status: {report.get('status', 'N/A')}, Details: {report.get('details', '')}")
        self.log('--- End of Report ---')

    def save_file(self):
        """'Save to Target' 버튼 클릭 시 호출됩니다. 현재 미리보기 중인 변환된 코드를 target 폴더에 저장합니다."""
        self.log("Save to Target button clicked.")
        selected_indices = self.file_listbox.curselection()
        if not selected_indices:
            messagebox.showerror("Error", "No file selected.")
            return

        source_path = self.file_listbox.get(selected_indices[0])
        migrated_code = self.migrated_text.get("1.0", tk.END).strip()

        if not migrated_code:
            messagebox.showerror("Error", "No migrated code to save. Please run 'Preview Changes' first.")
            return

        # 원본 파일의 상대 경로를 유지하여 target 폴더에 저장합니다.
        relative_path = os.path.relpath(source_path, os.path.join(self.project_root, 'source'))
        target_path = os.path.join(self.project_root, 'target', relative_path)
        
        os.makedirs(os.path.dirname(target_path), exist_ok=True)

        try:
            # P-01 규칙에 따라 UTF-16 LE 인코딩과 CRLF 줄바꿈으로 저장합니다.
            with open(target_path, 'w', encoding='utf-16-le', newline='\r\n') as f:
                f.write(migrated_code)
            self.log(f"Successfully saved file to: {target_path}")
            messagebox.showinfo("Success", f"File saved to:\n{target_path}")

            # 변환 리포트를 생성합니다.
            report_path = reporting.generate_report(source_path, target_path, self.last_reports)
            self.log(f"Generated report: {report_path}")

        except Exception as e:
            self.log(f"Error saving file: {e}")
            messagebox.showerror("Error", f"An error occurred while saving the file:\n{e}")

    def process_batch(self):
        """'Process Batch' 버튼 클릭 시 호출됩니다. 리스트에서 선택된 모든 파일에 대해 변환 및 저장 작업을 일괄 수행합니다."""
        selected_indices = self.file_listbox.curselection()
        if not selected_indices:
            messagebox.showerror("Error", "No files selected for batch processing.")
            return

        files_to_process = [self.file_listbox.get(i) for i in selected_indices]
        selected_rules = [rule_id for rule_id, var in self.rules_vars.items() if var.get()]
        
        self.log(f"Starting batch process for {len(files_to_process)} files.")
        self.log(f"Applying selected rules: {', '.join(selected_rules)}")

        # --- 진행률 표시 창 생성 ---
        progress_window = tk.Toplevel(self.parent)
        progress_window.title("Batch Processing")
        progress_window.geometry("450x150")
        progress_window.transient(self.parent) # 모달 창으로 만듭니다.
        progress_window.grab_set() 
        progress_window.protocol("WM_DELETE_WINDOW", lambda: None) # 창 닫기 버튼 비활성화

        self.cancellation_requested = False

        def on_cancel():
            if messagebox.askyesno("Confirm Cancel", "Are you sure you want to cancel the batch process?", parent=progress_window):
                self.cancellation_requested = True
                self.log("Cancellation requested by user.")

        progress_label = ttk.Label(progress_window, text="Initializing...", wraplength=430)
        progress_label.pack(pady=10, padx=10, anchor=tk.W)

        progress_var = tk.DoubleVar()
        progress_bar = ttk.Progressbar(progress_window, variable=progress_var, maximum=len(files_to_process))
        progress_bar.pack(fill=tk.X, padx=10, pady=5)
        
        percent_label = ttk.Label(progress_window, text="0%")
        percent_label.pack(pady=(0, 5))

        cancel_button = ttk.Button(progress_window, text="Cancel", command=on_cancel)
        cancel_button.pack(pady=10)

        self.toggle_buttons_state(tk.DISABLED) # 메인 창의 버튼 비활성화

        total_files = len(files_to_process)
        processed_count = 0
        try:
            for i, source_path in enumerate(files_to_process):
                if self.cancellation_requested:
                    break

                filename = os.path.basename(source_path)
                progress_label.config(text=f"Processing ({i+1}/{total_files}): {filename}")
                
                percentage = (i + 1) / total_files * 100
                percent_label.config(text=f"{percentage:.0f}%")

                progress_var.set(i + 1)
                progress_window.update() # UI 강제 업데이트

                try:
                    self.log(f"Processing file: {source_path}")
                    with open(source_path, 'r', encoding='cp949', errors='ignore') as f:
                        source_code = f.read()

                    transformed_code, reports = self.engine.apply_rules(source_code, selected_rules)

                    relative_path = os.path.relpath(source_path, os.path.join(self.project_root, 'source'))
                    target_path = os.path.join(self.project_root, 'target', relative_path)
                    os.makedirs(os.path.dirname(target_path), exist_ok=True)

                    with open(target_path, 'w', encoding='utf-16-le', newline='\r\n') as f:
                        f.write(transformed_code)
                    
                    self.log(f"Successfully saved file to: {target_path}")
                    
                    report_path = reporting.generate_report(source_path, target_path, reports)
                    self.log(f"Generated report: {report_path}")
                    processed_count += 1

                except Exception as e:
                    error_msg = f"Error processing {filename}: {e}"
                    self.log(error_msg)
                    if not messagebox.askretrycancel("Batch Process Error", f"{error_msg}\n\nDo you want to continue with the next file?", parent=progress_window):
                        self.cancellation_requested = True

        finally:
            # 일괄 처리가 끝나면 (성공, 실패, 취소 모두) 반드시 버튼을 다시 활성화합니다.
            self.toggle_buttons_state(tk.NORMAL)
            progress_window.destroy()

            if self.cancellation_requested:
                messagebox.showinfo("Cancelled", f"Batch process was cancelled. {processed_count}/{total_files} files were processed.")
                self.log(f"Batch process cancelled. {processed_count} files processed.")
            else:
                messagebox.showinfo("Success", f"Batch process completed. {processed_count}/{total_files} files successfully processed.")
                self.log(f"Batch process finished. {processed_count} files processed.")

    def toggle_buttons_state(self, state):
        """메인 창의 주요 버튼들(미리보기, 저장, 일괄처리)의 활성/비활성 상태를 변경합니다."""
        for child in self.buttons_frame.winfo_children():
            if isinstance(child, ttk.Button):
                child.config(state=state)

    def log(self, message):
        """로그 창에 메시지를 추가합니다."""
        self.log_text.insert(tk.END, message + "\n")
        self.log_text.see(tk.END) # 항상 마지막 로그가 보이도록 스크롤을 내립니다.

if __name__ == "__main__":
    """
    애플리케이션의 메인 진입점입니다.
    MainApplication을 실행하고 Tkinter의 메인 루프를 시작합니다.
    """
    root = tk.Tk()
    MainApplication(root).pack(side="top", fill="both", expand=True)
    root.mainloop()