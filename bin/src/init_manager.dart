import 'dart:io';
import 'dart:convert';
import 'package:yaml/yaml.dart';
import 'logger.dart';

/// Manages initialization and migration of dartdosh configuration files
class InitManager {
  final dartdoshDir = Directory('${Directory.current.path}/dartdosh_config');
  final buildConfigFile = File('${Directory.current.path}/dartdosh_config/build_config.json');
  final settingsFile = File('${Directory.current.path}/dartdosh_config/settings.json');
  final oldConfigFile = File('${Directory.current.path}/build_config.json');

  /// Initialize dartdosh configuration
  Future<void> initialize() async {
    Logger.log(LogType.initStarted);

    // Check if old config exists (migration scenario)
    if (oldConfigFile.existsSync()) {
      await _migrateFromOldConfig();
      return;
    }

    // Check if new config already exists
    if (dartdoshDir.existsSync() && buildConfigFile.existsSync() && settingsFile.existsSync()) {
      await _validateExistingConfig();
      return;
    }

    // Create new config from scratch
    await _createNewConfig();
  }

  /// Migrate from old build_config.json to new structure
  Future<void> _migrateFromOldConfig() async {
    Logger.log(LogType.migrationStarted);

    try {
      final oldConfig = jsonDecode(oldConfigFile.readAsStringSync());

      // Create directory if it doesn't exist
      if (!dartdoshDir.existsSync()) {
        dartdoshDir.createSync(recursive: true);
      }

      // Extract build configs (team shared)
      final buildConfig = {
        "apk": oldConfig['apk'] ?? _getDefaultBuildConfig('apk'),
        "ipa": oldConfig['ipa'] ?? _getDefaultBuildConfig('ipa'),
        "appbundle": oldConfig['appbundle'] ?? _getDefaultBuildConfig('appbundle'),
      };

      // Extract user settings (user specific)
      final userSettings = {
        "language": oldConfig['language'] ?? 'uz',
        "project_name": oldConfig['project_name'] ?? _getProjectName(),
        "auto_increment_build_number": oldConfig['auto_increment_build_number'] ?? false,
        "output_path": oldConfig['output_path'] ?? _getDefaultOutputPath(),
        "ipa_upload": oldConfig['ipa_upload'] ?? {
          "enabled": false,
          "apple_id": "",
          "app_specific_password": ""
        },
        "firebase_distribution": oldConfig['firebase_distribution'] ?? {
          "enabled": false,
          "app_id": "",
          "tester_groups": ""
        }
      };

      // Set language for logs
      Logger.setLanguage(userSettings['language'] as String);

      // Write files
      const encoder = JsonEncoder.withIndent('  ');
      await buildConfigFile.writeAsString(encoder.convert(buildConfig), flush: true);
      await settingsFile.writeAsString(encoder.convert(userSettings), flush: true);

      // Add to .gitignore
      await _addToGitignore('dartdosh_config/settings.json');

      Logger.log(LogType.migrationCompleted);
      Logger.log(LogType.initCompleted);
    } catch (e) {
      Logger.log(LogType.migrationFailed);
    }
  }

  /// Validate existing config and add missing fields
  Future<void> _validateExistingConfig() async {
    try {
      final buildConfig = jsonDecode(buildConfigFile.readAsStringSync());
      final userSettings = jsonDecode(settingsFile.readAsStringSync());

      // Set language for logs
      Logger.setLanguage(userSettings['language'] as String? ?? 'uz');

      bool buildConfigModified = false;
      bool userSettingsModified = false;
      List<String> missingFields = [];

      // Check build config
      final requiredBuildTargets = ['apk', 'ipa', 'appbundle'];
      for (final target in requiredBuildTargets) {
        if (!buildConfig.containsKey(target)) {
          buildConfig[target] = _getDefaultBuildConfig(target);
          buildConfigModified = true;
          missingFields.add('build_config.$target');
        }
      }

      // Check user settings
      final requiredUserFields = {
        'language': 'uz',
        'project_name': _getProjectName(),
        'auto_increment_build_number': false,
        'output_path': _getDefaultOutputPath(),
        'ipa_upload': {
          "enabled": false,
          "apple_id": "",
          "app_specific_password": ""
        },
        'firebase_distribution': {
          "enabled": false,
          "app_id": "",
          "tester_groups": ""
        }
      };

      requiredUserFields.forEach((key, defaultValue) {
        if (!userSettings.containsKey(key)) {
          userSettings[key] = defaultValue;
          userSettingsModified = true;
          missingFields.add('user_settings.$key');
        } else if (defaultValue is Map) {
          // Check nested fields for Map values
          final currentValue = userSettings[key];
          if (currentValue is Map) {
            bool nestedModified = false;
            defaultValue.forEach((nestedKey, nestedDefaultValue) {
              if (!currentValue.containsKey(nestedKey)) {
                currentValue[nestedKey] = nestedDefaultValue;
                nestedModified = true;
                missingFields.add('user_settings.$key.$nestedKey');
              }
            });
            if (nestedModified) {
              userSettingsModified = true;
            }
          }
        }
      });

      // Save changes if modified
      if (buildConfigModified || userSettingsModified) {
        const encoder = JsonEncoder.withIndent('  ');

        if (buildConfigModified) {
          await buildConfigFile.writeAsString(encoder.convert(buildConfig), flush: true);
        }

        if (userSettingsModified) {
          await settingsFile.writeAsString(encoder.convert(userSettings), flush: true);
        }

        // Report missing fields
        for (final field in missingFields) {
          Logger.log(LogType.missingFieldAdded, field: field);
        }

        Logger.log(LogType.initCompleted);
      } else {
        // Everything is already configured
        Logger.log(LogType.alreadyConfigured);
      }
    } catch (e) {
      Logger.log(LogType.configValidationFailed);
    }
  }

  /// Create new configuration from scratch
  Future<void> _createNewConfig() async {
    try {
      // Create directory
      if (!dartdoshDir.existsSync()) {
        dartdoshDir.createSync(recursive: true);
      }

      final projectName = _getProjectName();
      final outputPath = _getDefaultOutputPath();

      // Build config (team shared)
      final buildConfig = {
        "apk": _getDefaultBuildConfig('apk'),
        "ipa": _getDefaultBuildConfig('ipa'),
        "appbundle": _getDefaultBuildConfig('appbundle'),
      };

      // User settings (user specific)
      final userSettings = {
        "language": "uz",
        "project_name": projectName,
        "auto_increment_build_number": false,
        "output_path": outputPath,
        "ipa_upload": {
          "enabled": false,
          "apple_id": "",
          "app_specific_password": ""
        },
        "firebase_distribution": {
          "enabled": false,
          "app_id": "",
          "tester_groups": ""
        }
      };

      // Write files
      const encoder = JsonEncoder.withIndent('  ');
      await buildConfigFile.writeAsString(encoder.convert(buildConfig), flush: true);
      await settingsFile.writeAsString(encoder.convert(userSettings), flush: true);

      // Add to .gitignore
      await _addToGitignore('dartdosh_config/settings.json');

      Logger.log(LogType.configCreated);
      Logger.log(LogType.initCompleted);
    } catch (e) {
      Logger.log(LogType.configCreationFailed);
    }
  }

  /// Get default build config for target
  Map<String, String> _getDefaultBuildConfig(String target) {
    return {
      "production": "flutter build $target --release --flavor production",
      "staging": "flutter build $target --release --flavor staging",
      "development": "flutter build $target --debug --flavor development"
    };
  }

  /// Get project name from pubspec.yaml
  String _getProjectName() {
    try {
      final pubspecFile = File('${Directory.current.path}/pubspec.yaml');
      if (pubspecFile.existsSync()) {
        final pubspec = loadYaml(pubspecFile.readAsStringSync());
        return pubspec['name']?.toString() ?? 'my_app';
      }
    } catch (e) {
      // Ignore
    }
    return 'my_app';
  }

  /// Get default output path
  String _getDefaultOutputPath() {
    final home = Platform.environment['HOME'] ??
        Platform.environment['USERPROFILE'] ??
        Directory.current.path;
    return '$home/Desktop/dartdosh-builds';
  }

  /// Add entry to .gitignore if it doesn't exist
  Future<void> _addToGitignore(String entry) async {
    final gitignoreFile = File('${Directory.current.path}/.gitignore');

    try {
      // Create .gitignore if it doesn't exist
      if (!gitignoreFile.existsSync()) {
        await gitignoreFile.writeAsString('$entry\n');
        return;
      }

      // Read existing content
      final content = await gitignoreFile.readAsString();

      // Check if entry already exists
      if (content.contains(entry)) {
        return;
      }

      // Append entry
      await gitignoreFile.writeAsString('$content\n$entry\n');
    } catch (e) {
      // Silent error - not critical
    }
  }
}
