import os
import datetime

def generate_report(source_path, target_path, reports):
    """Generates a Markdown report for a single file migration."""
    
    report_dir = os.path.join(os.path.dirname(target_path), "reports")
    if not os.path.exists(report_dir):
        os.makedirs(report_dir)
        
    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    report_filename = f"{os.path.basename(target_path)}_{timestamp}.md"
    report_filepath = os.path.join(report_dir, report_filename)

    content = f"# Migration Report for {os.path.basename(target_path)}\n\n"
    content += f"- **Timestamp:** {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n"
    content += f"- **Source File:** `{source_path}`\n"
    content += f"- **Target File:** `{target_path}`\n\n"
    content += "## Applied Rules Summary\n\n"
    content += "| Rule ID | Status    | Details                               |"
    content += "|:--------|:----------|:--------------------------------------|"

    for report in reports:
        content += f"| {report.get('rule', 'N/A')} | {report.get('status', 'N/A')} | {report.get('details', '')} |\n"

    try:
        with open(report_filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        return report_filepath
    except Exception as e:
        return str(e)
