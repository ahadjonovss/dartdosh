# DartDosh CLI – User Guide

`DartDosh` is a powerful CLI tool for simplifying Flutter builds with automatic version management, multi-language support, and smart output handling.

## 📺 Video Tutorial

[![DartDosh Tutorial](https://img.youtube.com/vi/QpNVwk4SVZA/maxresdefault.jpg)](https://youtu.be/QpNVwk4SVZA?si=kV7kTtHcnZLfv1ZP)

Watch the full tutorial on YouTube: [DartDosh - Flutter Build Automation](https://youtu.be/QpNVwk4SVZA?si=kV7kTtHcnZLfv1ZP)

---

```bash
dartdosh build <target> --<environment> [extra flags]
```

**Examples:**

```bash
# With environment (flavor builds) - automatic version management
dartdosh build ipa --production --split
dartdosh build apk --development --other-flag
dartdosh build appbundle --staging

# Short flags (convenient!)
dartdosh build apk -p              # production
dartdosh build apk -prod           # production
dartdosh build apk -d              # development
dartdosh build apk -dev            # development
dartdosh build apk -s              # staging

# Without environment - plain Flutter build (no version management)
dartdosh build apk                 # flutter build apk
dartdosh build apk --release       # flutter build apk --release
dartdosh build ipa --split         # flutter build ipa --split-per-abi
```

---

## Requirements

* Dart SDK ≥ 3.0
* Flutter SDK installed
* Terminal (Mac/Linux/Windows)

---

## Installation

### Install from pub.dev

```bash
dart pub global activate dartdosh
```

### Add to PATH (if needed)

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
  "language": "uz",
  "project_name": "my_app",
  "auto_increment_build_number": false,
  "output_path": "~/Desktop/dartdosh-builds",
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
    "staging": "flutter build ipa --release --flavor staging"
  },
  "appbundle": {
    "production": "flutter build appbundle --release --flavor production",
    "staging": "flutter build appbundle --release --flavor staging",
    "development": "flutter build appbundle --debug --flavor development"
  }
}
```

**Config Parameters:**

* `language` (optional): Interface language for all log messages and progress indicators
  - **Supported languages**: `uz` (Uzbek), `en` (English), `ru` (Russian)
  - **Default**: `uz`
  - **Fallback**: If unsupported language is set, defaults to English with a warning
  - Examples:
    ```json
    "language": "en"  // English interface
    "language": "ru"  // Russian interface
    "language": "uz"  // Uzbek interface (default)
    ```

* `project_name` (optional): Project name used for organizing builds in output directory
  - **Type**: `string`
  - **Default**: Reads from `pubspec.yaml` `name` field
  - **Purpose**: Creates a subfolder in `output_path` for this project's builds
  - **Multi-project support**: Each project gets its own folder in the output directory
  - Examples:
    ```json
    "project_name": "my_app"        // Builds go to output_path/my_app/
    "project_name": "ecommerce_app" // Builds go to output_path/ecommerce_app/
    ```
  - **File structure**:
    ```
    ~/Desktop/dartdosh-builds/
    ├── my_app/
    │   ├── apk/
    │   │   ├── prod_1.0.0_100.apk
    │   │   └── dev_1.0.0_101.apk
    │   ├── ipa/
    │   │   └── prod_1.0.0_100.ipa
    │   └── aab/
    │       └── prod_1.0.0_100.aab
    └── ecommerce_app/
        ├── apk/
        │   └── prod_2.0.0_50.apk
        └── ipa/
            └── stg_2.0.0_51.ipa
    ```

* `auto_increment_build_number` (optional): Control automatic build number increment
  - **Type**: `boolean`
  - **Default**: `false`
  - **When true**: Build number in `pubspec.yaml` increments before each flavor build
  - **When false**: Build number stays unchanged (default behavior)
  - **Note**: Only applies to flavor builds (with environment flags). Plain builds never increment.
  - Examples:
    ```json
    "auto_increment_build_number": true   // Enable auto increment
    "auto_increment_build_number": false  // Disable increment (default)
    ```

* `output_path` (optional): Path where built files will be copied after build
  - If not specified, files will only be renamed in the build directory
  - Can be absolute path (`/Users/you/releases`) or relative to project (`releases`)
  - Directory will be created automatically if it doesn't exist
  - Default: `~/Desktop/dartdosh-builds`

* `ipa_upload` (optional): Configuration for automatic IPA upload to App Store Connect
  - **Type**: `object`
  - **Default**: `{ "enabled": false, ... }`
  - **Fields**:
    - `enabled` (boolean): Enable/disable automatic upload
    - `apple_id` (string): Your Apple ID email
    - `app_specific_password` (string): App-specific password from Apple ID settings
  - **Requirements**: macOS with Xcode installed
  - **Example**:
    ```json
    "ipa_upload": {
      "enabled": true,
      "apple_id": "developer@example.com",
      "app_specific_password": "abcd-efgh-ijkl-mnop"
    }
    ```
  - **How to get App-Specific Password**:
    1. Go to https://appleid.apple.com
    2. Sign in with your Apple ID
    3. In Security section, click "Generate Password" under App-Specific Passwords
    4. Give it a name (e.g., "DartDosh") and copy the generated password

---

## Usage

```bash
dartdosh build <target> [--<environment>] [extra flags]
```

**Parameters:**

* `<target>`: Build target
  - `apk` - Android APK
  - `ipa` - iOS IPA
  - `appbundle` or `aab` - Android App Bundle (both commands supported)

* `<environment>`: Build environment (OPTIONAL - multiple flag variants supported!)
  - **Production**: `--production`, `-p`, `-prod`
  - **Staging**: `--staging`, `-s`
  - **Development**: `--development`, `-d`, `-dev`
  - **Note**: If no environment specified, runs plain Flutter build without version management

* `[extra flags]`: Additional Flutter build flags
  - `--split` - For APK builds, automatically adds `--split-per-abi`
  - `--obfuscate` - Obfuscate Dart code
  - `--dart-define=KEY=VALUE` - Define environment variables
  - Any other Flutter build flags

---

## Features

### 🌍 Multi-Language Support
DartDosh supports three languages for all interface messages and progress indicators:

* **Uzbek (uz)** - Default language with "Xo'jayiin" (Boss) addressing
* **English (en)** - Professional English interface with "Boss" addressing
* **Russian (ru)** - Russian interface with "Босс" (Boss) addressing

**Setting Language:**
```json
{
  "language": "en"  // Set in build_config.json
}
```

**Language Features:**
* All log messages translated
* Progress bar stages localized
* Build status messages in selected language
* Donation messages with cultural humor
* Automatic fallback to English for unsupported languages with warning

**Example Uzbek:**
```
📈 Yangi build number: 46 (oldingi: 45), Xo'jayiin!
[████████████████░░░░░░░░░░░░░░]  60% - [apk - production] - Bundle yaratilmoqda...
✅ apk build muvaffaqiyatli yakunlandi, Xo'jayiin!
```

**Example English:**
```
📈 New build number: 46 (previous: 45), Boss!
[████████████████░░░░░░░░░░░░░░]  60% - [apk - production] - Creating bundle...
✅ apk build completed successfully, Boss!
```

### 🤖 Auto Configuration
When `build_config.json` doesn't exist in your Flutter project, DartDosh will:
1. **Create the config** with sensible defaults
2. **Open it in your IDE** automatically for review
3. **Stop execution** and prompt you to re-run the command

This ensures you can review and adjust the configuration before your first build.

**Example workflow:**
```bash
# First run (no config exists)
dartdosh build apk --production
# Output: Config created and opened in IDE, please review and run again

# Second run (config reviewed)
dartdosh build apk --production
# Output: Normal build proceeds
```

### 🔢 Automatic Version Management (Optional)

**When using environment flags** (flavor builds) and `auto_increment_build_number: true`, DartDosh automatically:
1. Reads the current version from `pubspec.yaml`
2. Increments the build number by 1
3. Updates `pubspec.yaml` with the new build number

**Example:**
```yaml
# Before build (with environment flag and auto_increment enabled)
version: 1.2.3+45

# After build
version: 1.2.3+46
```

**Notes**:
- **Default**: `false` (auto increment is disabled by default)
- Version increment only happens for flavor builds (with environment flag)
- Enable by setting `auto_increment_build_number: true` in config
- Plain builds (`dartdosh build apk`) never modify version numbers

### 📦 Smart File Naming

**For flavor builds** (with environment flags), built files are automatically renamed using the format:
```
{shortEnv}_{version}_{buildNumber}.{extension}
```

**Environment short names:**
- `production` → `prod`
- `development` → `dev`
- `staging` → `stg`

**Examples:**
* `prod_1.2.3_46.apk`
* `stg_2.0.0_12.ipa`
* `dev_1.5.0_78.aab`

For split APKs:
* `prod_1.2.3_46_arm64-v8a.apk`
* `prod_1.2.3_46_armeabi-v7a.apk`
* `prod_1.2.3_46_x86_64.apk`

**For plain builds** (without environment), files are renamed using the format:
```
{target}_{version}_{buildNumber}.{extension}
```

**Examples:**
* `apk_1.2.3_46.apk`
* `ipa_2.0.0_12.ipa`
* `appbundle_1.5.0_78.aab`

Note: Plain builds don't increment version, but still get renamed and moved to output_path.

### 📁 Output Path Management

If `output_path` is specified in `build_config.json`:
* Built files are **copied** to the specified directory with organized structure
* Files are organized by: `output_path/project_name/{apk|ipa|aab}/`
* Each build type gets its own subfolder for better organization
* Original files remain in the build directory
* Directory structure is created automatically

**Example structure:**
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

Without `output_path`:
* Files are only **renamed** in the build directory

---

## 🚀 IPA Auto Upload to App Store Connect

DartDosh can automatically upload your IPA files to App Store Connect after a successful build using Apple's official Transporter tool.

### Prerequisites

1. **macOS with Xcode installed** - Required for `xcrun iTMSTransporter`
2. **Valid Apple Developer Account** - With app created in App Store Connect
3. **Valid Certificates & Provisioning Profiles** - iOS Distribution certificate and provisioning profile
4. **App-Specific Password** - Generated from Apple ID settings

### Step 1: Generate App-Specific Password

1. Go to https://appleid.apple.com
2. Sign in with your Apple ID (the one used for App Store Connect)
3. Navigate to **Security** section
4. Under **App-Specific Passwords**, click **Generate Password**
5. Enter a label (e.g., "DartDosh CLI Tool")
6. Click **Create**
7. **Copy the generated password** (format: `xxxx-xxxx-xxxx-xxxx`)
   - ⚠️ Save this password - you can't view it again!

### Step 2: Configure build_config.json

Open your `build_config.json` and add/update the `ipa_upload` section:

```json
{
  "language": "uz",
  "project_name": "my_app",
  "auto_increment_build_number": false,
  "output_path": "~/Desktop/dartdosh-builds",
  "ipa_upload": {
    "enabled": true,                                    // ← Set to true
    "apple_id": "developer@example.com",                // ← Your Apple ID
    "app_specific_password": "abcd-efgh-ijkl-mnop"     // ← Paste generated password
  }
}
```

### Step 3: Build and Upload

Simply build your IPA as usual:

```bash
dartdosh build ipa --production
```

**What happens:**
1. ✅ Flutter builds the IPA
2. ✅ DartDosh renames and moves the file
3. ✅ Automatically uploads to App Store Connect
4. ✅ Shows upload progress and result

**Example output:**
```
✅ ipa build completed successfully, Boss!
📂 File saved: ~/Desktop/dartdosh-builds/my_app/ipa/prod_1.0.0_100.ipa

📤 Uploading IPA to App Store Connect...
File: ~/Desktop/dartdosh-builds/my_app/ipa/prod_1.0.0_100.ipa
Apple ID: developer@example.com
✅ IPA successfully uploaded to App Store Connect!
```

### Configuration Options

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `enabled` | boolean | `false` | Enable/disable automatic upload |
| `apple_id` | string | `""` | Your Apple ID email address |
| `app_specific_password` | string | `""` | App-specific password from Apple ID |

### Troubleshooting

**Error: "IPA upload enabled but credentials not set!"**
- Make sure you've filled in both `apple_id` and `app_specific_password` in config

**Error: "xcrun: error: unable to find utility"**
- Xcode is not installed or command-line tools are not configured
- Install Xcode from Mac App Store
- Run: `xcode-select --install`

**Error: "Authentication failed"**
- App-specific password might be incorrect or expired
- Generate a new app-specific password and update config
- Make sure you're using the correct Apple ID

**Error: "Package upload failed"**
- Check that your app exists in App Store Connect
- Verify iOS distribution certificate is valid
- Ensure provisioning profile matches the build

**Upload is slow or hanging**
- This is normal for large IPA files (can take several minutes)
- Check your internet connection
- The tool will show progress and wait for completion

### Security Notes

⚠️ **Important Security Considerations:**

1. **Don't commit credentials to git**
   - Add `build_config.json` to `.gitignore`
   - Never push files containing your app-specific password

2. **App-specific passwords are safer**
   - They can be revoked individually
   - Don't give access to your main Apple ID password
   - Can be regenerated if compromised

3. **Team workflows**
   - Each developer should use their own Apple ID and password
   - Or use shared credentials stored in secure password manager
   - Consider using CI/CD secrets for automated builds

### Disabling Auto Upload

To disable automatic upload while keeping your credentials:

```json
"ipa_upload": {
  "enabled": false,  // ← Just set to false
  "apple_id": "developer@example.com",
  "app_specific_password": "abcd-efgh-ijkl-mnop"
}
```

---

## Notes

### Environment Flags
* **Full flags**: `--production`, `--staging`, `--development`
* **Short flags**: `-p`, `-prod`, `-s`, `-d`, `-dev`
* All variants work identically

### Language Support
* **Supported**: `uz` (Uzbek), `en` (English), `ru` (Russian)
* **Default**: Uzbek (`uz`)
* **Unsupported language**: Automatically falls back to English with a warning:
  ```
  ⚠️  Warning: Language "fr" is not supported. Falling back to English.
     Supported languages: uz (Uzbek), en (English), ru (Russian)
  ```

### Build Behavior
* For APK builds, `--split` automatically adds `--split-per-abi`
* Any additional flags after the base command are appended automatically
* Build number is incremented **before** the build starts
* All messages are personalized ("Xo'jayiin" for Uzbek, "Boss" for English/Russian)
* Missing `build_config.json` is automatically created with default settings
* Progress bar shows real-time build stages in your selected language
