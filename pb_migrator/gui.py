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
import time
from .engine import MigrationEngine

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
            self.parent.state('zoomed')
        except tk.TclError:
            self.parent.geometry("1600x900")

        if getattr(sys, 'frozen', False):
            # When running as a PyInstaller bundle, sys.executable is the path to the .exe.
            # The project root is one level up from the .exe's directory (e.g., 'dist').
            self.project_root = os.path.abspath(os.path.join(os.path.dirname(sys.executable), '..'))
        else:
            # When running as a script, this file is in pb_migrator/, so the root is one level up.
            self.project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
        
        self.engine = MigrationEngine()
        self.last_reports = []
        self.last_selected_path = None

        # Temporarily increase recursion limit for complex diffs
        sys.setrecursionlimit(2000) 

        self._create_menu()
        self.create_statusbar()
        self.create_widgets()
        self.setup_diff_highlighting()
        self.load_worklist()

    def _create_menu(self):
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
        self.notebook = ttk.Notebook(self)
        self.notebook.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)
        self.notebook.bind("<<NotebookTabChanged>>", self.on_tab_changed)

        self.settings_tab = ttk.Frame(self.notebook)
        self.compare_tab = ttk.Frame(self.notebook)
        self.notebook.add(self.settings_tab, text='설정 및 실행')
        self.notebook.add(self.compare_tab, text='소스 비교')

        settings_main_pane = ttk.PanedWindow(self.settings_tab, orient=tk.HORIZONTAL)
        settings_main_pane.pack(fill=tk.BOTH, expand=True)

        file_list_frame = ttk.Labelframe(settings_main_pane, text="File List", width=455)
        settings_main_pane.add(file_list_frame, weight=2)
        self.file_listbox, _, _ = self.create_scrolled_listbox(file_list_frame)
        self.file_listbox.bind('<<ListboxSelect>>', self.on_file_select)
        self.file_listbox.bind('<Button-1>', self._on_listbox_click)
        self.parent.bind('<Escape>', self._on_listbox_escape)
        self.file_listbox.bind('<Escape>', self._on_listbox_escape)

        controls_log_pane = ttk.PanedWindow(settings_main_pane, orient=tk.VERTICAL)
        settings_main_pane.add(controls_log_pane, weight=3)

        control_frame = ttk.Labelframe(controls_log_pane, text="Controls")
        controls_log_pane.add(control_frame, weight=1)
        
        log_frame = ttk.Labelframe(controls_log_pane, text="Log")
        controls_log_pane.add(log_frame, weight=2)

        self.log_text, _, _ = self.create_scrolled_text(log_frame, wrap=tk.WORD)

        rules_frame = ttk.Frame(control_frame)
        rules_frame.pack(side=tk.LEFT, fill=tk.Y, padx=10, pady=5, anchor='nw')
        
        self.rules_vars = {}
        rule_descriptions = {
            "P-01": "오래된 상속 컨트롤 정리 (Obsolete Inherited Control Cleanup)",
            "P-02": "이미지 버튼 이벤트 마이그레이션 (Image Button Event Migration)",
            "P-03": "오래된 이미지 버튼 참조 수정 (Obsolete Image Button Refinement)",
            "P-04": "dw_cond -> dw_input 대체 (Replace dw_cond with dw_input)"
        }
        rule_ids = sorted(rule_descriptions.keys())
        for rule_id in rule_ids:
            var = tk.BooleanVar(value=True)
            self.rules_vars[rule_id] = var
            chk_text = f"{rule_id}: {rule_descriptions.get(rule_id, '')}"
            chk = ttk.Checkbutton(rules_frame, text=chk_text, variable=var)
            chk.pack(anchor=tk.W)

        self.buttons_frame = ttk.Frame(control_frame)
        self.buttons_frame.pack(side=tk.RIGHT, fill=tk.Y, padx=10, pady=5, anchor='ne')
        transform_button = ttk.Button(self.buttons_frame, text="변환 실행", command=self.process_batch)
        transform_button.pack(fill=tk.X, pady=5, ipady=5)

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

        diff_paned_window = ttk.PanedWindow(self.compare_tab, orient=tk.HORIZONTAL)
        diff_paned_window.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)

        original_frame = ttk.Labelframe(diff_paned_window, text="Original")
        diff_paned_window.add(original_frame, weight=1)
        self.original_text, v_scroll_orig, _ = self.create_scrolled_text(original_frame)
        
        migrated_frame = ttk.Labelframe(diff_paned_window, text="Migrated (Preview)")
        diff_paned_window.add(migrated_frame, weight=1)
        self.migrated_text, v_scroll_mig, _ = self.create_scrolled_text(migrated_frame)

        self.original_text.config(yscrollcommand=self.sync_scroll(v_scroll_orig, self.migrated_text))
        self.migrated_text.config(yscrollcommand=self.sync_scroll(v_scroll_mig, self.original_text))
        v_scroll_orig.config(command=self.sync_scroll_command(self.original_text, self.migrated_text))
        v_scroll_mig.config(command=self.sync_scroll_command(self.migrated_text, self.original_text))

    def create_scrolled_text(self, parent, wrap=tk.NONE):
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
        list_frame = ttk.Frame(parent)
        list_frame.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)
        listbox = tk.Listbox(list_frame, exportselection=False, selectmode=tk.EXTENDED)
        v_scroll = ttk.Scrollbar(list_frame, orient=tk.VERTICAL, command=listbox.yview)
        h_scroll = ttk.Scrollbar(list_frame, orient=tk.HORIZONTAL, command=listbox.xview)
        listbox.configure(yscrollcommand=v_scroll.set, xscrollcommand=h_scroll.set)
        v_scroll.pack(side=tk.RIGHT, fill=tk.Y)
        h_scroll.pack(side=tk.BOTTOM, fill=tk.X)
        listbox.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        return listbox, v_scroll, h_scroll

    def sync_scroll(self, scrollbar, other_widget):
        def _sync(first, last):
            scrollbar.set(first, last)
            other_widget.yview_moveto(first)
        return _sync

    def sync_scroll_command(self, *widgets):
        def _sync(*args):
            for widget in widgets:
                widget.yview(*args)
        return _sync

    def setup_diff_highlighting(self):
        self.original_text.tag_configure("delete", background="#ffdddd")
        self.migrated_text.tag_configure("insert", background="#ddffdd")
        self.original_text.tag_configure("replace", background="#ffffdd")
        self.migrated_text.tag_configure("replace", background="#ffffdd")

    def highlight_diff(self, original_code, migrated_code):
        self.original_text.config(state=tk.NORMAL)
        self.migrated_text.config(state=tk.NORMAL)
        self.original_text.delete('1.0', tk.END)
        self.migrated_text.delete('1.0', tk.END)

        if not original_code and not migrated_code:
            self.original_text.config(state=tk.DISABLED)
            self.migrated_text.config(state=tk.DISABLED)
            return

        original_lines = original_code.splitlines(True)
        migrated_lines = migrated_code.splitlines(True)

        self._render_diff_lines(original_lines, migrated_lines)

        self.original_text.config(state=tk.DISABLED)
        self.migrated_text.config(state=tk.DISABLED)

    def _render_diff_lines(self, orig_lines_slice, mig_lines_slice):
        self.log(f"Entering _render_diff_lines. Orig slice length: {len(orig_lines_slice)}, Mig slice length: {len(mig_lines_slice)}")
        try:
            matcher = difflib.SequenceMatcher(None, orig_lines_slice, mig_lines_slice, autojunk=False)

            for opcode_idx, (tag, i1, i2, j1, j2) in enumerate(matcher.get_opcodes()):
                self.log(f"  Processing opcode {opcode_idx}: Tag={tag}, Orig lines [{i1}:{i2}], Mig lines [{j1}:{j2}]")
                if tag == 'equal':
                    for i in range(i1, i2):
                        self.original_text.insert(tk.END, orig_lines_slice[i])
                        self.migrated_text.insert(tk.END, mig_lines_slice[j1 + (i - i1)])
                
                elif tag == 'delete':
                    for i in range(i1, i2):
                        self.original_text.insert(tk.END, orig_lines_slice[i], "delete")
                        self.migrated_text.insert(tk.END, "\n")

                elif tag == 'insert':
                    for i in range(j1, j2):
                        self.original_text.insert(tk.END, "\n")
                        self.migrated_text.insert(tk.END, mig_lines_slice[i], "insert")
                
                elif tag == 'replace':
                    num_orig = i2 - i1
                    num_mig = j2 - j1

                    orig_block = "".join(orig_lines_slice[i1:i2])
                    mig_block = "".join(mig_lines_slice[j1:j2])
                    
                    s = difflib.SequenceMatcher(None, orig_block, mig_block, autojunk=False)
                    ratio = s.ratio()
                    
                    self.log(f"    Replace block similarity ratio: {ratio:.2f}")

                    if ratio < 0.4:
                        # Low similarity implies a delete and insert, not a modification.
                        # First, check if the migrated block is effectively empty.
                        is_mig_block_effectively_empty = not mig_block.strip()

                        if is_mig_block_effectively_empty:
                            # This is a semantic delete.
                            self.log("    Treating as semantic delete due to low similarity and empty migrated block.")
                            for i in range(i1, i2):
                                self.original_text.insert(tk.END, orig_lines_slice[i], "delete")
                                self.migrated_text.insert(tk.END, "\n")
                        else:
                            # This is a true delete and insert.
                            self.log("    Treating as delete and insert due to low similarity.")
                            for i in range(i1, i2):
                                self.original_text.insert(tk.END, orig_lines_slice[i], "delete")
                            for j in range(j1, j2):
                                self.migrated_text.insert(tk.END, mig_lines_slice[j], "insert")
                            
                            # Pad the shorter side to maintain alignment
                            if num_orig > num_mig:
                                for _ in range(num_orig - num_mig):
                                    self.migrated_text.insert(tk.END, "\n")
                            elif num_mig > num_orig:
                                for _ in range(num_mig - num_orig):
                                    self.original_text.insert(tk.END, "\n")
                    else:
                        # High similarity, treat as a standard 'replace' (yellow)
                        self.log(f"    Standard replace block. Orig lines: {num_orig}, Mig lines: {num_mig}")
                        max_lines = max(num_orig, num_mig)
                        for i in range(max_lines):
                            if i < num_orig:
                                self.original_text.insert(tk.END, orig_lines_slice[i1 + i], "replace")
                            else:
                                self.original_text.insert(tk.END, '\n')

                            if i < num_mig:
                                self.migrated_text.insert(tk.END, mig_lines_slice[j1 + i], "replace")
                            else:
                                self.migrated_text.insert(tk.END, '\n')
        except Exception as e:
            self.log(f"ERROR in _render_diff_lines: {e}")
            messagebox.showerror("Diff Rendering Error", f"An error occurred during diff rendering: {e}")
        finally:
            self.log(f"Exiting _render_diff_lines.")

    def load_worklist(self):
        """'source' 디렉토리에서 .srw 파일 목록을 재귀적으로 불러와 리스트박스에 채웁니다."""
        source_dir = os.path.join(self.project_root, "source")
        self.log(f"Loading files from: {source_dir}")
        self.file_listbox.delete(0, tk.END)
        
        try:
            file_count = 0
            file_list = []
            for root, dirs, files in os.walk(source_dir):
                # `_`로 시작하는 폴더는 탐색에서 제외합니다.
                dirs[:] = [d for d in dirs if not d.startswith('_')]
                for file in files:
                    if file.endswith(".srw"):
                        file_list.append(os.path.join(root, file))
            
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
        selected_indices = self.file_listbox.curselection()
        if not selected_indices:
            self._update_active_file_ui(None)
            return

        try:
            anchor_index = self.file_listbox.index(tk.ANCHOR)
            active_path = self.file_listbox.get(anchor_index)
            self._update_active_file_ui(active_path)
        except tk.TclError:
            # Fallback for selections without a clear anchor (e.g., programmatic)
            if selected_indices:
                active_path = self.file_listbox.get(selected_indices[0])
                self._update_active_file_ui(active_path)
            else:
                self._update_active_file_ui(None)

    def _on_listbox_click(self, event):
        # This method implements the safer click-toggle behavior.
        if not (event.state & 0x0001 or event.state & 0x0004): # No Shift or Ctrl
            clicked_index = self.file_listbox.nearest(event.y)
            if self.file_listbox.selection_includes(clicked_index):
                self.file_listbox.selection_clear(clicked_index)
            else:
                self.file_listbox.selection_set(clicked_index)
            
            # Directly update UI instead of generating an event
            active_path = self.file_listbox.get(clicked_index)
            self._update_active_file_ui(active_path)
            return "break" # Prevents the default binding from firing

    def _on_listbox_escape(self, event):
        # Clears the entire selection when the Escape key is pressed
        self.file_listbox.selection_clear(0, tk.END)
        self._update_active_file_ui(None)
        return "break" # Prevents any other bindings from firing

    def _update_active_file_ui(self, file_path):
        """Helper function to update all UI elements based on a new active file."""
        self.last_selected_path = file_path
        
        if file_path:
            self.log(f"Active file set to: {os.path.basename(self.last_selected_path)}")
            try:
                with open(self.last_selected_path, 'r', encoding='cp949', errors='ignore') as f:
                    file_content = f.read().replace('\r\n', '\n').replace('\r', '\n')
                self.original_text.delete('1.0', tk.END)
                self.original_text.insert('1.0', file_content)
                self.migrated_text.delete('1.0', tk.END)
            except Exception as e:
                self.log(f"Error reading file for preview: {e}")
                self.original_text.delete('1.0', tk.END)
                self.migrated_text.delete('1.0', tk.END)
        else:
            self.log("Selection cleared.")
            self.original_text.delete('1.0', tk.END)
            self.migrated_text.delete('1.0', tk.END)

    def on_tab_changed(self, event):
        selected_tab_index = self.notebook.index(self.notebook.select())
        if selected_tab_index == 1: # '소스 비교' 탭
            self.preview_and_save_single_file()

    def preview_and_save_single_file(self):
        if not self.last_selected_path:
            self.log("No active file selected for comparison.")
            # Clear comparison view if no file is active
            self.original_text.delete('1.0', tk.END)
            self.migrated_text.delete('1.0', tk.END)
            return

        source_path = self.last_selected_path
        self.log(f"Comparing active file: {os.path.basename(source_path)}")

        try:
            with open(source_path, 'r', encoding='cp949', errors='ignore') as f:
                source_code = f.read().replace('\r\n', '\n').replace('\r', '\n')
        except Exception as e:
            self.log(f"Error reading file for comparison: {e}")
            messagebox.showerror("Error", f"Could not read file: {source_path}\n{e}")
            return

        selected_rules = [rule_id for rule_id, var in self.rules_vars.items() if var.get()]
        self.log(f"Applying selected rules: {', '.join(selected_rules)}")

        reference_folder_path = os.path.join(self.project_root, 'target', '_reference')
        transformed_code, reports = self.engine.apply_rules(
            source_code, 
            selected_rules,
            reference_folder_path,
            logger=self.log
        )
        self.last_reports = reports

        self.highlight_diff(source_code, transformed_code)

        self.log('--- Transformation Report ---')
        for report in reports:
            self.log(f"Rule: {report.get('rule', 'N/A')}, Status: {report.get('status', 'N/A')}, Details: {report.get('details', '')}")
        self.log('--- End of Report ---')

        relative_path = os.path.relpath(source_path, os.path.join(self.project_root, 'source'))
        target_path = os.path.join(self.project_root, 'target', relative_path)
        os.makedirs(os.path.dirname(target_path), exist_ok=True)

        try:
            with open(target_path, 'w', encoding='utf-16', newline='') as f:
                f.write(transformed_code.replace('\n', '\r\n'))
            self.log(f"Successfully auto-saved file to: {target_path}")
            self.status_var.set(f"Saved: {os.path.basename(target_path)}")
        except Exception as e:
            self.log(f"Error auto-saving file: {e}")
            messagebox.showerror("Error", f"An error occurred while auto-saving the file:\n{e}")

    def process_batch(self):
        selected_indices = self.file_listbox.curselection()
        if not selected_indices:
            messagebox.showerror("Error", "No files selected for batch processing.")
            return

        files_to_process = [self.file_listbox.get(i) for i in selected_indices]
        selected_rules = [rule_id for rule_id, var in self.rules_vars.items() if var.get()]
        
        self.log(f"Starting batch process for {len(files_to_process)} files.")
        self.log(f"Applying selected rules: {', '.join(selected_rules)}")

        progress_window = tk.Toplevel(self.parent)
        progress_window.title("Batch Processing")
        progress_window.geometry("450x150")
        progress_window.transient(self.parent)
        progress_window.grab_set()
        progress_window.protocol("WM_DELETE_WINDOW", lambda: None)

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

        self.toggle_buttons_state(tk.DISABLED)

        total_files = len(files_to_process)
        processed_count = 0
        batch_logs = []
        temp_log_path = os.path.join(self.project_root, f"temp_batch_log_{time.strftime('%Y%m%d_%H%M%S')}.txt")

        try:
            with open(temp_log_path, 'w', encoding='utf-8') as temp_log_file:
                for i, source_path in enumerate(files_to_process):
                    if self.cancellation_requested:
                        break

                    filename = os.path.basename(source_path)
                    progress_label.config(text=f"Processing ({i+1}/{total_files}): {filename}")
                    percentage = (i + 1) / total_files * 100
                    percent_label.config(text=f"{percentage:.0f}%")
                    progress_var.set(i + 1)
                    progress_window.update()

                    try:
                        with open(source_path, 'r', encoding='cp949', errors='ignore', newline='') as f:
                            source_code = f.read()

                        reference_folder_path = os.path.join(self.project_root, 'target', '_reference')
                        transformed_code, reports = self.engine.apply_rules(
                            source_code, 
                            selected_rules,
                            reference_folder_path,
                            logger=self.log
                        )
                        
                        log_entry = [f"\n--- Transformation Report for {filename} ---"]
                        for report in reports:
                            log_entry.append(f"Rule: {report.get('rule', 'N/A')}, Status: {report.get('status', 'N/A')}, Details: {report.get('details', '')}")
                        log_entry.append('--- End of Report ---')

                        relative_path = os.path.relpath(source_path, os.path.join(self.project_root, 'source'))
                        target_path = os.path.join(self.project_root, 'target', relative_path)
                        os.makedirs(os.path.dirname(target_path), exist_ok=True)

                        with open(target_path, 'w', encoding='utf-16', newline='') as f:
                            f.write(transformed_code.replace('\n', '\r\n'))
                        
                        log_entry.append(f"Successfully saved file to: {target_path}")
                        temp_log_file.write("\n".join(log_entry) + "\n")
                        processed_count += 1

                    except Exception as e:
                        error_msg = f"Error processing {filename}: {e}"
                        self.log(error_msg)
                        temp_log_file.write(error_msg + "\n")
                        if not messagebox.askretrycancel("Batch Process Error", f"{error_msg}\n\nDo you want to continue with the next file?", parent=progress_window):
                            self.cancellation_requested = True

        finally:
            progress_window.destroy()
            self.toggle_buttons_state(tk.NORMAL)

            # --- 임시 로그 파일의 내용을 메인 로그 창으로 이동 ---
            if os.path.exists(temp_log_path):
                with open(temp_log_path, 'r', encoding='utf-8') as f:
                    final_log_content = f.read()
                self.log("\n--- Batch Process Summary ---")
                self.log(final_log_content)
                self.log("--- End of Batch Process Summary ---")
                if not self.cancellation_requested: # 성공적으로 끝나면 임시 파일 삭제
                    try:
                        os.remove(temp_log_path)
                    except OSError as e:
                        self.log(f"Could not remove temporary log file: {e}")

            # --- 전체 로그를 파일에 저장 ---
            logs_dir = os.path.join(self.project_root, "logs")
            os.makedirs(logs_dir, exist_ok=True)
            log_filename = f"PBMigrator_Batch_{time.strftime('%Y%m%d_%H%M%S')}.log"
            log_filepath = os.path.join(logs_dir, log_filename)
            
            try:
                with open(log_filepath, 'w', encoding='utf-8') as f:
                    f.write(self.log_text.get("1.0", tk.END))
                self.log(f"Batch process log saved to: {log_filepath}")
            except Exception as e:
                self.log(f"Error saving log file: {e}")
                messagebox.showerror("Log Save Error", f"Failed to save log file to {log_filepath}\n{e}")

            # --- 최종 상태 메시지 표시 ---
            if self.cancellation_requested:
                msg = f"Batch process was cancelled. {processed_count}/{total_files} files were processed."
                if os.path.exists(temp_log_path):
                     msg += f"\nTemporary log with details on failed files: {temp_log_path}"
                messagebox.showinfo("Cancelled", msg)
                self.log(msg)
            else:
                messagebox.showinfo("Success", f"Batch process completed. {processed_count}/{total_files} files successfully processed.")
                self.log(f"Batch process finished. {processed_count} files processed.")

    def toggle_buttons_state(self, state):
        for child in self.buttons_frame.winfo_children():
            if isinstance(child, ttk.Button):
                child.config(state=state)

    def log(self, message):
        self.log_text.insert(tk.END, message + "\n")
        self.log_text.see(tk.END)

if __name__ == "__main__":
    root = tk.Tk()
    MainApplication(root).pack(side="top", fill="both", expand=True)
    root.mainloop()