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

## Usage Examples

### Build Production APK
```bash
dartdosh build apk --production
```

Output:
```
🚀 Boshlash: Build apk (production mode), Xo'jayiin!
✅ Build number yangilandi: 45 → 46
🔧 apk build bosqichi: Flutter komandalar bajarilmoqda, Xo'jayiin...
🔄 Ishga tushirilmoqda: flutter build apk --release --flavor production, Xo'jayiin!
✅ apk build muvaffaqiyatli yakunlandi, Xo'jayiin!
📁 Output directory yaratildi: /path/to/releases
✅ Build saqlandi: /path/to/releases/production_1.2.3_46.apk
🏁 Build yakunlandi: apk (production), Xo'jayiin!
```

### Build Split APK
```bash
dartdosh build apk --production --split
```

This automatically converts `--split` to `--split-per-abi` and creates separate APKs for each architecture:
- `production_1.2.3_46_arm64-v8a.apk`
- `production_1.2.3_46_armeabi-v7a.apk`
- `production_1.2.3_46_x86_64.apk`

### Build iOS IPA
```bash
dartdosh build ipa --production
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

1. **Auto Version Increment**: Build number in `pubspec.yaml` is automatically incremented before each build
2. **Smart File Naming**: Output files are named as `{environment}_{version}_{buildNumber}.{ext}`
3. **Output Path Management**: Built files are copied to the specified `output_path`
4. **Auto Config Generation**: If `build_config.json` doesn't exist, it's created automatically
5. **Personalized Experience**: All messages include "Xo'jayiin" (Boss) for a friendly touch

## First Time Usage

If you run DartDosh without `build_config.json`, it will create one for you:

```bash
dartdosh build apk --production
```

Output:
```
🔍 build_config.json topilmadi...
📝 Default konfiguratsiya yaratilmoqda, Xo'jayiin!

✅ build_config.json muvaffaqiyatli yaratildi!
📁 Joylashuv: /path/to/project/build_config.json
ℹ️  Kerakli o'zgarishlarni build_config.json da amalga oshiring.
```

Then customize the generated `build_config.json` to match your project's flavor configuration.
