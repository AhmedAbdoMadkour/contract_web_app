import 'dart:io';
import 'dart:convert';

void main() async {
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    print('lib directory not found.');
    return;
  }

  final pattern = RegExp('Text\\(\\s*[\'"]([^\'"]+)[\'"]');
  final strings = <String>{};
  
  // Collect strings
  await for (final entity in libDir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final content = await entity.readAsString();
      final matches = pattern.allMatches(content);
      for (final match in matches) {
        strings.add(match.group(1)!);
      }
    }
  }

  print('Found ${strings.length} unique strings.');
  final enArb = <String, String>{};
  final arArb = <String, String>{};

  String toCamelCase(String text) {
    text = text.replaceAll(RegExp(r'[^a-zA-Z0-9]'), ' ').trim();
    if (text.isEmpty) return 'emptyKey';
    final parts = text.split(RegExp(r'\s+'));
    String result = parts[0].toLowerCase();
    for (int i = 1; i < parts.length; i++) {
      if (parts[i].isEmpty) continue;
      result += parts[i].substring(0, 1).toUpperCase() + parts[i].substring(1).toLowerCase();
    }
    // ensure it starts with a letter
    if (!result.startsWith(RegExp(r'[a-zA-Z]'))) {
      result = 'key$result';
    }
    return result;
  }

  final keyMap = <String, String>{};
  for (final s in strings) {
    String key = toCamelCase(s);
    if (keyMap.containsValue(key)) {
      int i = 1;
      while (keyMap.containsValue('\$key\$i')) {
        i++;
      }
      key = '\$key\$i';
    }
    keyMap[s] = key;
    enArb[key] = s;
    arArb[key] = s; // We will leave AR translation as is, or we could add a placeholder
  }

  final l10nDir = Directory('lib/l10n');
  if (!l10nDir.existsSync()) {
    l10nDir.createSync(recursive: true);
  }

  await File('lib/l10n/app_en.arb').writeAsString(JsonEncoder.withIndent('  ').convert(enArb));
  await File('lib/l10n/app_ar.arb').writeAsString(JsonEncoder.withIndent('  ').convert(arArb));
  print('Wrote ARB files.');

  // Replace strings in files
  await for (final entity in libDir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      String content = await entity.readAsString();
      bool changed = false;
      
      content = content.replaceAllMapped(pattern, (match) {
        final originalString = match.group(1)!;
        final key = keyMap[originalString]!;
        changed = true;
        return "Text(AppLocalizations.of(context)!.\$key";
      });

      if (changed) {
        // Check if we need to add import
        if (!content.contains('flutter_gen/gen_l10n/app_localizations.dart')) {
          content = "import 'package:flutter_gen/gen_l10n/app_localizations.dart';\n" + content;
        }
        await entity.writeAsString(content);
        print('Updated \${entity.path}');
      }
    }
  }
}
