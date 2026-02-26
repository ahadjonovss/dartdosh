# Google Play Store Upload

← [Back to docs](../README.en.md)

---

DartDosh can automatically upload your AAB to Google Play Store after each build using the Android Publisher API — no extra tools required, just a service account JSON key.

> **Note:** The app must have at least one version already published manually before automated uploads will work.

---

## Setup

### Step 1 — Create a Service Account in Google Play Console

1. Open [Google Play Console](https://play.google.com/console) → **Setup** → **API access**
2. Link to a Google Cloud project (or create one)
3. In Google Cloud Console → **IAM & Admin** → **Service Accounts** → **Create Service Account**
4. Give it any name (e.g. `dartdosh-deploy`)
5. Under **Keys** → **Add Key** → **JSON** → download the file
6. Back in Play Console → grant the service account **Release Manager** permissions

### Step 2 — Place the JSON key in your project

```
my_flutter_app/
  dartdosh_config/
    build_config.json
    settings.json
    play_store_key.json   ← place it here
```

> Add `dartdosh_config/play_store_key.json` to your `.gitignore` — never commit credentials.

### Step 3 — Configure `settings.json`

```json
{
  "play_store": {
    "enabled": true,
    "package_name": "com.example.myapp",
    "service_account_json": "dartdosh_config/play_store_key.json"
  }
}
```

### Step 4 — Check track config in `build_config.json`

Generated automatically by `dartdosh init`. Edit tracks as needed:

```json
{
  "play_store": {
    "production":  { "track": "production" },
    "staging":     { "track": "beta" },
    "development": { "track": "internal" }
  }
}
```

Available tracks: `internal`, `alpha`, `beta`, `production`

---

## Usage

```bash
dartdosh build aab -d   # build + upload to internal track
dartdosh build aab -s   # build + upload to beta track
dartdosh build aab -p   # build + upload to production track
```

**Example output:**
```
🚀 Uploading AAB to Google Play (production → production track), Boss...
📤 Uploading AAB to Play Store...
📦 Bundle uploaded (versionCode: 46)
✅ AAB successfully uploaded to Play Store (production track), Boss!
```

---

## Notes

- `package_name` and `service_account_json` go in `settings.json` (personal, git-ignored)
- Track assignments go in `build_config.json` (team-shared, git-tracked)
- Python 3 must be installed; `google-api-python-client` is auto-installed on first run
- Upload only runs for AAB builds (`dartdosh build aab`) — not for APK or IPA

← [Back to docs](../README.en.md)
