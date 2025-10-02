import tkinter as tk
from tkinter import ttk, messagebox
import os
import re

class MainApplication(tk.Frame):
    def __init__(self, parent, *args, **kwargs):
        tk.Frame.__init__(self, parent, *args, **kwargs)
        self.parent = parent
        self.parent.title("PBMigrator")
        self.parent.geometry("1400x900")
        
        self.project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
        self.worklist_path = os.path.join(self.project_root, "worklist.md")

        self.create_widgets()
        self.load_worklist()

    def create_widgets(self):
        main_paned_window = ttk.PanedWindow(self.parent, orient=tk.HORIZONTAL)
        main_paned_window.pack(fill=tk.BOTH, expand=True)

        # --- Left Panel ---
        left_frame = ttk.Labelframe(main_paned_window, text="File List", width=400)
        main_paned_window.add(left_frame, weight=1)

        self.file_listbox = tk.Listbox(left_frame)
        self.file_listbox.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)
        self.file_listbox.bind('<<ListboxSelect>>', self.on_file_select)

        load_button = ttk.Button(left_frame, text="Reload Worklist", command=self.load_worklist)
        load_button.pack(fill=tk.X, padx=5, pady=5)

        right_paned_window = ttk.PanedWindow(main_paned_window, orient=tk.VERTICAL)
        main_paned_window.add(right_paned_window, weight=4)

        # --- Center Panel ---
        diff_frame = ttk.Labelframe(right_paned_window, text="Diff View")
        right_paned_window.add(diff_frame, weight=3)

        diff_paned_window = ttk.PanedWindow(diff_frame, orient=tk.HORIZONTAL)
        diff_paned_window.pack(fill=tk.BOTH, expand=True)

        original_frame = ttk.Frame(diff_paned_window)
        diff_paned_window.add(original_frame, weight=1)
        ttk.Label(original_frame, text="Original").pack(anchor=tk.W, padx=5)
        self.original_text = tk.Text(original_frame, wrap=tk.NONE, height=1, width=1)
        self.original_text.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)

        migrated_frame = ttk.Frame(diff_paned_window)
        diff_paned_window.add(migrated_frame, weight=1)
        ttk.Label(migrated_frame, text="Migrated (Preview)").pack(anchor=tk.W, padx=5)
        self.migrated_text = tk.Text(migrated_frame, wrap=tk.NONE, height=1, width=1)
        self.migrated_text.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)

        # --- Right Panel ---
        control_log_frame = ttk.PanedWindow(right_paned_window, orient=tk.VERTICAL)
        right_paned_window.add(control_log_frame, weight=1)

        control_frame = ttk.Labelframe(control_log_frame, text="Controls")
        control_log_frame.add(control_frame, weight=1)

        rules_frame = ttk.Frame(control_frame)
        rules_frame.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=10, pady=5)
        
        self.rules_vars = {}
        # P-06 is now handled by correct encoding, so we only need P-01 to P-05
        for i in range(1, 6):
            rule_id = f"P-0{i}"
            var = tk.BooleanVar(value=True)
            self.rules_vars[rule_id] = var
            chk = ttk.Checkbutton(rules_frame, text=rule_id, variable=var)
            chk.pack(anchor=tk.W)

        buttons_frame = ttk.Frame(control_frame)
        buttons_frame.pack(side=tk.RIGHT, fill=tk.Y, padx=10, pady=5)

        preview_button = ttk.Button(buttons_frame, text="Preview Changes", command=self.preview_changes)
        preview_button.pack(fill=tk.X, pady=5, ipady=5)
        save_button = ttk.Button(buttons_frame, text="Save to Target", command=self.save_file)
        save_button.pack(fill=tk.X, pady=5, ipady=5)

        log_frame = ttk.Labelframe(control_log_frame, text="Log")
        control_log_frame.add(log_frame, weight=1)
        self.log_text = tk.Text(log_frame, height=5, wrap=tk.WORD)
        self.log_text.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)

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

        selected_path = self.file_listbox.get(selected_indices[0])
        self.log(f"Selected file: {selected_path}")

        try:
            # Read the file with CP949 encoding, which is the correct approach for legacy Korean PowerBuilder files.
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
        pass

    def save_file(self):
        self.log("Save to Target button clicked.")
        pass

    def log(self, message):
        self.log_text.insert(tk.END, message + "\n")
        self.log_text.see(tk.END)

if __name__ == "__main__":
    root = tk.Tk()
    MainApplication(root).pack(side="top", fill="both", expand=True)
    root.mainloop()