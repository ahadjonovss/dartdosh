## 0.1.6

### Features
- 🎯 **Desktop Output Path**: Default output path now points to `~/Desktop/dartdosh-builds` instead of `releases`
- 📂 **Auto File Open**: Config file automatically opens in default editor after creation
- 💬 **Improved Messages**: Better user feedback when config is created for first time
- 🖥️ **Cross-Platform**: Supports macOS, Linux, and Windows for auto file opening

### Changes
- Changed default `output_path` from `releases` to `~/Desktop/dartdosh-builds`
- Added `_openConfigFile()` helper method for opening config in default editor
- Enhanced console messages: "Xo'jayiin, default configlarni yaratdim, tekshirib ko'ring!"

## 0.1.5

### Package Maintenance
- ✅ **Added Verified Publisher**: Package now published under verified publisher `ahadjonovss.uz`
- 📦 **Publisher Information**: Added publisher field to pubspec.yaml for better package credibility

## 0.1.4

### Bug Fixes
- 🐛 **Fixed --split Flag for IPA**: The `--split` flag is now properly ignored for IPA builds (iOS doesn't support split builds)
- ✅ **Improved Flag Handling**: `--split` flag now only applies to APK builds, converting to `--split-per-abi`
- 📱 **Better Platform Support**: Different build targets now handle flags appropriately based on platform capabilities

## 0.1.3

### Critical Bug Fix
- 🔥 **Fixed Entry Point**: Updated main entry point to use the new CLI class architecture
- 🐛 **Resolved Environment Detection**: Fixed critical issue where dartdosh.dart was using old ArgParser code instead of the new CLI class
- ✅ **Simplified Architecture**: Main entry point now properly delegates to CLI class for cleaner code organization

## 0.1.2

### Bug Fixes
- 🐛 **Fixed Environment Flag Parsing**: Environment flags (--production, --staging, --development) are now correctly recognized and excluded from extra build flags
- 🐛 **Resolved "Unknown" Environment Error**: Fixed issue where environment was being detected as "unknown" even when flags were provided

## 0.1.1

### Code Quality Improvements
- ✅ **Added Dartdoc Comments**: All public APIs now have comprehensive documentation
- ✅ **Fixed Formatting Issues**: All files formatted with `dart format`
- ✅ **Fixed Linting Issues**: Removed unnecessary braces in string interpolation
- ✅ **Improved Pub Score**: Achieved 50/50 pub points with proper documentation

### Technical Changes
- Added dartdoc comments to CLI, BuildManager, and public functions
- Fixed string interpolation warnings
- Applied Dart formatting to entire codebase

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
