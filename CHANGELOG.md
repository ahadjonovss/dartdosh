## 0.1.0

### New Features
- ✅ **Automatic Build Number Increment**: Build number automatically increments by 1 before each build
- ✅ **Output Path Support**: Built files can be automatically copied to specified output directory
- ✅ **Smart File Naming**: Files are renamed to `{environment}_{version}_{buildNumber}` format
- ✅ **Auto Directory Creation**: Output directory is created automatically if it doesn't exist
- ✅ **Auto Config Generation**: If `build_config.json` doesn't exist, it's automatically created with default settings
- ✅ **Personalized Messages**: All log messages address the user as "Xo'jayiin" (Boss)

### Changes
- Updated `build_config.json` structure to support `output_path` parameter
- Build number is now incremented in `pubspec.yaml` before build starts
- Built files are copied to output path (if specified) instead of just being renamed
- Missing `build_config.json` is now auto-generated instead of causing an error
- All logger messages now include "Xo'jayiin" for a personalized experience

### Examples
```bash
# With output_path configured
dartdosh build apk --production
# Result: releases/production_1.2.3_46.apk

# Without output_path
dartdosh build apk --staging
# Result: build/app/outputs/flutter-apk/staging_1.2.3_46.apk
```

## 0.0.3

- Stable version with basic build functionality

## 0.0.1

- Initial version
