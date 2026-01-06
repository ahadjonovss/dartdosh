import 'dart:math';
import 'translation_loader.dart';

enum LogType {
  start,
  info,
  step,
  success,
  error,
  finished,
  buildConfigIsNotExist,
  buildConfigCreated,
  running,
  donation,
  buildNumberIncremented,
  fileSaved,
  outputDirCreated,
  uploadStarting,
  uploadProgress,
  uploadSuccess,
  uploadFailed,
  uploadCredentialsMissing,
  totalTime,
  // Init command logs
  initStarted,
  configCreated,
  configValidationFailed,
  configCreationFailed,
  migrationStarted,
  migrationCompleted,
  migrationFailed,
  missingFieldAdded,
  alreadyConfigured,
  initCompleted,
  configNotFound,
  // Version manager logs
  versionShow,
  versionChecking,
  versionUpdateAvailable,
  versionCurrentInfo,
  versionUpgradeHint,
  versionUpToDate,
  versionServerError,
  versionUpgrading,
  versionUpgradeSuccess,
  versionUpgradeFailed,
  versionDowngrading,
  versionDowngradingPrevious,
  versionDowngradeSuccess,
  versionDowngradeFailed,
  // Firebase distribution logs
  firebaseUploadMissingAppId,
  firebaseUploadStarting,
  firebaseUploadSuccess,
  firebaseUploadFailed,
}

class Logger {
  static final _random = Random();
  static String _currentLanguage = 'uz';
  static Map<String, dynamic>? _translations;

  static void setLanguage(String language) {
    if (['uz', 'en', 'ru', 'tr'].contains(language)) {
      _currentLanguage = language;
      _translations = TranslationLoader.load(language);
    } else {
      // Unsupported language - fallback to English with warning
      _currentLanguage = 'en';
      _translations = TranslationLoader.load('en');
      print(
          '\x1B[33m⚠️  Warning: Language "$language" is not supported. Falling back to English.\x1B[0m');
      print(
          '\x1B[33m   Supported languages: uz (Uzbek), en (English), ru (Russian), tr (Turkish)\x1B[0m\n');
    }
  }

  /// Returns localized progress task message
  static String getProgressTask(String taskKey) {
    _translations ??= TranslationLoader.load(_currentLanguage);

    final tasks = _translations?['progress_tasks'] as Map<String, dynamic>?;
    return tasks?[taskKey] as String? ?? taskKey;
  }

  /// Convert LogType enum to snake_case string key
  static String _logTypeToKey(LogType type) {
    final name = type.toString().split('.').last;

    // Convert camelCase to snake_case
    return name
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => '_${match.group(0)!.toLowerCase()}',
        )
        .replaceFirst(RegExp(r'^_'), '');
  }

  static void log(
    LogType type, {
    String target = '',
    String env = '',
    String file = '',
    String command = '',
    String oldBuild = '',
    String newBuild = '',
    String path = '',
    String progress = '',
    String time = '',
    String field = '',
    String version = '',
    String latest = '',
    String oldVersion = '',
    String newVersion = '',
  }) {
    // Load translations if not already loaded
    _translations ??= TranslationLoader.load(_currentLanguage);

    // Convert LogType enum to snake_case key
    final logKey = _logTypeToKey(type);

    // Get variants from translations
    final variants = TranslationLoader.getVariants(_currentLanguage, logKey);

    if (variants == null || variants.isEmpty) {
      // Fallback message
      print('⚠️  [Missing translation: $logKey]');
      return;
    }

    // Random variant selection
    var message = variants[_random.nextInt(variants.length)];

    // Replace all placeholders
    message = message
        .replaceAll('{target}', target)
        .replaceAll('{env}', env)
        .replaceAll('{file}', file)
        .replaceAll('{command}', command)
        .replaceAll('{oldBuild}', oldBuild)
        .replaceAll('{newBuild}', newBuild)
        .replaceAll('{path}', path)
        .replaceAll('{progress}', progress)
        .replaceAll('{time}', time)
        .replaceAll('{field}', field)
        .replaceAll('{version}', version)
        .replaceAll('{latest}', latest)
        .replaceAll('{oldVersion}', oldVersion)
        .replaceAll('{newVersion}', newVersion);

    // Apply color based on LogType
    final colorCode = _getColorCode(type);
    final coloredMessage = '\x1B[${colorCode}m$message\x1B[0m';

    print(coloredMessage);
  }

  /// Get ANSI color code for LogType
  static String _getColorCode(LogType type) {
    switch (type) {
      // Blue (34)
      case LogType.start:
      case LogType.initStarted:
      case LogType.migrationStarted:
        return '34';

      // Cyan (36)
      case LogType.step:
      case LogType.versionShow:
        return '36';

      // Green (32)
      case LogType.success:
      case LogType.buildNumberIncremented:
      case LogType.fileSaved:
      case LogType.outputDirCreated:
      case LogType.uploadSuccess:
      case LogType.totalTime:
      case LogType.configCreated:
      case LogType.migrationCompleted:
      case LogType.alreadyConfigured:
      case LogType.initCompleted:
      case LogType.missingFieldAdded:
      case LogType.versionUpgradeSuccess:
      case LogType.versionDowngradeSuccess:
      case LogType.versionUpToDate:
      case LogType.firebaseUploadSuccess:
        return '32';

      // Red (31)
      case LogType.error:
      case LogType.uploadFailed:
      case LogType.migrationFailed:
      case LogType.configValidationFailed:
      case LogType.configCreationFailed:
      case LogType.configNotFound:
      case LogType.versionUpgradeFailed:
      case LogType.versionDowngradeFailed:
      case LogType.versionServerError:
      case LogType.firebaseUploadFailed:
        return '31';

      // Magenta (35)
      case LogType.donation:
        return '35';

      // Yellow (33)
      case LogType.info:
      case LogType.finished:
      case LogType.buildConfigIsNotExist:
      case LogType.buildConfigCreated:
      case LogType.running:
      case LogType.uploadStarting:
      case LogType.uploadProgress:
      case LogType.uploadCredentialsMissing:
      case LogType.versionChecking:
      case LogType.versionUpdateAvailable:
      case LogType.versionCurrentInfo:
      case LogType.versionUpgradeHint:
      case LogType.versionUpgrading:
      case LogType.versionDowngrading:
      case LogType.versionDowngradingPrevious:
      case LogType.firebaseUploadMissingAppId:
      case LogType.firebaseUploadStarting:
        return '33';
    }
  }
}
