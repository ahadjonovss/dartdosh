# DartDosh CLI – User Guide

`DartDosh` is a powerful CLI tool for simplifying Flutter builds with automatic version management, multi-language support, and smart output handling.

```bash
dartdosh build <target> --<environment> [extra flags]
```

**Examples:**

```bash
# Full environment flags
dartdosh build ipa --production --split
dartdosh build apk --development --other-flag
dartdosh build appbundle --staging

# Short flags (convenient!)
dartdosh build apk -p              # production
dartdosh build apk -prod           # production
dartdosh build apk -d              # development
dartdosh build apk -dev            # development
dartdosh build apk -s              # staging
```

---

## Requirements

* Dart SDK ≥ 3.0
* Flutter SDK installed
* Terminal (Mac/Linux/Windows)

---

## Installation

### Install from pub.dev

```bash
dart pub global activate dartdosh
```

### Add to PATH (if needed)

**Mac/Linux (`.zshrc` or `.bashrc`):**

```bash
export PATH="$PATH:$HOME/.pub-cache/bin"
source ~/.zshrc
```

**Windows PowerShell:**

```powershell
$env:PATH += ";$env:USERPROFILE\.pub-cache\bin"
```

---

## Configuration

The `build_config.json` file is automatically created with default settings when you first run DartDosh. You can also create it manually in your Flutter project root:

```json
{
  "language": "uz",
  "output_path": "~/Desktop/dartdosh-builds",
  "apk": {
    "production": "flutter build apk --release --flavor production",
    "staging": "flutter build apk --release --flavor staging",
    "development": "flutter build apk --debug --flavor development"
  },
  "ipa": {
    "production": "flutter build ipa --release --flavor production",
    "staging": "flutter build ipa --release --flavor staging"
  },
  "appbundle": {
    "production": "flutter build appbundle --release --flavor production",
    "staging": "flutter build appbundle --release --flavor staging",
    "development": "flutter build appbundle --debug --flavor development"
  }
}
```

**Config Parameters:**

* `language` (optional): Interface language for all log messages and progress indicators
  - **Supported languages**: `uz` (Uzbek), `en` (English), `ru` (Russian)
  - **Default**: `uz`
  - **Fallback**: If unsupported language is set, defaults to English with a warning
  - Examples:
    ```json
    "language": "en"  // English interface
    "language": "ru"  // Russian interface
    "language": "uz"  // Uzbek interface (default)
    ```

* `output_path` (optional): Path where built files will be copied after build
  - If not specified, files will only be renamed in the build directory
  - Can be absolute path (`/Users/you/releases`) or relative to project (`releases`)
  - Directory will be created automatically if it doesn't exist
  - Default: `~/Desktop/dartdosh-builds`

---

## Usage

```bash
dartdosh build <target> --<environment> [extra flags]
```

**Parameters:**

* `<target>`: Build target
  - `apk` - Android APK
  - `ipa` - iOS IPA
  - `appbundle` (or `aab`) - Android App Bundle

* `<environment>`: Build environment (multiple flag variants supported!)
  - **Production**: `--production`, `-p`, `-prod`
  - **Staging**: `--staging`, `-s`
  - **Development**: `--development`, `-d`, `-dev`

* `[extra flags]`: Additional Flutter build flags
  - `--split` - For APK builds, automatically adds `--split-per-abi`
  - `--obfuscate` - Obfuscate Dart code
  - `--dart-define=KEY=VALUE` - Define environment variables
  - Any other Flutter build flags

---

## Features

### 🌍 Multi-Language Support
DartDosh supports three languages for all interface messages and progress indicators:

* **Uzbek (uz)** - Default language with "Xo'jayiin" (Boss) addressing
* **English (en)** - Professional English interface with "Boss" addressing
* **Russian (ru)** - Russian interface with "Босс" (Boss) addressing

**Setting Language:**
```json
{
  "language": "en"  // Set in build_config.json
}
```

**Language Features:**
* All log messages translated
* Progress bar stages localized
* Build status messages in selected language
* Donation messages with cultural humor
* Automatic fallback to English for unsupported languages with warning

**Example Uzbek:**
```
📈 Yangi build number: 46 (oldingi: 45), Xo'jayiin!
[████████████████░░░░░░░░░░░░░░]  60% - [apk - production] - Bundle yaratilmoqda...
✅ apk build muvaffaqiyatli yakunlandi, Xo'jayiin!
```

**Example English:**
```
📈 New build number: 46 (previous: 45), Boss!
[████████████████░░░░░░░░░░░░░░]  60% - [apk - production] - Creating bundle...
✅ apk build completed successfully, Boss!
```

### 🤖 Auto Configuration
If `build_config.json` doesn't exist in your Flutter project, DartDosh will automatically create it with sensible defaults on first run.

### 🔢 Automatic Version Management

Before every build, DartDosh automatically:
1. Reads the current version from `pubspec.yaml`
2. Increments the build number by 1
3. Updates `pubspec.yaml` with the new build number

**Example:**
```yaml
# Before build
version: 1.2.3+45

# After build
version: 1.2.3+46
```

### 📦 Smart File Naming

Built files are automatically renamed using the format:
```
{environment}_{version}_{buildNumber}.{extension}
```

**Examples:**
* `production_1.2.3_46.apk`
* `staging_2.0.0_12.ipa`
* `development_1.5.0_78.aab`

For split APKs:
* `production_1.2.3_46_arm64-v8a.apk`
* `production_1.2.3_46_armeabi-v7a.apk`
* `production_1.2.3_46_x86_64.apk`

### 📁 Output Path Management

If `output_path` is specified in `build_config.json`:
* Built files are **copied** to the specified directory
* Original files remain in the build directory
* Directory structure is created automatically

Without `output_path`:
* Files are only **renamed** in the build directory

---

## Notes

### Environment Flags
* **Full flags**: `--production`, `--staging`, `--development`
* **Short flags**: `-p`, `-prod`, `-s`, `-d`, `-dev`
* All variants work identically

### Language Support
* **Supported**: `uz` (Uzbek), `en` (English), `ru` (Russian)
* **Default**: Uzbek (`uz`)
* **Unsupported language**: Automatically falls back to English with a warning:
  ```
  ⚠️  Warning: Language "fr" is not supported. Falling back to English.
     Supported languages: uz (Uzbek), en (English), ru (Russian)
  ```

### Build Behavior
* For APK builds, `--split` automatically adds `--split-per-abi`
* Any additional flags after the base command are appended automatically
* Build number is incremented **before** the build starts
* All messages are personalized ("Xo'jayiin" for Uzbek, "Boss" for English/Russian)
* Missing `build_config.json` is automatically created with default settings
* Progress bar shows real-time build stages in your selected language
