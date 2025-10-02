import tkinter as tk
from tkinter import ttk, messagebox
import os
import re
import difflib
from engine import MigrationEngine
import reporting

class MainApplication(tk.Frame):
    def __init__(self, parent, *args, **kwargs):
        tk.Frame.__init__(self, parent, *args, **kwargs)
        self.parent = parent
        self.parent.title("PBMigrator v2.0")
        try:
            self.parent.state('zoomed')
        except tk.TclError:
            self.parent.geometry("1600x900")

        self.project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
        self.worklist_path = os.path.join(self.project_root, "worklist.md")

        self.engine = MigrationEngine()
        self.last_reports = []

        self.create_menu()
        self.create_statusbar() # Create and pack statusbar first
        self.create_widgets()   # Then create and pack the main content
        
        self.setup_diff_highlighting()
        self.load_worklist()

    def create_menu(self):
        menubar = tk.Menu(self.parent)
        self.parent.config(menu=menubar)
        file_menu = tk.Menu(menubar, tearoff=0)
        file_menu.add_command(label="Reload Worklist", command=self.load_worklist)
        file_menu.add_separator()
        file_menu.add_command(label="Exit", command=self.parent.quit)
        menubar.add_cascade(label="File", menu=file_menu)

    def create_statusbar(self):
        self.status_var = tk.StringVar()
        self.status_var.set("Ready")
        statusbar = ttk.Label(self, textvariable=self.status_var, anchor=tk.W, relief=tk.SUNKEN)
        statusbar.pack(side=tk.BOTTOM, fill=tk.X)

    def create_widgets(self):
        self.notebook = ttk.Notebook(self) # Reparented to self
        self.notebook.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)

        self.settings_tab = ttk.Frame(self.notebook)
        self.compare_tab = ttk.Frame(self.notebook)
        self.notebook.add(self.settings_tab, text='설정 및 실행')
        self.notebook.add(self.compare_tab, text='소스 비교')

        # --- "설정 및 실행" Tab ---
        settings_main_pane = ttk.PanedWindow(self.settings_tab, orient=tk.HORIZONTAL)
        settings_main_pane.pack(fill=tk.BOTH, expand=True)

        # File List (Left)
        file_list_frame = ttk.Labelframe(settings_main_pane, text="File List", width=350)
        settings_main_pane.add(file_list_frame, weight=1)
        self.file_listbox, _, _ = self.create_scrolled_listbox(file_list_frame)
        self.file_listbox.bind('<<ListboxSelect>>', self.on_file_select)

        # Controls and Log (Right)
        controls_log_pane = ttk.PanedWindow(settings_main_pane, orient=tk.VERTICAL)
        settings_main_pane.add(controls_log_pane, weight=3)

        control_frame = ttk.Labelframe(controls_log_pane, text="Controls")
        controls_log_pane.add(control_frame, weight=1)
        
        log_frame = ttk.Labelframe(controls_log_pane, text="Log")
        controls_log_pane.add(log_frame, weight=2)

        self.log_text, _, _ = self.create_scrolled_text(log_frame, wrap=tk.WORD)

        # --- Populate Controls Frame ---
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

        buttons_frame = ttk.Frame(control_frame)
        buttons_frame.pack(side=tk.RIGHT, fill=tk.Y, padx=10, pady=5, anchor='ne')
        preview_button = ttk.Button(buttons_frame, text="Preview Changes", command=self.preview_changes)
        preview_button.pack(fill=tk.X, pady=5, ipady=5)
        save_button = ttk.Button(buttons_frame, text="Save to Target", command=self.save_file)
        save_button.pack(fill=tk.X, pady=5, ipady=5)

        # --- "소스 비교" Tab ---
        diff_paned_window = ttk.PanedWindow(self.compare_tab, orient=tk.HORIZONTAL)
        diff_paned_window.pack(fill=tk.BOTH, expand=True)

        original_frame = ttk.Labelframe(diff_paned_window, text="Original")
        diff_paned_window.add(original_frame, weight=1)
        self.original_text, v_scroll_orig, _ = self.create_scrolled_text(original_frame)
        
        migrated_frame = ttk.Labelframe(diff_paned_window, text="Migrated (Preview)")
        diff_paned_window.add(migrated_frame, weight=1)
        self.migrated_text, v_scroll_mig, _ = self.create_scrolled_text(migrated_frame)

        # Synchronized Scrolling
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
        listbox = tk.Listbox(list_frame, exportselection=False)
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
        self.log(f"Loading worklist from: {self.worklist_path}")
        try:
            with open(self.worklist_path, 'r', encoding='utf-8') as f:
                content = f.readlines()
            
            self.file_listbox.delete(0, tk.END)
            path_regex = re.compile(r'-\s*\[\s*\]\s*(.*\.srw)')
            
            file_count = 0
            for line in content:
                match = path_regex.search(line)
                if match:
                    file_path = match.group(1).strip()
                    if not os.path.isabs(file_path):
                        file_path = os.path.join(self.project_root, file_path)
                    self.file_listbox.insert(tk.END, file_path)
                    file_count += 1
            self.log(f"Successfully loaded {file_count} files.")

        except FileNotFoundError:
            self.log(f"Error: worklist.md not found at {self.worklist_path}")
            messagebox.showerror("Error", f"worklist.md not found at the expected location:\n{self.worklist_path}")
        except Exception as e:
            self.log(f"An error occurred: {e}")
            messagebox.showerror("Error", f"An error occurred while loading the worklist:\n{e}")

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

    def preview_changes(self):
        self.log("Preview Changes button clicked.")
        source_code = self.original_text.get("1.0", tk.END)
        if not source_code.strip():
            self.log("No source code to preview.")
            return

        selected_rules = [rule_id for rule_id, var in self.rules_vars.items() if var.get()]
        self.log(f"Applying selected rules: {', '.join(selected_rules)}")

        transformed_code, reports = self.engine.apply_rules(source_code, selected_rules)
        self.last_reports = reports

        self.highlight_diff(source_code, transformed_code)
        self.notebook.select(self.compare_tab)

        self.log('--- Transformation Report ---')
        for report in reports:
            self.log(f"Rule: {report.get('rule', 'N/A')}, Status: {report.get('status', 'N/A')}, Details: {report.get('details', '')}")
        self.log('--- End of Report ---')

    def save_file(self):
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

        relative_path = os.path.relpath(source_path, os.path.join(self.project_root, 'source'))
        target_path = os.path.join(self.project_root, 'target', relative_path)
        
        os.makedirs(os.path.dirname(target_path), exist_ok=True)

        try:
            with open(target_path, 'w', encoding='utf-16-le', newline='\r\n') as f:
                f.write(migrated_code)
            self.log(f"Successfully saved file to: {target_path}")
            messagebox.showinfo("Success", f"File saved to:\n{target_path}")

            report_path = reporting.generate_report(source_path, target_path, self.last_reports)
            self.log(f"Generated report: {report_path}")

        except Exception as e:
            self.log(f"Error saving file: {e}")
            messagebox.showerror("Error", f"An error occurred while saving the file:\n{e}")

    def log(self, message):
        self.log_text.insert(tk.END, message + "\n")
        self.log_text.see(tk.END)

if __name__ == "__main__":
    root = tk.Tk()
    MainApplication(root).pack(side="top", fill="both", expand=True)
    root.mainloop()
