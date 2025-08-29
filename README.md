# DartDosh CLI – User Guide

`DartDosh` is a CLI tool for simplifying Flutter builds. Run commands directly:

```bash
dartdosh build <target> --<environment> [extra flags]
```

**Examples:**

```bash
dartdosh build ipa --production --split
dartdosh build apk --development --other-flag
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

## Usage

```bash
dartdosh build <target> --<environment> [extra flags]
```

* `<target>`: `ios`, `apk`, `appbundle`
* `<environment>`: `--production`, `--staging`, `--development`
* `[extra flags]`: e.g., `--split`, `--other-flag`

**Notes:**

* For APK builds, `--split` automatically adds `--split-per-abi`
* Any additional flags after the base command are appended automatically
