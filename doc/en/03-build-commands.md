# Build Commands

← [Back to docs](../README.en.md)

---

## Syntax

```bash
dartdosh build <target> [environment] [extra flags]
```

---

## Targets

| Target | Output |
|--------|--------|
| `apk` | Android APK |
| `ipa` | iOS IPA |
| `appbundle` or `aab` | Android App Bundle |

---

## Environments

Environment flags are **optional**. When provided, DartDosh uses flavor-specific build commands from `build_config.json` and applies version management.

| Environment | Full flag | Short flags |
|-------------|-----------|-------------|
| Production | `--production` | `-p`, `-prod` |
| Staging | `--staging` | `-s` |
| Development | `--development` | `-d`, `-dev` |

> **No environment flag** = plain Flutter build. Runs the target's base Flutter command without version management or smart naming.

---

## Examples

```bash
# Flavor builds (with version management)
dartdosh build apk -p              # APK, production
dartdosh build apk -s              # APK, staging
dartdosh build apk -d              # APK, development
dartdosh build ipa -p              # IPA, production
dartdosh build aab -p              # App Bundle, production

# Split APKs (adds --split-per-abi automatically)
dartdosh build apk -p --split

# With extra Flutter flags
dartdosh build apk -p --obfuscate
dartdosh build ipa -p --dart-define=API_URL=https://api.example.com

# Plain Flutter build (no environment)
dartdosh build apk                 # flutter build apk
dartdosh build apk --release       # flutter build apk --release
```

---

## Extra flags

Any flag not recognized by DartDosh is passed directly to Flutter:

```bash
dartdosh build apk -p --obfuscate --split-debug-info=./debug
dartdosh build ipa -s --no-codesign
```

The `--split` shorthand is a DartDosh convenience flag that expands to `--split-per-abi`.

---

## How it works

When you run `dartdosh build apk -p`:

1. Reads `dartdosh_config/build_config.json` → `apk.production` command
2. (Optional) Increments build number in `pubspec.yaml`
3. Runs the Flutter build command
4. Renames the output file: `prod_1.2.3_46.apk`
5. Copies to `output_path`
6. Runs enabled uploads (Firebase / Telegram / App Store)
