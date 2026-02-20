import 'dart:io';
import 'dart:convert';
import '../translation/logger.dart';

/// Manages cleaning of build output files.
class CleanManager {
  Future<void> execute(String target, String? env) async {
    final dartdoshDir = Directory('${Directory.current.path}/dartdosh_config');
    final buildConfigFile = File('${dartdoshDir.path}/build_config.json');
    final settingsFile = File('${dartdoshDir.path}/settings.json');

    if (!dartdoshDir.existsSync() ||
        !buildConfigFile.existsSync() ||
        !settingsFile.existsSync()) {
      Logger.log(LogType.configNotFound);
      return;
    }

    final buildConfig =
        jsonDecode(buildConfigFile.readAsStringSync()) as Map<String, dynamic>;
    final settings =
        jsonDecode(settingsFile.readAsStringSync()) as Map<String, dynamic>;

    final language = settings['language'] as String? ?? 'uz';
    Logger.setLanguage(language);

    String? outputPath = buildConfig['output_path'] as String?;
    if (outputPath == null || outputPath.isEmpty) {
      Logger.log(LogType.cleanOutputPathNotConfigured);
      return;
    }

    if (!outputPath.startsWith('/')) {
      outputPath = '${Directory.current.path}/$outputPath';
    }

    final projectName =
        buildConfig['project_name'] as String? ?? _getProjectName();
    final basePath = '$outputPath/$projectName';

    final displayLabel = target == 'all'
        ? 'all'
        : '$target${env != null ? ' (${_getShortEnvName(env)})' : ''}';
    Logger.log(LogType.cleanStarted, target: displayLabel);

    final filesToDelete = <File>[];

    if (target == 'all') {
      final dir = Directory(basePath);
      if (dir.existsSync()) {
        filesToDelete.addAll(
          dir.listSync(recursive: true).whereType<File>().toList(),
        );
      }
    } else {
      final folder = target == 'aab' ? 'aab' : target;
      final targetDir = Directory('$basePath/$folder');
      if (targetDir.existsSync()) {
        if (env == null) {
          filesToDelete.addAll(
            targetDir.listSync().whereType<File>().toList(),
          );
        } else {
          final prefix = _getShortEnvName(env);
          filesToDelete.addAll(
            targetDir.listSync().whereType<File>().where((f) {
              return f.uri.pathSegments.last.startsWith('${prefix}_');
            }).toList(),
          );
        }
      }
    }

    if (filesToDelete.isEmpty) {
      Logger.log(LogType.cleanNothingToDelete);
      return;
    }

    int totalBytes = 0;
    for (final file in filesToDelete) {
      try {
        totalBytes += file.lengthSync();
      } catch (_) {}
    }

    for (final file in filesToDelete) {
      try {
        file.deleteSync();
      } catch (_) {}
    }

    Logger.log(
      LogType.cleanSuccess,
      file: filesToDelete.length.toString(),
      path: _formatBytes(totalBytes),
    );
  }

  String _getProjectName() {
    try {
      final pubspecFile = File('${Directory.current.path}/pubspec.yaml');
      if (!pubspecFile.existsSync()) return 'my_project';
      for (final line in pubspecFile.readAsLinesSync()) {
        if (line.startsWith('name:')) {
          return line.split(':').last.trim();
        }
      }
      return 'my_project';
    } catch (_) {
      return 'my_project';
    }
  }

  String _getShortEnvName(String env) {
    final e = env.toLowerCase();
    if (e == 'production') return 'prod';
    if (e == 'development') return 'dev';
    if (e == 'staging') return 'stg';
    return e;
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
