# DartDosh Example

This example demonstrates how to use DartDosh CLI tool in your Flutter project.

## Setup

1. Install DartDosh globally:
```bash
dart pub global activate dartdosh
```

2. Create a `build_config.json` in your Flutter project root (or let DartDosh create it automatically):
```json
{
  "language": "uz",
  "project_name": "my_app",
  "auto_increment_build_number": false,
  "output_path": "releases",
  "ipa_upload": {
    "enabled": false,
    "apple_id": "",
    "app_specific_password": ""
  },
  "apk": {
    "production": "flutter build apk --release --flavor production",
    "staging": "flutter build apk --release --flavor staging",
    "development": "flutter build apk --debug --flavor development"
  },
  "ipa": {
    "production": "flutter build ipa --release --flavor production",
    "staging": "flutter build ipa --release --flavor staging",
    "development": "flutter build ipa --debug --flavor development"
  },
  "appbundle": {
    "production": "flutter build appbundle --release --flavor production",
    "staging": "flutter build appbundle --release --flavor staging",
    "development": "flutter build appbundle --debug --flavor development"
  }
}
```

## Usage Examples

### Build Production APK
```bash
dartdosh build apk --production
```

Output:
```
🔧 apk build bosqichi: Flutter komandalar bajarilmoqda, Xo'jayiin...
🔄 Ishga tushirilmoqda: flutter build apk --release --flavor production, Xo'jayiin!
[████████████████████████████░░]  95% - [apk - production] - Tugallanmoqda...
✅ apk build muvaffaqiyatli yakunlandi, Xo'jayiin!
✅ Build saqlandi: /path/to/releases/my_app/prod_1.2.3_46.apk
```

### Build Split APK
```bash
dartdosh build apk --production --split
```

This automatically converts `--split` to `--split-per-abi` and creates separate APKs for each architecture:
- `prod_1.2.3_46_arm64-v8a.apk`
- `prod_1.2.3_46_armeabi-v7a.apk`
- `prod_1.2.3_46_x86_64.apk`

### Build iOS IPA
```bash
dartdosh build ipa --production
```

Output:
```
[████████████████████████████████] 100% - [ipa - production] - Ready!
✅ ipa build muvaffaqiyatli yakunlandi, Xo'jayiin!
✅ Build saqlandi: /path/to/releases/my_app/ipa/prod_1.2.3_46.ipa
```

### Build IPA with Auto-Upload to App Store Connect
```bash
# First, enable upload in build_config.json:
{
  "ipa_upload": {
    "enabled": true,
    "apple_id": "developer@example.com",
    "app_specific_password": "xxxx-xxxx-xxxx-xxxx"
  }
}

# Then build:
dartdosh build ipa --production
```

Output:
```
[████████████████████████████████] 100% - [ipa - production] - Ready!
✅ ipa build muvaffaqiyatli yakunlandi, Xo'jayiin!
✅ Build saqlandi: /path/to/releases/my_app/ipa/prod_1.2.3_46.ipa

📤 Uploading IPA to App Store Connect...
📊 Upload in progress...
✅ IPA successfully uploaded to App Store Connect, Xo'jayiin!
```

### Build App Bundle
```bash
dartdosh build appbundle --staging
```

### Add Extra Flags
```bash
dartdosh build apk --production --obfuscate --split-debug-info=/path/to/symbols
```

## Features Demonstrated

1. **Multi-Language Support**: Interface in Uzbek (uz), English (en), or Russian (ru)
2. **Multi-Project Support**: Each project gets its own subfolder in output directory
3. **Optional Auto Version Increment**: Enable with `"auto_increment_build_number": true` to auto-increment build numbers
4. **Smart File Naming**: Output files use short environment names: `prod_1.2.3_46.apk`, `stg_2.0.0_12.ipa`, `dev_1.5.0_78.aab`
5. **Output Path Management**: Built files organized by project and type in `output_path/project_name/{apk|ipa|aab}/`
6. **Auto Config Creation**: Config file is created automatically on first run
7. **Progress Bar**: Real-time build progress with localized stage messages
8. **Personalized Experience**: All messages include "Xo'jayiin" (Boss) for a friendly touch
9. **IPA Auto-Upload**: Automatically upload iOS builds to App Store Connect after successful build

## First Time Usage

If you run DartDosh without `build_config.json`, it will create one for you:

```bash
dartdosh build apk --production
```

Output:
```
⚠️ Build config topilmadi, default yaratilmoqda, Xo'jayiin!
✅ Build saqlandi: /path/to/project/build_config.json, Xo'jayiin!
📁 Output directory yaratildi: ~/Desktop/dartdosh-builds, Xo'jayiin!

📋 Xo'jayiin, build_config.json yaratib qo'ydim!
✅ Iltimos, tekshirib ko'ring va to'g'ri bo'lsa commandni qayta run qiling.
💼 Xizmatizga tayyorman, Xo'jayiin!
```

The config file will automatically open in your IDE. Customize it to match your project's flavor configuration, then run the command again.
