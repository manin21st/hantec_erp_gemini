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
            exe_dir = os.path.dirname(sys.executable)
            if os.path.isdir(os.path.join(exe_dir, 'source')):
                self.project_root = exe_dir
            elif os.path.isdir(os.path.join(exe_dir, '..', 'source')):
                self.project_root = os.path.abspath(os.path.join(exe_dir, '..'))
            else:
                self.project_root = exe_dir
        else:
            self.project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
        
        self.engine = MigrationEngine()
        self.last_reports = []

        self.create_menu()
        self.create_statusbar()
        self.create_widgets()
        
        self.setup_diff_highlighting()
        self.load_worklist()

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
        self.notebook = ttk.Notebook(self)
        self.notebook.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)
        self.notebook.bind("<<NotebookTabChanged>>", self.on_tab_changed)

        self.settings_tab = ttk.Frame(self.notebook)
        self.compare_tab = ttk.Frame(self.notebook)
        self.notebook.add(self.settings_tab, text='설정 및 실행')
        self.notebook.add(self.compare_tab, text='소스 비교')

        settings_main_pane = ttk.PanedWindow(self.settings_tab, orient=tk.HORIZONTAL)
        settings_main_pane.pack(fill=tk.BOTH, expand=True)

        file_list_frame = ttk.Labelframe(settings_main_pane, text="File List", width=350)
        settings_main_pane.add(file_list_frame, weight=1)
        self.file_listbox, _, _ = self.create_scrolled_listbox(file_list_frame)
        self.file_listbox.bind('<<ListboxSelect>>', self.on_file_select)

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
        self.original_text.delete('1.0', tk.END)
        self.migrated_text.delete('1.0', tk.END)
        self.original_text.insert('1.0', original_code)
        self.migrated_text.insert('1.0', migrated_code)

        original_lines = original_code.splitlines(True)
        migrated_lines = migrated_code.splitlines(True)

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
            return

        self.notebook.select(self.settings_tab)
        selected_path = self.file_listbox.get(selected_indices[0])
        self.status_var.set(f"Selected: {os.path.basename(selected_path)}")
        self.log(f"Selected file: {selected_path}")

        try:
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
            self.log(f"Error reading file with CP949 encoding: {e}")
            messagebox.showerror("Error", f"An error occurred while reading the file:\n{e}")

    def on_tab_changed(self, event):
        selected_tab_index = self.notebook.index(self.notebook.select())
        if selected_tab_index == 1: # '소스 비교' 탭
            self.preview_and_save_single_file()

    def preview_and_save_single_file(self):
        selected_indices = self.file_listbox.curselection()
        if not selected_indices:
            return

        source_path = self.file_listbox.get(selected_indices[0])
        source_code = self.original_text.get("1.0", tk.END)
        if not source_code.strip():
            self.log("No source code to preview.")
            return

        self.log(f"Processing and auto-saving: {os.path.basename(source_path)}")
        selected_rules = [rule_id for rule_id, var in self.rules_vars.items() if var.get()]
        self.log(f"Applying selected rules: {', '.join(selected_rules)}")

        transformed_code, reports = self.engine.apply_rules(source_code, selected_rules)
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
            with open(target_path, 'w', encoding='utf-16-le', newline='\r\n') as f:
                f.write(transformed_code)
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
        try:
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
                    self.log(f"\n--- Processing file: {source_path} ---")
                    with open(source_path, 'r', encoding='cp949', errors='ignore') as f:
                        source_code = f.read()

                    transformed_code, reports = self.engine.apply_rules(source_code, selected_rules)

                    self.log('--- Transformation Report ---')
                    for report in reports:
                        self.log(f"Rule: {report.get('rule', 'N/A')}, Status: {report.get('status', 'N/A')}, Details: {report.get('details', '')}")
                    self.log('--- End of Report ---')

                    relative_path = os.path.relpath(source_path, os.path.join(self.project_root, 'source'))
                    target_path = os.path.join(self.project_root, 'target', relative_path)
                    os.makedirs(os.path.dirname(target_path), exist_ok=True)

                    with open(target_path, 'w', encoding='utf-16-le', newline='\r\n') as f:
                        f.write(transformed_code)
                    
                    self.log(f"Successfully saved file to: {target_path}")
                    processed_count += 1

                except Exception as e:
                    error_msg = f"Error processing {filename}: {e}"
                    self.log(error_msg)
                    if not messagebox.askretrycancel("Batch Process Error", f"{error_msg}\n\nDo you want to continue with the next file?", parent=progress_window):
                        self.cancellation_requested = True

        finally:
            self.toggle_buttons_state(tk.NORMAL)
            progress_window.destroy()

            if self.cancellation_requested:
                messagebox.showinfo("Cancelled", f"Batch process was cancelled. {processed_count}/{total_files} files were processed.")
                self.log(f"Batch process cancelled. {processed_count} files processed.")
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