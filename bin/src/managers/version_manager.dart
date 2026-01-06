import 'dart:convert';
import 'dart:io';
import 'package:yaml/yaml.dart';
import '../translation/logger.dart';

/// Version manager for DartDosh CLI tool
///
/// Handles version checking, upgrades, and downgrades with fun, localized messages
class VersionManager {
  static const String packageName = 'dartdosh';

  /// Get dartdosh package version from its own pubspec.yaml
  static String get currentVersion {
    try {
      // Get the path where dartdosh executable is located
      final scriptPath = Platform.script.toFilePath();

      // Navigate up to find pubspec.yaml
      // Typical structure: /path/to/.pub-cache/global_packages/dartdosh/bin/dartdosh.dart
      var currentDir = Directory(scriptPath).parent;

      // Go up until we find pubspec.yaml
      for (var i = 0; i < 5; i++) {
        final pubspecFile = File('${currentDir.path}/pubspec.yaml');
        if (pubspecFile.existsSync()) {
          final content = loadYaml(pubspecFile.readAsStringSync());
          final version = content['version']?.toString();
          if (version != null && content['name'] == packageName) {
            return version;
          }
        }
        currentDir = currentDir.parent;
      }
    } catch (e) {
      // Fallback to hardcoded version if reading fails
    }
    return '0.7.0'; // Fallback version
  }

  /// Show current version with fun message
  static void showVersion() {
    Logger.log(LogType.versionShow, version: currentVersion);
  }

  /// Check for updates
  static Future<void> checkVersion() async {
    Logger.log(LogType.versionChecking);

    try {
      final result = await Process.run(
        'dart',
        ['pub', 'outdated', '--json'],
        runInShell: true,
      );

      if (result.exitCode == 0) {
        final json = jsonDecode(result.stdout as String);
        final packages = json['packages'] as List;

        final dartdoshPackage = packages.firstWhere(
          (p) => p['package'] == packageName,
          orElse: () => null,
        );

        if (dartdoshPackage != null) {
          final latest = dartdoshPackage['latest']['version'] as String?;

          if (latest != null && latest != currentVersion) {
            Logger.log(LogType.versionUpdateAvailable, latest: latest);
            Logger.log(LogType.versionCurrentInfo, version: currentVersion);
            Logger.log(LogType.versionUpgradeHint);
          } else {
            Logger.log(LogType.versionUpToDate);
          }
        }
      }
    } catch (e) {
      Logger.log(LogType.versionServerError);
    }
  }

  /// Upgrade to latest version
  static Future<void> upgrade() async {
    final oldVersion = currentVersion;

    Logger.log(LogType.versionUpgrading);

    try {
      final result = await Process.run(
        'pub',
        ['global', 'activate', packageName],
        runInShell: true,
      );

      if (result.exitCode == 0) {
        // Parse new version from output
        final output = result.stdout.toString();
        final versionMatch =
            RegExp(r'Activated dartdosh (\d+\.\d+\.\d+)').firstMatch(output);
        final newVersion = versionMatch?.group(1) ?? 'latest';

        Logger.log(LogType.versionUpgradeSuccess,
            oldVersion: oldVersion, newVersion: newVersion);
      } else {
        _printUpgradeError();
      }
    } catch (e) {
      _printUpgradeError();
    }
  }

  /// Downgrade to specific version or previous version
  static Future<void> downgrade([String? version]) async {
    final oldVersion = currentVersion;

    if (version != null) {
      Logger.log(LogType.versionDowngrading, version: version);
    } else {
      Logger.log(LogType.versionDowngradingPrevious);
    }

    try {
      final args = version != null
          ? ['pub', 'global', 'activate', packageName, version]
          : [
              'pub',
              'global',
              'activate',
              packageName,
              '0.4.1'
            ]; // Previous version

      final result = await Process.run('dart', args, runInShell: true);

      if (result.exitCode == 0) {
        // Parse new version from output
        final output = result.stdout.toString();
        final versionMatch =
            RegExp(r'Activated dartdosh (\d+\.\d+\.\d+)').firstMatch(output);
        final newVersion = versionMatch?.group(1) ?? (version ?? 'previous');

        Logger.log(LogType.versionDowngradeSuccess,
            oldVersion: oldVersion, newVersion: newVersion);
      } else {
        _printDowngradeError();
      }
    } catch (e) {
      _printDowngradeError();
    }
  }

  static void _printUpgradeError() {
    Logger.log(LogType.versionUpgradeFailed);
  }

  static void _printDowngradeError() {
    Logger.log(LogType.versionDowngradeFailed);
  }
}
