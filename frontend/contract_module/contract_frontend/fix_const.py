import os
import re

files_to_fix = [
    r"d:\programming\projects\sasheco-v1\sasheco_dashboard_web\lib\features\engineering\presentation\screens\engineering_dashboard_screen.dart",
    r"d:\programming\projects\sasheco-v1\sasheco_dashboard_web\lib\features\finance\presentation\screens\financial_dashboard_screen.dart",
    r"d:\programming\projects\sasheco-v1\sasheco_dashboard_web\lib\features\site\presentation\screens\site_dashboard_screen.dart",
]

for file_path in files_to_fix:
    if not os.path.exists(file_path):
        continue
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # remove `const Text(AppLocalizations` -> `Text(AppLocalizations`
    new_content = content.replace("const Text(AppLocalizations", "Text(AppLocalizations")

    # remove `const [` -> `[` if it's before DataColumn
    # We can just replace `columns: const [` -> `columns: [`
    new_content = new_content.replace("columns: const [", "columns: [")

    if new_content != content:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Fixed {file_path}")
