# Getting Started

← [Back to docs](../README.en.md)

---

## Requirements

- Dart SDK ≥ 3.0
- Flutter SDK installed
- Terminal (Mac / Linux / Windows)

---

## Install

```bash
dart pub global activate dartdosh
```

### Add to PATH (if needed)

**Mac / Linux** — add to `~/.zshrc` or `~/.bashrc`:
```bash
export PATH="$PATH:$HOME/.pub-cache/bin"
source ~/.zshrc
```

**Windows PowerShell:**
```powershell
$env:PATH += ";$env:USERPROFILE\.pub-cache\bin"
```

---

## Initialize in your project

Run this once inside your Flutter project:

```bash
dartdosh init
```

This creates a `dartdosh_config/` folder with two files:

```
dartdosh_config/
├── build_config.json   ← team-shared (Git tracked)
└── settings.json       ← personal (Git ignored)
```

Review the generated files and adjust to your project before running builds.

> Already have a config? `dartdosh init` only adds missing fields — it never overwrites existing values.

---

## First build

```bash
dartdosh build apk -p   # Android APK (production)
dartdosh build ipa -s   # iOS IPA (staging)
dartdosh build aab -d   # Android App Bundle (development)
```

That's it — DartDosh handles version management, file naming, and uploads automatically.

---

**Next:** [Configure build commands and settings →](02-configuration.md)
