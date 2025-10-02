import tkinter as tk
from gui import MainApplication

def main():
    """Main function to run the PBMigrator application."""
    root = tk.Tk()
    app = MainApplication(root)
    app.pack(side="top", fill="both", expand=True)
    root.mainloop()

if __name__ == "__main__":
    main()
