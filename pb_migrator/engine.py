import importlib

class MigrationEngine:
    def __init__(self):
        # The order is important. For example, remove old controls before resizing new ones.
        self.rule_order = [
            "P-05", # Remove decorative controls
            "P-07", # Restructure UI with new rectangles
            "P-02", # Handle inherited controls (move off-screen)
            "P-08", # Add standard MDI events
            "P-03", # Add event prototypes
            "P-04", # Add resize/activate events
            "P-01", # Handle encoding (conceptually, applied on save)
            # P-06 is handled by reading with cp949, so it's not an engine rule.
        ]

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
        Applies the selected migration rules to the source code in a predefined order.

        Args:
            code (str): The source code to transform.
            selected_rules (list): A list of rule IDs (e.g., ['P-01', 'P-02']) to apply.
            **kwargs: Additional parameters to pass to the rule functions.

        Returns:
            tuple: A tuple containing the transformed code (str) and a list of reports (dict).
        """
        reports = []
        transformed_code = code

        for rule_id in self.rule_order:
            if rule_id in selected_rules:
                try:
                    module_name = self.rule_module_map[rule_id]
                    rule_module = importlib.import_module(module_name)
                    transformed_code, report = rule_module.apply(transformed_code, **kwargs)
                    reports.append(report)
                except ImportError:
                    reports.append({"rule": rule_id, "status": "Error", "details": f"Could not import module {module_name}."})
                except Exception as e:
                    reports.append({"rule": rule_id, "status": "Error", "details": f"An error occurred: {e}"})
        
        return transformed_code, reports
