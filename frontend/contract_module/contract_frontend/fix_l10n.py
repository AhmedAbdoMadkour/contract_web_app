import os
import re
import json

arb_path = r"d:\programming\projects\sasheco-v1\sasheco_dashboard_web\lib\l10n\app_en.arb"
with open(arb_path, 'r', encoding='utf-8') as f:
    arb_data = json.load(f)

# Map original strings to their keys
string_to_key = {}
for key, value in arb_data.items():
    if not key.startswith('@'):
        string_to_key[value] = key

files_to_fix = [
    r"d:\programming\projects\sasheco-v1\sasheco_dashboard_web\lib\features\engineering\presentation\screens\engineering_dashboard_screen.dart",
    r"d:\programming\projects\sasheco-v1\sasheco_dashboard_web\lib\features\finance\presentation\screens\financial_dashboard_screen.dart",
    r"d:\programming\projects\sasheco-v1\sasheco_dashboard_web\lib\features\site\presentation\screens\site_dashboard_screen.dart",
]

# We need to replace Text('string') with Text(AppLocalizations.of(context)?.key ?? 'string')
pattern = re.compile(r"Text\(\s*['\"]([^'\"]+)['\"]")

def replace_match(match):
    original = match.group(1)
    if original in string_to_key:
        key = string_to_key[original]
        return f"Text(AppLocalizations.of(context)?.{key} ?? '{original}'"
    return match.group(0)

for file_path in files_to_fix:
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        continue
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    new_content = pattern.sub(replace_match, content)

    if new_content != content:
        # add import if not there
        import_stmt = "import 'package:sasheco_dashboard_web/l10n/app_localizations.dart';"
        if import_stmt not in new_content:
            new_content = import_stmt + "\n" + new_content
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Updated {file_path}")
    else:
        print(f"No changes in {file_path}")
