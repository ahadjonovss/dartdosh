## 0.5.5

### Improvements
- 🔧 **Complete Default Config**: Added development flavor to IPA builds in default config
  - Now all build types (APK, IPA, AAB) have production, staging, and development flavors
  - Consistent configuration across all platforms
- 📋 **Better Log Ordering**: Donation message now appears at the very end after total time
  - More logical flow: success → time → donation

### Configuration
Default config now includes:
```json
"ipa": {
  "production": "flutter build ipa --release --flavor production",
  "staging": "flutter build ipa --release --flavor staging",
  "development": "flutter build ipa --debug --flavor development"
}
```

## 0.5.4

### Improvements
- ⏱️ **Execution Time Tracking**: Now tracks and displays total time for each build command
  - Shows total execution time at the end with positive motivational messages
  - Displays time in seconds with one decimal precision
  - Multilingual support (uz/en/ru) for time messages
- 📊 **Enhanced Upload Logging**: Improved IPA upload progress visibility
  - All upload output now uses the Logger system
  - Removed hardcoded print statements
  - Shows altool stdout/stderr as structured progress logs
  - Better error messages during upload failures
- 🎨 **Clean Logging Architecture**: Converted all print statements to Logger
  - Consistent multilingual logging throughout the codebase
  - Added `uploadProgress` and `totalTime` LogType enums
  - Structured and organized log messages

### Technical Changes
- Added `Stopwatch` to track build execution time
- Added `progress` and `time` parameters to Logger.log()
- Updated switch statement to handle new LogType cases
- Upload output parsing and line-by-line progress logging

## 0.5.3

### Bug Fixes
- 🔧 **IPA Upload Fix**: Switched from iTMSTransporter to altool for IPA uploads
  - altool accepts `.ipa` files directly (iTMSTransporter expected directories)
  - Simpler and more reliable upload process
  - Fixes "is NOT a directory" error from iTMSTransporter

## 0.5.2

### Bug Fixes
- 🐛 **IPA Upload Fix**: Fixed iTMSTransporter "Unknown transport specified: ios" error
  - Removed invalid `-t ios` parameter from iTMSTransporter command
  - Upload to App Store Connect should now work correctly
- 📊 **Upload Visibility**: Added stdout output display for upload process
  - Shows complete iTMSTransporter output for better visibility
  - Helps users understand what's happening during upload

## 0.5.1

### Bug Fixes
- 🐛 **Upload Error Details**: Added detailed error messages for IPA upload failures
  - Shows stderr output when upload fails
  - Helps debug Xcode/Transporter issues

## 0.5.0

### Features
- 🎯 **Version Commands**: New version management commands with fun, localized messages
  - `dartdosh --version` or `dartdosh -v` - Show current version
  - `dartdosh --check-version` - Check for updates on pub.dev
  - `dartdosh upgrade` - Upgrade to latest version
  - `dartdosh downgrade` - Downgrade to previous version (0.4.1)
  - `dartdosh downgrade <version>` - Downgrade to specific version
- 🌍 **Multilingual Support**: All version commands support Uzbek, English, and Russian
- 😎 **Fun Messages**: Random cheerful messages for each operation (Boss/Xo'jayiin/Босс style)

### Commands
```bash
# Check version
dartdosh --version
dartdosh -v

# Check for updates
dartdosh --check-version

# Upgrade to latest
dartdosh upgrade

# Downgrade
dartdosh downgrade          # to previous version
dartdosh downgrade 0.4.1    # to specific version
```

## 0.4.2

### Bug Fixes
- 🚀 **Universal IPA Upload**: Fixed IPA upload to work for both flavor and non-flavor builds
  - Now works with `dartdosh build ipa` (no environment)
  - Also works with `dartdosh build ipa --production` (with environment)
  - Upload process is consistent across all build commands

## 0.4.1

### Improvements
- 📺 **Video Tutorial**: Added YouTube tutorial link at the top of README.md
- 🧹 **Simplified Config**: Removed `upload_after_build` field - IPA upload now controlled only by `enabled` flag
- 📝 **Enhanced Logging**: All upload process messages now use Logger system for multilingual output
- 🎨 **Consistent Output**: Replaced all `print()` statements with `Logger.log()` calls throughout codebase

### Breaking Changes
- The `upload_after_build` field has been removed from `ipa_upload` configuration
- If you have this field in your config, simply remove it - upload is now controlled only by the `enabled` flag

## 0.4.0

### Features
- 🚀 **IPA Auto Upload to App Store**: Automatically upload IPA files to App Store Connect after build
- 📤 **Transporter Integration**: Uses `xcrun iTMSTransporter` for reliable uploads
- ⚙️ **Configurable Upload**: Control upload behavior via `ipa_upload.enabled` flag
- 🔐 **Secure Credentials**: Store Apple ID and App-Specific Password in config
- 🎨 **Localized Upload Logs**: Upload process messages in Uzbek, English, and Russian
- 📝 **Clean Logging**: All messages use Logger system for consistent multilingual output

### Configuration
New `ipa_upload` section in build_config.json:
```json
{
  "ipa_upload": {
    "enabled": false,              // Enable/disable IPA upload
    "apple_id": "your@apple.id",   // Your Apple ID
    "app_specific_password": "xxxx-xxxx-xxxx-xxxx"  // App-specific password
  }
}
```

### How It Works
1. Build IPA with dartdosh
2. If `ipa_upload.enabled` is true and credentials are set
3. Automatically uploads to App Store Connect using Apple's Transporter
4. Shows localized upload progress and results

### Requirements
- macOS with Xcode installed (for `xcrun iTMSTransporter`)
- Apple ID with app-specific password
- Valid iOS distribution certificate and provisioning profile

### Technical Changes
- Removed `upload_after_build` field (simplified to just `enabled`)
- Added 4 new LogTypes: `uploadStarting`, `uploadSuccess`, `uploadFailed`, `uploadCredentialsMissing`
- All upload messages now support uz/en/ru languages
- Replaced all `print()` calls with `Logger.log()` for consistency

## 0.3.3

### Features
- 📂 **Type-Based Subfolders**: Build files now organized by type (apk/ipa/aab) within project folder
- 🔧 **AAB Command Support**: Added support for `aab` as alternative to `appbundle` command
- 🔒 **Git Push Confirmation**: Added pre-push hook to confirm before pushing to remote

### Changes
- Output structure now: `output_path/project_name/{apk|ipa|aab}/file.ext`
- CLI now accepts `dartdosh build aab` (normalized to `appbundle`)
- Git hook prompts for confirmation before every push

### File Structure
```
~/Desktop/dartdosh-builds/
└── my_app/
    ├── apk/
    │   ├── prod_1.0.0_100.apk
    │   └── dev_1.0.0_101.apk
    ├── ipa/
    │   └── prod_1.0.0_100.ipa
    └── aab/
        └── prod_1.0.0_100.aab
```

## 0.3.2

### Changes
- 🔧 **Removed Auto-Open Config**: Config file no longer opens automatically in IDE after creation
- ✅ **Improved Config Creation**: Added async write with flush to ensure file is properly written
- 📝 **Better User Experience**: User manually opens and reviews config file instead of auto-open

### Technical
- Removed `_openConfigFile()` method
- Made `_createDefaultConfig()` async with `flush: true` parameter
- Added 100ms delay after write to ensure file system flush

## 0.3.1

### Bug Fixes
- 🐛 **Fixed Config File Creation**: Ensure build_config.json is fully written before opening in IDE
- ✅ **Improved File Write Order**: File is now verified to exist before attempting to open
- 🔧 **Prevent Empty Config Files**: Added file existence check to prevent race conditions

### Changes
- Added file existence verification after config creation
- Config file is only opened if successfully written
- Prevents empty or incomplete config files from being opened

## 0.3.0

### Features
- 🗂️ **Multi-Project Support**: Added `project_name` field for organizing builds by project
- 📁 **Project-Based Folders**: Each project gets its own subfolder in output directory
- 🎯 **Auto Project Detection**: Reads project name from `pubspec.yaml` by default
- 🏢 **Multi-Project Workflow**: Use same output directory for multiple projects

### Changes
- Added `project_name` field to build config (defaults to pubspec.yaml name)
- Output path now includes project subfolder: `output_path/project_name/`
- All builds are organized: `~/Desktop/dartdosh-builds/my_app/prod_1.0.0_100.apk`
- Updated all documentation with multi-project examples

### File Structure
```
~/Desktop/dartdosh-builds/
├── my_app/
│   ├── prod_1.0.0_100.apk
│   └── dev_1.0.0_101.apk
└── ecommerce_app/
    ├── prod_2.0.0_50.apk
    └── stg_2.0.0_51.ipa
```

### Configuration
```json
{
  "project_name": "my_app",  // New field
  "output_path": "~/Desktop/dartdosh-builds",
  ...
}
```

## 0.2.9

### Documentation
- 📚 **Updated All Documentation**: All docs, examples, and configs updated to reflect latest features
- 📝 **Updated build_config.example.json**: Added language and auto_increment_build_number fields
- 📖 **Updated example/README.md**: Updated all examples with new file naming format and features
- 🎯 **Consistent Examples**: All examples now show correct output format (prod_1.2.3_46.apk)

### Changes
- Updated example outputs to show new short environment naming
- Updated feature descriptions to reflect current behavior
- Added multi-language support and auto-increment info to examples
- Removed outdated version increment references from examples

## 0.2.8

### Features
- 📝 **Shorter File Names**: Build files now use short environment names instead of full names
- 🎯 **Clean Naming**: Files are named as `{shortEnv}_{version}_{buildNumber}.{ext}` (e.g., `prod_1.0.9_2155.apk`)
- ✨ **Consistent Format**: All flavor builds follow the same compact naming pattern

### Changes
- Environment name mapping: `production` → `prod`, `development` → `dev`, `staging` → `stg`
- Removed target name from flavor build file names for cleaner output
- File extension indicates the type (`.apk`, `.ipa`, `.aab`)

### Examples
**Before:**
```
apk_production_1.0.9_2155.apk
ipa_staging_2.0.0_12.ipa
```

**After:**
```
prod_1.0.9_2155.apk
stg_2.0.0_12.ipa
```

**Split APKs:**
```
prod_1.0.9_2155_arm64-v8a.apk
prod_1.0.9_2155_armeabi-v7a.apk
```

## 0.2.7

### Changes
- 🔧 **Default Behavior Update**: `auto_increment_build_number` now defaults to `false`
- 📝 **Documentation Update**: All docs updated to reflect new default behavior
- ⚙️ **Opt-in Version Management**: Users must explicitly enable auto increment by setting config to `true`

### Rationale
- Prevents unexpected version changes
- Gives users explicit control over version management
- More predictable default behavior

## 0.2.6

### Features
- 🎯 **Better Config Creation UX**: When build_config.json doesn't exist, it's created and opened in IDE
- 🛑 **Smart Config Workflow**: Execution stops after config creation, prompting user to review and re-run
- ⚙️ **Optional Build Number Increment**: Added `auto_increment_build_number` boolean field in config (default: false)

### Changes
- Config file now automatically opens in default IDE when created
- Added `buildConfigCreated` LogType with instructions to review config and re-run
- Build number increment is now disabled by default, can be enabled by setting `auto_increment_build_number: true`
- Execution stops after config creation instead of continuing with build

### Configuration
```json
{
  "language": "uz",
  "auto_increment_build_number": false,  // New field (default: false)
  "output_path": "~/Desktop/dartdosh-builds",
  ...
}
```

### Examples
```bash
# First run - creates config and stops
dartdosh build apk --production
# Output: Config created, opened in IDE, asks to re-run

# Second run - proceeds with build
dartdosh build apk --production
# Output: Normal build process (version not incremented by default)

# Enable auto increment in config
"auto_increment_build_number": true
# Build runs with version increment
```

## 0.2.5

### Features
- 📦 **File Management for All Builds**: Files are now renamed and moved to output_path even without environment flags
- 🎯 **Consistent Output**: Both flavor and plain builds get organized file naming

### Changes
- Non-environment builds now rename files to `{target}_{version}_{buildNumber}` format
- Files are moved to output_path regardless of environment flag presence
- Only version increment is skipped for non-environment builds
- File organization works for all build types

### Examples
```bash
# With environment - increments version, renames: apk_production_1.2.3_46.apk
dartdosh build apk --production

# Without environment - no version increment, renames: apk_1.2.3_46.apk
dartdosh build apk
```

## 0.2.4

### Features
- 🎯 **Optional Environment**: Environment flags are now optional - run plain Flutter commands without flavors
- 🔧 **Flexible Builds**: Use `dartdosh build apk` for simple builds without version management
- 📦 **Smart Behavior**: Version increment and file renaming only happen when environment is specified

### Changes
- Environment parameter is now nullable in CLI and BuildManager
- When no environment specified, runs plain `flutter build <target>` command
- Build number increment only happens for flavor builds (when environment is specified)
- File renaming/moving only occurs for flavor builds
- Default environment display shows "default" in logs when no environment provided

### Examples
```bash
# With environment (flavor build) - increments version, renames files
dartdosh build apk --production
dartdosh build apk -p

# Without environment (plain Flutter build) - no version management
dartdosh build apk
dartdosh build ipa --release
```

## 0.2.3

### Features
- ⚠️ **Language Validation**: Unsupported languages now show warning and fallback to English
- 📚 **Comprehensive Documentation**: Updated README with detailed language support, flag variants, and examples
- 🌍 **Language Configuration Guide**: Clear documentation on how to set and use language preferences

### Changes
- Added language validation in `Logger.setLanguage()` with user-friendly warning
- Unsupported languages automatically fallback to English with informative message
- Updated README with multi-language examples in Uzbek and English
- Documented all environment flag variants (`-p`, `-prod`, `-d`, `-dev`, `-s`)
- Added language support notes and behavior documentation

### Documentation
- Added multi-language support section with examples
- Documented all short flag variants for environments
- Added language fallback behavior explanation
- Improved configuration examples with language field
- Added comprehensive feature descriptions

## 0.2.2

### Features
- 🌐 **Localized Progress Bar**: Progress bar tasks now translate according to selected language
- 📊 **Multi-Language Build Stages**: All build stages (Gradle, Dependencies, Compiling, etc.) display in user's language

### Changes
- Added `Logger.getProgressTask()` static method for progress task translations
- Created `_progressTasks` map with translations for all build stages
- Updated `_handleProcessOutput()` to use localized progress messages
- Progress stages now support Uzbek, English, and Russian

### Technical
- New progress task keys: `starting`, `gradle`, `dependencies_downloading`, `dependencies_ready`, `compiling`, `bundling`, `assembling`, `signing`, `finishing`, `ready`
- BuildManager now calls `Logger.getProgressTask()` for all stage updates

## 0.2.1

### Features
- ⚡ **Short Flag Support**: Added convenient shorthand flags for environments
  - Production: `--production`, `-p`, `-prod`
  - Staging: `--staging`, `-s`
  - Development: `--development`, `-d`, `-dev`

### Changes
- Enhanced CLI flag parsing to accept multiple variants for each environment
- Updated environment flag filtering in extra flags extraction
- Improved documentation for flag options

### Examples
```bash
# All these commands work the same:
dartdosh build apk --production
dartdosh build apk -p
dartdosh build apk -prod

dartdosh build apk --development
dartdosh build apk -d
dartdosh build apk -dev

dartdosh build apk --staging
dartdosh build apk -s
```

## 0.2.0

### Features
- 🌍 **Multi-Language Support**: Full support for Uzbek (uz), English (en), and Russian (ru) languages
- 🎯 **Language Configuration**: Added `language` field to build_config.json (default: "uz")
- 💬 **Localized Messages**: All log messages translated with positive, encouraging tone across all languages
- 🌟 **Cultural Adaptation**: Language-appropriate addressing - "Xo'jayiin" (uz), "Boss" (en), "Босс" (ru)

### Changes
- Completely rewrote Logger class with multi-language support
- Added static language state management in Logger
- Implemented nested Map structure for translations: `Map<String, Map<LogType, List<String>>>`
- All LogTypes now support 3 languages with multiple message variants
- Language is read from build_config.json and applied to all log messages
- BuildManager now sets language from config before executing builds

### Technical
- Added `Logger.setLanguage(String language)` static method
- Language validation: only accepts 'uz', 'en', 'ru'
- Default language: 'uz' (Uzbek) if not specified in config
- Maintains random message selection within each language

## 0.1.12

### Features
- 🎯 **Clean Progress Display**: Build output is now hidden, showing only clean progress bar
- ⚠️ **Smart Error Display**: Warnings and errors are still shown when they occur
- 📊 **Enhanced Stage Detection**: Added dependency resolution (30%) and "Got dependencies" (40%) stages

### Changes
- Removed verbose Flutter build output for cleaner terminal
- Only show warnings, errors, and failures from build output
- Added dependency-related progress stages
- Progress bar updates smoothly through all build stages (20% → 40% → 60% → 95%)

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
