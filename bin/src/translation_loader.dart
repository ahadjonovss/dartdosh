import 'dart:convert';
import 'dart:io';
import 'embedded_translations.dart';

/// Loads and manages translation files for dartdosh CLI
///
/// Supports loading from JSON files with in-memory caching and fallback
/// to embedded translations if files are not found.
class TranslationLoader {
  static final Map<String, Map<String, dynamic>> _cache = {};
  static const List<String> supportedLanguages = ['uz', 'en', 'ru'];

  /// Load translation file for given language
  ///
  /// Returns a map containing log_types and progress_tasks.
  /// Uses caching for performance.
  /// Falls back to embedded translations if file not found.
  static Map<String, dynamic> load(String language) {
    // Check cache first
    if (_cache.containsKey(language)) {
      return _cache[language]!;
    }

    try {
      // Try to load from JSON file
      final file = _getTranslationFile(language);
      if (file.existsSync()) {
        final content = file.readAsStringSync();
        final json = jsonDecode(content) as Map<String, dynamic>;

        // Validate structure
        if (validateStructure(json)) {
          _cache[language] = json;
          return json;
        } else {
          stderr.writeln(
              '⚠️  Warning: Translation file $language.json has invalid structure');
        }
      }
    } catch (e) {
      // Log error but continue with fallback
      stderr.writeln('⚠️  Could not load translation file for $language: $e');
    }

    // Fallback to embedded translations
    final embedded = getEmbeddedTranslations(language);
    _cache[language] = embedded;
    return embedded;
  }

  /// Get translation file path
  ///
  /// Looks for translations directory relative to the executable
  static File _getTranslationFile(String language) {
    // Get the path where dartdosh executable is located
    final scriptPath = Platform.script.toFilePath();
    var currentDir = Directory(scriptPath).parent;

    // Navigate up to find translations folder
    for (var i = 0; i < 5; i++) {
      final translationsDir = Directory('${currentDir.path}/translations');
      if (translationsDir.existsSync()) {
        return File('${translationsDir.path}/$language.json');
      }
      currentDir = currentDir.parent;
    }

    // If not found, try current directory
    return File('translations/$language.json');
  }

  /// Validate translation JSON structure
  ///
  /// Checks for required fields: version, language, log_types, progress_tasks
  static bool validateStructure(Map<String, dynamic> json) {
    if (!json.containsKey('version')) return false;
    if (!json.containsKey('language')) return false;
    if (!json.containsKey('log_types')) return false;
    if (!json.containsKey('progress_tasks')) return false;

    // Validate log_types structure
    final logTypes = json['log_types'];
    if (logTypes is! Map) return false;

    // Validate progress_tasks structure
    final progressTasks = json['progress_tasks'];
    if (progressTasks is! Map) return false;

    return true;
  }

  /// Get embedded translations as fallback
  ///
  /// Returns hardcoded translations if JSON files are not available
  static Map<String, dynamic> getEmbeddedTranslations(String language) {
    try {
      final jsonString = embeddedTranslations[language];
      if (jsonString != null) {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      }
    } catch (e) {
      stderr
          .writeln('⚠️  Error parsing embedded translations for $language: $e');
    }

    // Last resort fallback - return empty structure
    return {
      'version': '1.0.0',
      'language': language,
      'log_types': <String, dynamic>{},
      'progress_tasks': <String, String>{},
    };
  }

  /// Clear cache (useful for testing)
  static void clearCache() {
    _cache.clear();
  }

  /// Get translation variant
  ///
  /// Returns a specific variant from log_types, with fallback chain:
  /// 1. Try requested language
  /// 2. Fall back to English
  /// 3. Return error message if not found
  static List<String>? getVariants(
    String language,
    String logTypeKey,
  ) {
    final translations = load(language);
    final logTypes = translations['log_types'] as Map<String, dynamic>?;

    if (logTypes == null) {
      return null;
    }

    final logType = logTypes[logTypeKey] as Map<String, dynamic>?;
    if (logType == null || !logType.containsKey('variants')) {
      // Try English fallback
      if (language != 'en') {
        return getVariants('en', logTypeKey);
      }
      return null;
    }

    final variants = logType['variants'] as List?;
    return variants?.cast<String>();
  }

  /// Get progress task translation
  ///
  /// Returns translated progress task message
  static String? getProgressTask(String language, String taskKey) {
    final translations = load(language);
    final progressTasks =
        translations['progress_tasks'] as Map<String, dynamic>?;

    if (progressTasks == null) {
      return null;
    }

    final task = progressTasks[taskKey] as String?;
    if (task == null && language != 'en') {
      // Try English fallback
      return getProgressTask('en', taskKey);
    }

    return task;
  }
}
