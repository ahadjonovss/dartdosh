# Configuration

← [Back to docs](../README.en.md)

---

DartDosh uses two config files inside `dartdosh_config/`:

| File | Purpose | Git |
|------|---------|-----|
| `build_config.json` | Build commands, upload targets | ✅ Tracked |
| `settings.json` | Personal settings, credentials | 🚫 Ignored |

Run `dartdosh init` to generate both files.

---

## build_config.json

Shared with your team. Everyone uses the same build commands.

```json
{
  "apk": {
    "production":  "flutter build apk --release --flavor production",
    "staging":     "flutter build apk --release --flavor staging",
    "development": "flutter build apk --debug --flavor development"
  },
  "ipa": {
    "production":  "flutter build ipa --release --flavor production",
    "staging":     "flutter build ipa --release --flavor staging",
    "development": "flutter build ipa --debug --flavor development"
  },
  "appbundle": {
    "production":  "flutter build appbundle --release --flavor production",
    "staging":     "flutter build appbundle --release --flavor staging",
    "development": "flutter build appbundle --debug --flavor development"
  },
  "firebase_distribution": {
    "production":  { "app_id": "1:xxx:android:prodabc", "tester_groups": "qa-team" },
    "staging":     { "app_id": "1:xxx:android:stagabc", "tester_groups": "qa-team" },
    "development": { "app_id": "1:xxx:android:devabc",  "tester_groups": "developers" }
  },
  "telegram": {
    "production":  { "chat_id": "-1001234567890" },
    "staging":     { "chat_id": "-1002222222222" },
    "development": { "chat_id": "" }
  }
}
```

---

## settings.json

Personal settings. Each developer has their own copy — never commit this file.

```json
{
  "language": "en",
  "project_name": "my_app",
  "auto_increment_build_number": false,
  "output_path": "~/Desktop/dartdosh-builds",
  "ipa_upload": {
    "enabled": false,
    "apple_id": "developer@example.com",
    "app_specific_password": "abcd-efgh-ijkl-mnop"
  },
  "firebase_distribution": {
    "production":  { "enabled": false },
    "staging":     { "enabled": true },
    "development": { "enabled": true }
  },
  "telegram": {
    "enabled": false
  }
}
```

---

## Settings reference

| Key | Default | Description |
|-----|---------|-------------|
| `language` | `uz` | UI language — `uz`, `en`, `ru`, `tr` |
| `project_name` | from pubspec | Used for organizing output files |
| `auto_increment_build_number` | `false` | Auto-increment build number before each build |
| `output_path` | `~/Desktop/dartdosh-builds` | Where to save built files |
| `ipa_upload.enabled` | `false` | Auto upload IPA to App Store Connect |
| `firebase_distribution.<env>.enabled` | `false` | Auto upload APK to Firebase per environment |
| `telegram.enabled` | `false` | Auto upload APK to Telegram channel |

---

## Auto-repair

If your config is missing fields (e.g. after a dartdosh update), run:

```bash
dartdosh init
```

It detects missing keys and adds them with default values — without touching existing config.
