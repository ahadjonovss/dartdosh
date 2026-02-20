# iOS Build & App Store Upload

← [Back to docs](../README.en.md)

---

DartDosh builds iOS IPAs and can automatically upload them to App Store Connect after a successful build.

## Prerequisites

- macOS with Xcode installed
- Valid Apple Developer Account
- Code signing configured in Xcode (certificates + provisioning profiles)
- App created in [App Store Connect](https://appstoreconnect.apple.com)

---

## Build IPA

```bash
dartdosh build ipa -p   # production
dartdosh build ipa -s   # staging
dartdosh build ipa -d   # development

# With extra flags
dartdosh build ipa -p --obfuscate
dartdosh build ipa -p --dart-define=API_URL=https://api.example.com
```

---

## Auto Upload to App Store Connect

### Step 1 — Generate App-Specific Password

1. Go to [appleid.apple.com](https://appleid.apple.com)
2. Sign in → **Security** → **App-Specific Passwords** → **Generate Password**
3. Name it `DartDosh` and copy the password (format: `xxxx-xxxx-xxxx-xxxx`)

> ⚠️ Save the password — you can't view it again.

### Step 2 — Configure `settings.json`

```json
{
  "ipa_upload": {
    "enabled": true,
    "apple_id": "developer@example.com",
    "app_specific_password": "xxxx-xxxx-xxxx-xxxx"
  }
}
```

### Step 3 — Build and upload

```bash
dartdosh build ipa -p
```

DartDosh will build → rename → move → upload automatically.

**Example output:**
```
✅ ipa build completed successfully, Boss!
✅ Build saved: ~/Desktop/dartdosh-builds/my_app/ipa/prod_1.0.0_100.ipa
📤 Uploading IPA to App Store Connect...
✅ IPA successfully uploaded to App Store Connect, Boss!
```

---

## Troubleshooting

| Error | Fix |
|-------|-----|
| `xcrun: unable to find utility` | Run: `xcode-select --install` |
| `Authentication failed` | Regenerate app-specific password at [appleid.apple.com](https://appleid.apple.com) |
| `Package upload failed` | Make sure the app exists in App Store Connect |
| Upload hangs | Normal for large files — check internet connection |
| Build fails | Check code signing in Xcode, run `flutter doctor` |

---

## Notes

- Upload uses `xcrun iTMSTransporter` — built into Xcode, no extra install
- Upload only uploads the build — you still submit it through App Store Connect
- Set `"enabled": false` to disable upload while keeping credentials saved
