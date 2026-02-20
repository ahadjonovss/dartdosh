# Firebase App Distribution

← [Back to docs](../README.en.md)

---

DartDosh can automatically upload your APK to Firebase App Distribution after each build.

## Prerequisites

1. Install Firebase CLI:
   ```bash
   npm install -g firebase-tools
   ```
2. Login:
   ```bash
   firebase login
   ```

---

## Setup

### Step 1 — Add App IDs to `build_config.json`

Get your App ID from **Firebase Console → Your App → Project Settings**.

```json
{
  "firebase_distribution": {
    "production": {
      "app_id": "1:123456789:android:prodabc123",
      "tester_groups": "production-testers,management"
    },
    "staging": {
      "app_id": "1:123456789:android:stagabc123",
      "tester_groups": "qa-team,staging-testers"
    },
    "development": {
      "app_id": "1:123456789:android:devabc123",
      "tester_groups": "developers"
    }
  }
}
```

> `tester_groups` — comma-separated list of tester group names from Firebase Console → App Distribution.

### Step 2 — Enable per environment in `settings.json`

```json
{
  "firebase_distribution": {
    "production":  { "enabled": false },
    "staging":     { "enabled": true },
    "development": { "enabled": true }
  }
}
```

Each developer controls which environments they upload to independently.

### Step 3 — Build and upload

```bash
dartdosh build apk -s   # builds APK + uploads to staging testers automatically
```

**Example output:**
```
✅ apk build completed successfully, Boss!
✅ Build saved: ~/Desktop/dartdosh-builds/my_app/apk/stg_1.0.0_50.apk
📤 Uploading APK to Firebase App Distribution, Boss...
✅ APK successfully uploaded to Firebase, Boss!
```

---

## Notes

- The `app_id` goes in `build_config.json` (team-shared)
- The `enabled` flag goes in `settings.json` (personal — each dev decides for themselves)
- Firebase CLI must be logged in (`firebase login`) on the machine running the upload
