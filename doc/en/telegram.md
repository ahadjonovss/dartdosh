# Telegram Channel Upload

← [Back to docs](../README.en.md)

---

DartDosh can send your APK directly to a Telegram channel after each build. It uses the **MTProto protocol** — so there's no 50MB Bot API limit. Files up to **2GB** are supported.

## Prerequisites

- **Python 3** installed on your machine
- `telethon` library — **auto-installed on first run**, nothing to do manually

---

## Setup

### Step 1 — Create or use an existing Telegram channel

### Step 2 — Add the dartdosh bot as Admin

Add **[@dartdosh_manager_bot](https://t.me/dartdosh_manager_bot)** to your channel and give it **Admin** permissions so it can post files.

### Step 3 — Get your channel's Chat ID

1. Forward any message from your channel to [@userinfobot](https://t.me/userinfobot)
2. The bot replies with your channel's ID

The ID is a negative number, for example: `-1001234567890`

### Step 4 — Add Chat ID to `build_config.json`

```json
{
  "telegram": {
    "production":  { "chat_id": "-1001234567890" },
    "staging":     { "chat_id": "-1002222222222" },
    "development": { "chat_id": "" }
  }
}
```

### Step 5 — Enable in `settings.json`

```json
{
  "telegram": {
    "enabled": true
  }
}
```

### Step 6 — Build and upload

```bash
dartdosh build apk -p
```

DartDosh builds the APK, then sends it to the configured channel with a real-time progress bar.

**Example output:**
```
✅ apk build completed successfully, Boss!
✅ Build saved: ~/Desktop/dartdosh-builds/my_app/apk/prod_1.0.0_100.apk
✈️ Uploading APK to Telegram channel, Boss...
📤 0% - Uploading...
📤 30% - Uploading to Telegram...
📤 70% - Uploading to Telegram...
📤 100% - Done!
✅ APK successfully sent to Telegram channel, Boss!
```

---

## Release notes

When Telegram upload is enabled, DartDosh asks for optional release notes before the build:

```
Enter release notes (optional, press Enter to skip):
> Fixed login crash, updated dependencies
```

The release notes are sent as the file caption in Telegram.

---

## Notes

- `telethon` is auto-installed via `pip3 install --user telethon` on first use
- The upload uses dartdosh's own bot — users only need to provide the `chat_id`
- Set `"enabled": false` to disable upload while keeping the chat IDs configured
