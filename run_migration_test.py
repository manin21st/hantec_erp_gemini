import sys
import os

# Add the project root to the Python path
sys.path.append(os.path.abspath('.'))

from pb_migrator.rules.pa01_inheritance_override import apply_pa01_inheritance_override

# Define file paths
original_source_path = r"C:\erpman\hantec_erp_gemini\source\_sample\w_adt_00290.srw"
reference_folder_path = r"C:\erpman\hantec_erp_gemini\target\_reference"
output_file_path = r"C:\erpman\hantec_erp_gemini\target\w_adt_00290_migrated.srw"

# Read original source content
with open(original_source_path, 'r', encoding='utf-8') as f:
    original_source_content = f.read()

# Apply the migration rule
migrated_content = apply_pa01_inheritance_override(original_source_content, reference_folder_path)

# Write the migrated content to the output file
with open(output_file_path, 'w', encoding='utf-8') as f:
    f.write(migrated_content)

print(f"Migration complete. Output written to: {output_file_path}")
