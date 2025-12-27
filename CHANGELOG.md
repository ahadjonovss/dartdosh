## 0.1.11

### Bug Fixes
- 🔧 **Fixed Terminal Clearing**: Progress bar now properly clears on macOS instead of creating new lines
- 📊 **Enhanced Progress Detection**: Added more build stage patterns (bundling, signing, assembling) for accurate progress tracking
- 🎯 **Better Stage Recognition**: Progress now advances beyond 20% by detecting bundle, sign, and assemble stages

### Changes
- Clear progress bar before showing stdout to prevent line duplication
- Added comprehensive lowercase pattern matching for build stages
- Added new build stages: bundling (60%), signing (80%), improved detection for assembling (70%)
- Progress bar only shows after first stdout output to avoid premature display

## 0.1.10

### Features
- ⚡ **Faster Progress Updates**: Progress bar now updates every 1 second (improved from 2 seconds)
- 📱 **Build Info Display**: Progress bar now shows target and flavor being built (e.g., `[apk - production]`)
- 🍎 **macOS Terminal Fix**: Improved terminal clearing for better compatibility on macOS

### Changes
- Changed progress update interval from 2 seconds to 1 second for more responsive feedback
- Added target and environment info to progress bar display
- Improved ANSI escape codes for terminal clearing on macOS

## 0.1.9

### Features
- 🔄 **Live Progress Updates**: Progress bar updates every 2 seconds with current task info
- 📋 **Task Indicator**: Shows what's happening: "Gradle ishlayapti...", "Flutter kodi kompilyatsiya qilinyapti..."
- 🎯 **AAB Support**: Full support for `aab` and `appbundle` commands with proper file detection
- 🔧 **Better File Detection**: Improved APK/AAB path detection for all flavors

### Changes
- Progress bar now updates periodically (every 2 seconds) instead of on-demand
- Added `Timer.periodic` for continuous progress updates
- Fixed appbundle/aab not being copied to output path
- Fixed flavor name duplication in Android build files
- Improved split APK architecture extraction (only arch name, no flavor duplication)
- Added more AAB path variants: productionRelease, stagingRelease, developmentDebug
- Added more APK path variants for different flavor configurations

### Bug Fixes
- Fixed: `aab` command not recognized
- Fixed: Progress bar showing only once and freezing
- Fixed: Appbundle files not moved to output directory
- Fixed: Android file names containing duplicate flavor names (e.g., `production_production_1.0.8.apk`)

## 0.1.8

### Features
- 📊 **Build Progress Bar**: Real-time progress bar with percentage during builds
- ⚡ **Async Build Process**: Non-blocking build execution with live output streaming
- 🎯 **Smart Progress Detection**: Automatically detects Flutter build stages and updates progress

### Changes
- Removed auto-open config file feature (config file no longer opens automatically)
- Converted build process from sync to async for better performance
- Added `_handleProcessOutput()` method for streaming build output
- Added `_showProgress()` method with animated progress bar
- Removed `configFileOpened` LogType (no longer needed)

## 0.1.7

### Features
- 💝 **Donation Messages**: After successful builds, random humorous donation messages appear (10 variants)
- 📝 **Logger System**: All console output now goes through the Logger system for consistency
- 🎨 **Better File Naming**: Build files now named as `{target}_{env}_{version}_{buildNumber}` (e.g., `apk_production_1.0.8_2150.apk`)
- 🔧 **Enhanced LogTypes**: Added `buildNumberIncremented`, `fileSaved`, `outputDirCreated` for detailed logging

### Changes
- Removed all `print()` statements in favor of `Logger.log()`
- Fixed file naming bug where environment was duplicated in filename
- Added new LogType variants with random message selection
- Improved code organization and consistency

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
