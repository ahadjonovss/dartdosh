# DartDosh CLI – User Guide

`DartDosh` is a CLI tool for simplifying Flutter builds with automatic version management and output handling. Run commands directly:

```bash
dartdosh build <target> --<environment> [extra flags]
```

**Examples:**

```bash
dartdosh build ipa --production --split
dartdosh build apk --development --other-flag
dartdosh build appbundle --staging
```

---

## Requirements

* Dart SDK ≥ 3.0
* Flutter SDK installed
* Terminal (Mac/Linux/Windows)

---

## Installation

### Clone and Activate

```bash
git clone https://github.com/username/dartdosh.git
cd dartdosh
dart pub global activate --source path .
```

### Add to PATH

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
  "output_path": "releases",
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
    "staging": "flutter build appbundle --release --flavor staging"
  }
}
```

**Config Parameters:**

* `output_path` (optional): Path where built files will be copied after build
  - If not specified, files will only be renamed in the build directory
  - Can be absolute path (`/Users/you/releases`) or relative to project (`releases`)
  - Directory will be created automatically if it doesn't exist

---

## Usage

```bash
dartdosh build <target> --<environment> [extra flags]
```

* `<target>`: `ipa`, `apk`, `appbundle`
* `<environment>`: `--production`, `--staging`, `--development`
* `[extra flags]`: e.g., `--split`, `--obfuscate`, etc.

---

## Features

### 🤖 Auto Configuration
If `build_config.json` doesn't exist in your Flutter project, DartDosh will automatically create it with sensible defaults. You'll be greeted with:
```
🔍 build_config.json topilmadi...
📝 Default konfiguratsiya yaratilmoqda, Xo'jayiin!

✅ build_config.json muvaffaqiyatli yaratildi!
```

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

* For APK builds, `--split` automatically adds `--split-per-abi`
* Any additional flags after the base command are appended automatically
* Build number is incremented **before** the build starts
* All messages are personalized with "Xo'jayiin" (Boss) for a friendly experience
* Missing `build_config.json` is automatically created with default Flutter build commands
