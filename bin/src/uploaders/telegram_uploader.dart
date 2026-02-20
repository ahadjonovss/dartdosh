import 'dart:io';
import 'dart:convert';
import '../translation/logger.dart';
import 'telegram_script.dart';

// ---------------------------------------------------------------------------
// dartdosh Telegram app credentials — do NOT share or commit real values here.
// Register your app at https://my.telegram.org → API Development Tools.
// ---------------------------------------------------------------------------
const _kApiId = '31404240';
const _kApiHash = '6a7004c7eb7ab080505938e58e9cf182';
const _kBotToken = '8379287393:AAGx3HF0L7Wd5auMhXZ1slDvxZ9HtOeoc5k';
// ---------------------------------------------------------------------------

/// Handles uploading APK files to Telegram channels via MTProto protocol.
///
/// Uses Python `telethon` library to bypass Telegram Bot API's 50MB limit,
/// allowing APK files up to 2GB to be uploaded directly as documents.
///
/// User configuration:
/// - settings.json  : telegram.enabled (true/false)
/// - build_config.json: `telegram.<env>.chat_id`  (channel/group ID)
///
/// User only needs to add the bot as an admin to their channel.
class TelegramUploader {
  /// Upload [apkPath] to Telegram channel configured for [env].
  ///
  /// Requires Python 3 and `telethon` package to be installed on the machine.
  Future<void> upload(
    String apkPath,
    String? releaseNotes,
    String? env,
  ) async {
    File? tempScript;
    try {
      // No environment → skip silently
      if (env == null) return;

      // --- Read settings.json for enabled flag ---
      final settingsFile =
          File('${Directory.current.path}/dartdosh_config/settings.json');
      final settings =
          jsonDecode(settingsFile.readAsStringSync()) as Map<String, dynamic>;

      final telegramSettings =
          settings['telegram'] as Map<String, dynamic>?;

      // Not configured in settings → skip silently
      if (telegramSettings == null) return;

      final enabled = telegramSettings['enabled'] as bool? ?? false;
      if (!enabled) return;

      // --- Read build_config.json for chat_id ---
      final buildConfigFile =
          File('${Directory.current.path}/dartdosh_config/build_config.json');
      final buildConfig =
          jsonDecode(buildConfigFile.readAsStringSync()) as Map<String, dynamic>;

      final telegramBuildConfig =
          buildConfig['telegram'] as Map<String, dynamic>?;

      if (telegramBuildConfig == null) {
        Logger.log(LogType.uploadProgress,
            progress:
                '⚠️ Telegram upload skipped: No telegram section in build_config.json');
        return;
      }

      final envConfig =
          telegramBuildConfig[env.toLowerCase()] as Map<String, dynamic>?;
      final chatId = envConfig?['chat_id'] as String? ?? '';

      if (chatId.isEmpty) {
        Logger.log(LogType.telegramUploadMissingChatId);
        return;
      }

      // --- Ensure Python 3 is available ---
      final pythonCheck =
          await Process.run('python3', ['--version'], runInShell: true);
      if (pythonCheck.exitCode != 0) {
        Logger.log(LogType.telegramUploadPythonNotFound);
        return;
      }

      // --- Ensure telethon is installed — auto-install if missing ---
      final telethonCheck = await Process.run(
          'python3', ['-c', 'import telethon'],
          runInShell: true);
      if (telethonCheck.exitCode != 0) {
        Logger.log(LogType.uploadProgress,
            progress: '📦 telethon topilmadi, o\'rnatilmoqda...');
        final installResult = await Process.run(
            'pip3', ['install', '--user', 'telethon', '--quiet'],
            runInShell: true);
        if (installResult.exitCode != 0) {
          Logger.log(LogType.telegramUploadTelethonNotFound);
          return;
        }
        Logger.log(LogType.uploadProgress,
            progress: '✅ telethon muvaffaqiyatli o\'rnatildi!');
      }

      // --- Write embedded Python script to temp file ---
      final tempDir = Directory.systemTemp.createTempSync('dartdosh_tg_');
      tempScript = File('${tempDir.path}/telegram_upload.py');
      await tempScript.writeAsString(telegramUploadScript);

      Logger.log(LogType.telegramUploadStarting);

      // Build caption: file name + optional release notes
      final apkFileName = apkPath.split('/').last;
      final caption = releaseNotes != null && releaseNotes.isNotEmpty
          ? '📱 $apkFileName\n\n📝 $releaseNotes'
          : '📱 $apkFileName';

      Logger.log(LogType.uploadProgress, progress: '💬 Chat ID: $chatId');
      if (releaseNotes != null && releaseNotes.isNotEmpty) {
        Logger.log(LogType.uploadProgress,
            progress: '📝 Release Notes: $releaseNotes');
      }

      // --- Run Python script ---
      final process = await Process.start(
        'python3',
        [
          tempScript.path,
          _kApiId,
          _kApiHash,
          _kBotToken,
          chatId,
          apkPath,
          caption,
        ],
        runInShell: true,
      );

      bool uploadSuccess = false;
      int lastLoggedPercent = -1;

      // Parse stdout progress markers
      process.stdout.transform(utf8.decoder).listen((data) {
        for (final line in data.split('\n')) {
          final trimmed = line.trim();
          if (trimmed.isEmpty) continue;

          if (trimmed == 'UPLOAD_STARTED') {
            Logger.log(LogType.uploadProgress,
                progress: '📤 0% - Yuklanmoqda...');
          } else if (trimmed.startsWith('PROGRESS:')) {
            // Format: PROGRESS:current:total:percent
            final parts = trimmed.split(':');
            if (parts.length >= 4) {
              final percent = int.tryParse(parts[3]) ?? 0;
              // Log every 10% to avoid spam
              if (percent >= lastLoggedPercent + 10) {
                lastLoggedPercent = percent - (percent % 10);
                Logger.log(LogType.uploadProgress,
                    progress:
                        '📤 $lastLoggedPercent% - Telegram ga yuklanmoqda...');
              }
            }
          } else if (trimmed == 'UPLOAD_SUCCESS') {
            uploadSuccess = true;
            Logger.log(LogType.uploadProgress, progress: '✅ 100% - Tayyor!');
          }
        }
      });

      // Log stderr (filter out telethon info noise)
      process.stderr.transform(utf8.decoder).listen((data) {
        for (final line in data.split('\n')) {
          final trimmed = line.trim();
          if (trimmed.isNotEmpty &&
              !trimmed.startsWith('INFO') &&
              !trimmed.contains('Generating')) {
            Logger.log(LogType.uploadProgress, progress: '⚠️ $trimmed');
          }
        }
      });

      final exitCode = await process.exitCode;

      if (exitCode == 0 && uploadSuccess) {
        Logger.log(LogType.telegramUploadSuccess);
      } else {
        Logger.log(LogType.telegramUploadFailed);
      }
    } catch (e, stackTrace) {
      Logger.log(LogType.telegramUploadFailed);
      Logger.log(LogType.uploadProgress, progress: '❌ Error: $e');
      Logger.log(LogType.uploadProgress,
          progress:
              '📋 ${stackTrace.toString().split('\n').take(3).join('\n')}');
    } finally {
      // Clean up temp script and its parent dir
      try {
        tempScript?.parent.deleteSync(recursive: true);
      } catch (_) {}
    }
  }
}
