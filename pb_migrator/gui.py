import tkinter as tk
from tkinter import ttk, filedialog, messagebox
import os

class MainApplication(tk.Frame):
    def __init__(self, parent, *args, **kwargs):
        tk.Frame.__init__(self, parent, *args, **kwargs)
        self.parent = parent
        self.parent.title("PBMigrator")
        self.parent.geometry("1400x900")

        self.create_widgets()

    def create_widgets(self):
        # --- Main Layout ---
        main_paned_window = ttk.PanedWindow(self.parent, orient=tk.HORIZONTAL)
        main_paned_window.pack(fill=tk.BOTH, expand=True)

        # --- Left Panel (File List) ---
        left_frame = ttk.Labelframe(main_paned_window, text="File List", width=400)
        main_paned_window.add(left_frame, weight=1)

        self.file_listbox = tk.Listbox(left_frame)
        self.file_listbox.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)

        load_button = ttk.Button(left_frame, text="Load Worklist", command=self.load_worklist)
        load_button.pack(fill=tk.X, padx=5, pady=5)

        # --- Center & Right Panel Container ---
        right_paned_window = ttk.PanedWindow(main_paned_window, orient=tk.VERTICAL)
        main_paned_window.add(right_paned_window, weight=4)

        # --- Center Panel (Diff View) ---
        diff_frame = ttk.Labelframe(right_paned_window, text="Diff View")
        right_paned_window.add(diff_frame, weight=3)

        diff_paned_window = ttk.PanedWindow(diff_frame, orient=tk.HORIZONTAL)
        diff_paned_window.pack(fill=tk.BOTH, expand=True)

        # Original Text
        original_frame = ttk.Frame(diff_paned_window)
        diff_paned_window.add(original_frame, weight=1)
        ttk.Label(original_frame, text="Original").pack(anchor=tk.W, padx=5)
        self.original_text = tk.Text(original_frame, wrap=tk.NONE, height=1, width=1)
        self.original_text.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)

        # Migrated Text
        migrated_frame = ttk.Frame(diff_paned_window)
        diff_paned_window.add(migrated_frame, weight=1)
        ttk.Label(migrated_frame, text="Migrated (Preview)").pack(anchor=tk.W, padx=5)
        self.migrated_text = tk.Text(migrated_frame, wrap=tk.NONE, height=1, width=1)
        self.migrated_text.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)

        # --- Right Panel (Controls & Log) ---
        control_log_frame = ttk.PanedWindow(right_paned_window, orient=tk.VERTICAL)
        right_paned_window.add(control_log_frame, weight=1)

        # Controls
        control_frame = ttk.Labelframe(control_log_frame, text="Controls")
        control_log_frame.add(control_frame, weight=1)

        rules_frame = ttk.Frame(control_frame)
        rules_frame.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=10, pady=5)
        
        self.rules_vars = {}
        for i in range(1, 7):
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

        # Log
        log_frame = ttk.Labelframe(control_log_frame, text="Log")
        control_log_frame.add(log_frame, weight=1)
        self.log_text = tk.Text(log_frame, height=5, wrap=tk.WORD)
        self.log_text.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)

    def load_worklist(self):
        # Placeholder
        self.log("Load Worklist button clicked.")
        pass

    def preview_changes(self):
        # Placeholder
        self.log("Preview Changes button clicked.")
        pass

    def save_file(self):
        # Placeholder
        self.log("Save to Target button clicked.")
        pass

    def log(self, message):
        self.log_text.insert(tk.END, message + "\n")
        self.log_text.see(tk.END)

if __name__ == "__main__":
    root = tk.Tk()
    MainApplication(root).pack(side="top", fill="both", expand=True)
    root.mainloop()