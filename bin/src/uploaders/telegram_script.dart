/// Embedded Python script for Telegram MTProto upload via telethon.
///
/// This script is written to a temp file at runtime and deleted after use.
/// It uses telethon's MTProto protocol to bypass the 50MB Bot API limit,
/// allowing APK files up to 2GB to be uploaded directly to Telegram channels.
const String telegramUploadScript = r'''
import sys
import asyncio
from telethon import TelegramClient


async def upload(api_id, api_hash, bot_token, chat_id, file_path, caption):
    client = TelegramClient("dartdosh_tg_session", int(api_id), api_hash)
    await client.start(bot_token=bot_token)
    try:
        print("UPLOAD_STARTED", flush=True)

        def progress_callback(current, total):
            percent = int((current / total) * 100) if total > 0 else 0
            print(f"PROGRESS:{current}:{total}:{percent}", flush=True)

        await client.send_file(
            int(chat_id),
            file_path,
            caption=caption,
            force_document=True,
            progress_callback=progress_callback,
        )
        print("UPLOAD_SUCCESS", flush=True)
    except Exception as e:
        print(f"UPLOAD_ERROR:{e}", file=sys.stderr, flush=True)
        sys.exit(1)
    finally:
        await client.disconnect()


if __name__ == "__main__":
    if len(sys.argv) < 6:
        print("Usage: script.py <api_id> <api_hash> <bot_token> <chat_id> <file_path> [caption]",
              file=sys.stderr)
        sys.exit(1)

    _api_id = sys.argv[1]
    _api_hash = sys.argv[2]
    _bot_token = sys.argv[3]
    _chat_id = sys.argv[4]
    _file_path = sys.argv[5]
    _caption = sys.argv[6] if len(sys.argv) > 6 else ""

    asyncio.run(upload(_api_id, _api_hash, _bot_token, _chat_id, _file_path, _caption))
''';
