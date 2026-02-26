import 'dart:io';
import 'dart:convert';
import '../translation/logger.dart';
import 'play_store_script.dart';

/// Handles uploading AAB files to Google Play Store via Android Publisher API.
///
/// Uses Python `google-api-python-client` library (auto-installed if missing).
///
/// User configuration:
/// - build_config.json : `play_store.<env>.track`  (internal/beta/production)
/// - settings.json     : `play_store.enabled`, `play_store.package_name`,
///                       `play_store.service_account_json`
class PlayStoreUploader {
  /// Upload [aabPath] to Google Play Store track configured for [env].
  Future<void> upload(String aabPath, String? env) async {
    File? tempScript;
    try {
      if (env == null) return;

      // --- Read settings.json ---
      final settingsFile =
          File('${Directory.current.path}/dartdosh_config/settings.json');
      final settings =
          jsonDecode(settingsFile.readAsStringSync()) as Map<String, dynamic>;

      final playSettings =
          settings['play_store'] as Map<String, dynamic>?;
      if (playSettings == null) return;

      final enabled = playSettings['enabled'] as bool? ?? false;
      if (!enabled) return;

      final packageName = playSettings['package_name'] as String? ?? '';
      if (packageName.isEmpty) {
        Logger.log(LogType.playStoreUploadMissingConfig);
        return;
      }

      String serviceAccountJson =
          playSettings['service_account_json'] as String? ?? '';
      if (serviceAccountJson.isEmpty) {
        Logger.log(LogType.playStoreUploadMissingConfig);
        return;
      }

      // Resolve relative path
      if (!serviceAccountJson.startsWith('/')) {
        serviceAccountJson =
            '${Directory.current.path}/$serviceAccountJson';
      }

      if (!File(serviceAccountJson).existsSync()) {
        Logger.log(LogType.playStoreUploadMissingConfig);
        Logger.log(LogType.uploadProgress,
            progress: '❌ Service account JSON not found: $serviceAccountJson');
        return;
      }

      // --- Read build_config.json for track ---
      final buildConfigFile =
          File('${Directory.current.path}/dartdosh_config/build_config.json');
      final buildConfig =
          jsonDecode(buildConfigFile.readAsStringSync()) as Map<String, dynamic>;

      final playBuildConfig =
          buildConfig['play_store'] as Map<String, dynamic>?;
      if (playBuildConfig == null) {
        Logger.log(LogType.playStoreUploadMissingConfig);
        return;
      }

      final envConfig =
          playBuildConfig[env.toLowerCase()] as Map<String, dynamic>?;
      final track = envConfig?['track'] as String? ?? '';
      if (track.isEmpty) {
        Logger.log(LogType.playStoreUploadMissingConfig);
        return;
      }

      // --- Ensure Python 3 is available ---
      final pythonCheck =
          await Process.run('python3', ['--version'], runInShell: true);
      if (pythonCheck.exitCode != 0) {
        Logger.log(LogType.uploadProgress,
            progress: '❌ Python 3 not found! Install Python 3 first.');
        return;
      }

      // --- Write embedded Python script to temp file ---
      final tempDir = Directory.systemTemp.createTempSync('dartdosh_ps_');
      tempScript = File('${tempDir.path}/play_store_upload.py');
      await tempScript.writeAsString(playStoreUploadScript);

      Logger.log(LogType.playStoreUploadStarting, env: env, target: track);

      // --- Run Python script ---
      final process = await Process.start(
        'python3',
        [tempScript.path, packageName, serviceAccountJson, aabPath, track],
        runInShell: true,
      );

      bool uploadSuccess = false;

      process.stdout.transform(utf8.decoder).listen((data) {
        for (final line in data.split('\n')) {
          final trimmed = line.trim();
          if (trimmed.isEmpty) continue;

          if (trimmed == 'INSTALLING_DEPS') {
            Logger.log(LogType.uploadProgress,
                progress:
                    '📦 Installing google-api-python-client...');
          } else if (trimmed == 'DEPS_INSTALLED') {
            Logger.log(LogType.uploadProgress,
                progress: '✅ Python packages installed!');
          } else if (trimmed == 'DEPS_FAILED') {
            Logger.log(LogType.uploadProgress,
                progress:
                    '❌ Failed to install dependencies. Run: pip install google-api-python-client google-auth');
          } else if (trimmed == 'UPLOAD_STARTED') {
            Logger.log(LogType.uploadProgress,
                progress: '📤 Uploading AAB to Play Store...');
          } else if (trimmed.startsWith('BUNDLE_UPLOADED:')) {
            final versionCode = trimmed.split(':').last;
            Logger.log(LogType.uploadProgress,
                progress: '📦 Bundle uploaded (versionCode: $versionCode)');
          } else if (trimmed == 'UPLOAD_SUCCESS') {
            uploadSuccess = true;
          }
        }
      });

      process.stderr.transform(utf8.decoder).listen((data) {
        for (final line in data.split('\n')) {
          final trimmed = line.trim();
          if (trimmed.isNotEmpty &&
              !trimmed.startsWith('WARNING') &&
              !trimmed.contains('urllib3')) {
            Logger.log(LogType.uploadProgress, progress: '⚠️ $trimmed');
          }
        }
      });

      final exitCode = await process.exitCode;

      if (exitCode == 0 && uploadSuccess) {
        Logger.log(LogType.playStoreUploadSuccess, env: env, target: track);
      } else {
        Logger.log(LogType.playStoreUploadFailed);
      }
    } catch (e) {
      Logger.log(LogType.playStoreUploadFailed);
      Logger.log(LogType.uploadProgress, progress: '❌ Error: $e');
    } finally {
      try {
        tempScript?.parent.deleteSync(recursive: true);
      } catch (_) {}
    }
  }
}
