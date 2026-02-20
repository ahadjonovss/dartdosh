# Using --dart-define-from-file

← [Back to docs](../README.en.md)

---

DartDosh fully supports Flutter's `--dart-define-from-file` flag for loading environment-specific configuration from JSON files.

## Method 1 — Direct command line

Pass the flag when running the build:

```bash
dartdosh build apk -p --dart-define-from-file=config/prod.json
dartdosh build ipa -s --dart-define-from-file=config/staging.json

# Combine with other flags
dartdosh build apk -p --dart-define-from-file=config/prod.json --obfuscate
```

## Method 2 — Bake it into `build_config.json` (recommended for teams)

Add the flag directly to your build command so the team never has to remember file paths:

```json
{
  "apk": {
    "production": "flutter build apk --release --flavor production --dart-define-from-file=config/prod.json",
    "staging":    "flutter build apk --release --flavor staging --dart-define-from-file=config/staging.json"
  },
  "ipa": {
    "production": "flutter build ipa --release --flavor production --dart-define-from-file=config/prod.json",
    "staging":    "flutter build ipa --release --flavor staging --dart-define-from-file=config/staging.json"
  }
}
```

Then just run:

```bash
dartdosh build apk -p   # automatically uses config/prod.json
dartdosh build ipa -s   # automatically uses config/staging.json
```

---

## Example config file

`config/prod.json`:
```json
{
  "API_URL": "https://api.production.com",
  "API_KEY": "prod-key-12345",
  "ENABLE_ANALYTICS": "true"
}
```

Access in Flutter:
```dart
const apiUrl = String.fromEnvironment('API_URL');
```

---

## Why Method 2?

| | Method 1 | Method 2 |
|--|----------|----------|
| Remember file path each time | ✅ Yes | ❌ No |
| Works the same for whole team | ❌ No | ✅ Yes |
| Stored in Git | ❌ | ✅ (build_config.json) |
| One command for all envs | ❌ | ✅ |
