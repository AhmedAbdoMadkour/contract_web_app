$dir = "d:\programming\projects\sasheco-v1\sasheco_dashboard_web\lib\features"
$files = Get-ChildItem -Path $dir -Recurse -Include *.dart

$dict = @{}

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    
    # Also remove import 'package:sasheco_dashboard_web/l10n/app_localizations.dart';
    $content = $content -replace "import 'package:sasheco_dashboard_web/l10n/app_localizations.dart';", "import 'package:easy_localization/easy_localization.dart';"
    
    # Find all AppLocalizations.of(context)?.key ?? 'Fallback'
    $regex = "AppLocalizations\.of\(context\)\?\.(?<key>[a-zA-Z0-9_]+)\s*\?\?\s*'(?<fallback>[^']+)'"
    $matches = [regex]::Matches($content, $regex)
    
    foreach ($match in $matches) {
        $key = $match.Groups["key"].Value
        $fallback = $match.Groups["fallback"].Value
        $dict[$key] = $fallback
    }
    
    # Replace with 'key'.tr()
    $newContent = $content -replace "AppLocalizations\.of\(context\)\?\.[a-zA-Z0-9_]+\s*\?\?\s*'([^']+)'", "'`$1'.tr()"
    
    # The above regex replacement might not use the key, wait:
    # Actually, if we use the fallback as the text but with tr() it would be:
    # 'Fallback'.tr() -> and we just put "Fallback": "Fallback" in json.
    # But wait, it's better to use the key:
    # $newContent = [regex]::Replace($content, $regex, "'`${key}'.tr()")
    
    if ($content -ne $newContent) {
        # Set-Content $file.FullName $newContent
    }
}
