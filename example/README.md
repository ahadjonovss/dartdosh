# DartDosh Example

This example shows how to use DartDosh in your Flutter project.

## Setup

1. Install DartDosh:
```bash
dart pub global activate dartdosh
```

2. Initialize configuration:
```bash
cd your_flutter_project
dartdosh init
```

This creates `dartdosh_config/` folder with 2 files:
- `build_config.json` - Build commands (team shared)
- `settings.json` - Your personal settings (gitignored)

## Usage Examples

### Build Production APK
```bash
dartdosh build apk --production
# or short
dartdosh build apk -p
```

Output:
```
🔧 apk build step: Running Flutter commands, Boss...
🔄 Running: flutter build apk --release --flavor production, Boss!
[████████████████████████████░░]  95% - [apk - production] - Finishing...
✅ apk build completed successfully, Boss!
✅ Build saved: ~/Desktop/dartdosh-builds/my_app/apk/prod_1.2.3_46.apk
⏱️  Total time: 45.3 seconds. I worked 45.3 seconds for you, Boss! 💪
```

### Build Split APK
```bash
dartdosh build apk --production --split
```

Creates separate APKs for each architecture:
- `prod_1.2.3_46_arm64-v8a.apk`
- `prod_1.2.3_46_armeabi-v7a.apk`
- `prod_1.2.3_46_x86_64.apk`

### Build iOS IPA
```bash
dartdosh build ipa --production
# or short
dartdosh build ipa -p
```

### Build with Auto-Upload to App Store
```bash
# First, configure in dartdosh_config/settings.json:
{
  "ipa_upload": {
    "enabled": true,
    "apple_id": "your@email.com",
    "app_specific_password": "xxxx-xxxx-xxxx-xxxx"
  }
}

# Then build:
dartdosh build ipa -p
```

Output:
```
✅ ipa build completed successfully, Boss!
✅ Build saved: ~/Desktop/dartdosh-builds/my_app/ipa/prod_1.2.3_46.ipa

📤 IPA file uploading to App Store Connect, Boss...
⏳ Upload in progress...
✅ IPA successfully uploaded to App Store Connect, Boss!
```

### Build with Auto-Upload to Firebase Distribution
```bash
# First, configure in dartdosh_config/settings.json:
{
  "firebase_distribution": {
    "enabled": true,
    "app_id": "1:123456789:android:abc123",
    "tester_groups": "qa-team,developers"
  }
}

# Install Firebase CLI:
npm install -g firebase-tools
firebase login

# Then build:
dartdosh build apk -p
```

Output:
```
📝 Release notes for Firebase Distribution (press Enter to skip): Fixed login bug
🔧 apk build step: Running Flutter commands, Boss...
✅ apk build completed successfully, Boss!
✅ Build saved: ~/Desktop/dartdosh-builds/my_app/apk/prod_1.2.3_46.apk

📤 Uploading APK to Firebase App Distribution, Boss...
📝 Release Notes: Fixed login bug
✅ APK successfully uploaded to Firebase, Boss!
```

### Build Staging
```bash
dartdosh build apk --staging
dartdosh build apk -s
```

### Build Development
```bash
dartdosh build apk --development
dartdosh build apk -d
dartdosh build apk -dev
```

### Build App Bundle
```bash
dartdosh build appbundle --production
dartdosh build aab -p  # short version
```

### Add Extra Flags
```bash
dartdosh build apk -p --obfuscate --split-debug-info=/symbols
```

## Configuration Files

### 1. build_config.json (Team Shared)
```json
{
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

### 2. settings.json (Personal - Gitignored)
```json
{
  "language": "uz",
  "project_name": "my_app",
  "auto_increment_build_number": false,
  "output_path": "~/Desktop/dartdosh-builds",
  "ipa_upload": {
    "enabled": true,
    "apple_id": "developer@example.com",
    "app_specific_password": "abcd-efgh-ijkl-mnop"
  },
  "firebase_distribution": {
    "enabled": true,
    "app_id": "1:123456789:android:abc123def456",
    "tester_groups": "qa-team,developers"
  }
}
```

## Features

1. **Init Command**: Easy setup with `dartdosh init`
2. **2-File Config**: Team commands + Personal settings
3. **Multi-Language**: uz, en, ru
4. **Smart Naming**: `prod_1.2.3_46.apk`, `stg_2.0.0_12.ipa`
5. **Progress Bar**: Real-time build progress
6. **Auto Upload IPA**: Automatic upload to App Store Connect
7. **Auto Upload APK**: Automatic upload to Firebase App Distribution
8. **Interactive Notes**: Release notes prompt before upload
9. **Auto Version**: Optional build number increment
10. **Multi-Project**: Each project in own folder

## First Time Setup

```bash
# Install
dart pub global activate dartdosh

# Go to your Flutter project
cd your_project

# Initialize
dartdosh init
```

Output:
```
🚀 Configuring dartdosh, Boss...
✅ New config files created, Boss!

✅ Everything ready, feel free to use it now, Boss!
🚀 You can now use dartdosh build commands!
```

Now you can build:
```bash
dartdosh build apk -p
```

## Migration from Old Version

If you have old `build_config.json`, just run:
```bash
dartdosh init
```

Output:
```
🔄 Old build_config.json found, migrating to new structure, Boss...
✅ Migration successful! All data moved to new file, Boss!

✅ Everything ready, feel free to use it now, Boss!
```

Your old config data is preserved in the new structure!

## Output Structure

```
~/Desktop/dartdosh-builds/
└── my_app/
    ├── apk/
    │   ├── prod_1.0.0_100.apk
    │   ├── stg_1.0.0_101.apk
    │   └── dev_1.0.0_102.apk
    ├── ipa/
    │   ├── prod_1.0.0_100.ipa
    │   └── stg_1.0.0_101.ipa
    └── aab/
        └── prod_1.0.0_100.aab
```

## Tips

- Use short flags: `-p`, `-s`, `-d`
- `--split` for APK only (auto converts to `--split-per-abi`)
- Personal settings are gitignored (no credential conflicts!)
- Team shares build commands via `build_config.json`
- Each developer has own `settings.json`
