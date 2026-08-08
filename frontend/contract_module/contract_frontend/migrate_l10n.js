const fs = require('fs');
const path = require('path');

const featuresDir = path.join(__dirname, 'lib', 'features');
const enJsonPath = path.join(__dirname, 'assets', 'translations', 'en.json');
const arJsonPath = path.join(__dirname, 'assets', 'translations', 'ar.json');

let enJson = {};
let arJson = {};

try {
  enJson = JSON.parse(fs.readFileSync(enJsonPath, 'utf8'));
  arJson = JSON.parse(fs.readFileSync(arJsonPath, 'utf8'));
} catch(e) {}

function processDir(dir) {
  const files = fs.readdirSync(dir);
  for (const file of files) {
    const fullPath = path.join(dir, file);
    if (fs.statSync(fullPath).isDirectory()) {
      processDir(fullPath);
    } else if (fullPath.endsWith('.dart')) {
      let content = fs.readFileSync(fullPath, 'utf8');
      let originalContent = content;
      
      // Replace import
      content = content.replace(/import 'package:sasheco_dashboard_web\/l10n\/app_localizations\.dart';/g, "import 'package:easy_localization/easy_localization.dart';");
      
      // Regex for AppLocalizations.of(context)?.key ?? 'Fallback'
      // Or AppLocalizations.of(context)!.key
      const regex = /AppLocalizations\.of\(context\)\?\.([a-zA-Z0-9_]+)\s*\?\?\s*'([^']+)'/g;
      
      content = content.replace(regex, (match, key, fallback) => {
        enJson[key] = fallback;
        arJson[key] = fallback; // Default to English fallback, will need manual translation later if not already in ar.json
        return `'${key}'.tr()`;
      });
      
      if (content !== originalContent) {
        fs.writeFileSync(fullPath, content, 'utf8');
        console.log(`Updated ${fullPath}`);
      }
    }
  }
}

processDir(featuresDir);

fs.writeFileSync(enJsonPath, JSON.stringify(enJson, null, 2), 'utf8');
fs.writeFileSync(arJsonPath, JSON.stringify(arJson, null, 2), 'utf8');
console.log('Done!');
