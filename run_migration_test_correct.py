# -*- coding: utf-8 -*-
import sys
import os

# Add the project root to the Python path
sys.path.append(os.path.abspath('.'))

from pb_migrator.engine import MigrationEngine
from pb_migrator.spec import parse_pb_source, PBWindowInfo

# Define file paths
original_source_path = r"C:\erpman\hantec_erp_gemini\source\mat_e020\w_mat_03540.srw"
reference_folder_path = r"C:\erpman\hantec_erp_gemini\target\_reference"
output_file_path = r"C:\erpman\hantec_erp_gemini\target\w_mat_03540_migrated.srw"

# Read original source content

try:

    with open(original_source_path, 'r', encoding='cp949', errors='ignore', newline='') as f:

        original_source_content = f.read()

    

    # Save original content to target for comparison

    original_output_file_path = os.path.join(os.path.dirname(output_file_path), os.path.basename(original_source_path).replace('.srw', '_original.srw'))

    with open(original_output_file_path, 'w', encoding='utf-8', newline='') as f:

        f.write(original_source_content)

    print(f"Original content saved to: {original_output_file_path}")



except Exception as e:

    print(f"Error reading or saving original source file: {e}")

    sys.exit(1)



# Instantiate the engine and apply rules

engine = MigrationEngine()

migrated_content, reports = engine.apply_rules(original_source_content, ["P-01"], reference_folder_path)



# Write the migrated content to the output file



try:



    with open(output_file_path, 'w', encoding='utf-16', newline='') as f:



        f.write(migrated_content)



except Exception as e:



    print(f"Error writing output file: {e}")



    sys.exit(1)

# Print reports
print("Migration Test Report:")
for report in reports:
    print(f"- Rule: {report.get('rule')}, Status: {report.get('status')}, Details: {report.get('details')}")

print(f"\nMigration complete. Output written to: {output_file_path}")
