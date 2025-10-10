import 'dart:io';
import 'dart:convert';
import 'package:yaml/yaml.dart';
import 'logger.dart';

class BuildManager {
  void execute(String target, String env, List<String> extraFlags) {
    final configFile = File('${Directory.current.path}/build_config.json');

    if (!configFile.existsSync()) {
      Logger.log(LogType.buildConfigIsNotExist, target: target, env: env);
      return;
    }

    final config = jsonDecode(configFile.readAsStringSync());
    String cmdString = config[target]?[env.toLowerCase()] ?? '';

    if (cmdString.isEmpty) {
      Logger.log(LogType.error, target: target, env: env);
      print('❌ Config topilmadi: $target -> $env');
      return;
    }

    if (target == 'apk' && extraFlags.contains('--split')) {
      extraFlags.remove('--split');
      if (!cmdString.contains('--split-per-abi')) {
        cmdString += ' --split-per-abi';
      }
    }

    if (extraFlags.isNotEmpty) {
      cmdString += ' ${extraFlags.join(' ')}';
    }

    Logger.log(LogType.step, target: target, env: env);
    Logger.log(LogType.running, target: target, env: env, command: cmdString);

    try {
      final parts = cmdString.split(' ');
      final result = Process.runSync(
        parts[0],
        parts.sublist(1),
        runInShell: true,
        workingDirectory: Directory.current.path,
      );

      stdout.write(result.stdout);
      stderr.write(result.stderr);

      if (result.exitCode == 0) {
        Logger.log(LogType.success, target: target, env: env);
        _renameOutputFile(target, env);
      } else {
        Logger.log(LogType.error, target: target, env: env);
      }
    } catch (e) {
      Logger.log(LogType.error, target: target, env: env);
    }
  }

  void _renameOutputFile(String target, String env) {
    try {
      final pubspecFile = File('${Directory.current.path}/pubspec.yaml');
      if (!pubspecFile.existsSync()) return;

      final pubspecContent = loadYaml(pubspecFile.readAsStringSync());
      final versionField = pubspecContent['version']?.toString() ?? '1.0.0+1';
      final versionParts = versionField.split('+');
      final version = versionParts.isNotEmpty ? versionParts[0] : '1.0.0';
      final versionCode = versionParts.length > 1 ? versionParts[1] : '1';

      final flavor = env.toLowerCase();
      // Requested format: flavor+version+version_code
      final newName = '${flavor}_${version}_${versionCode}';

      if (target == 'apk') {
        _renameApk(newName);
      } else if (target == 'ipa' || target == 'ios') {
        _renameIpa(newName);
      } else if (target == 'appbundle' || target == 'aab') {
        _renameAab(newName);
      }
    } catch (e) {
      print('⚠️ Rename failed: $e');
    }
  }

  void _renameApk(String newName) {
    final apkPaths = [
      'build/app/outputs/flutter-apk/app-release.apk',
      'build/app/outputs/apk/release/app-release.apk',
    ];

    for (final path in apkPaths) {
      final file = File('${Directory.current.path}/$path');
      if (file.existsSync()) {
        final newPath = file.parent.path + '/$newName.apk';
        file.renameSync(newPath);
        print('✅ Renamed: $newName.apk');
        return;
      }
    }

    // Split APK uchun
    final splitDir =
        Directory('${Directory.current.path}/build/app/outputs/flutter-apk');
    if (splitDir.existsSync()) {
      final apkFiles =
          splitDir.listSync().where((e) => e.path.endsWith('.apk'));
      for (final file in apkFiles) {
        if (file is File) {
          final fileName = file.path.split('/').last;
          final arch =
              fileName.replaceAll('app-', '').replaceAll('-release.apk', '');
          final newPath = '${file.parent.path}/${newName}_$arch.apk';
          file.renameSync(newPath);
          print('✅ Renamed: ${newName}_$arch.apk');
        }
      }
    }
  }

  void _renameIpa(String newName) {
    final dir = Directory('${Directory.current.path}/build/ios/ipa');

    if (dir.existsSync()) {
      final ipaFiles = dir.listSync().where((e) => e.path.endsWith('.ipa'));
      for (final file in ipaFiles) {
        if (file is File) {
          final newPath = '${file.parent.path}/$newName.ipa';
          file.renameSync(newPath);
          print('✅ Renamed: $newName.ipa');
          return;
        }
      }
    }
  }

  void _renameAab(String newName) {
    final aabPaths = [
      'build/app/outputs/bundle/release/app-release.aab',
    ];

    for (final path in aabPaths) {
      final file = File('${Directory.current.path}/$path');
      if (file.existsSync()) {
        final newPath = file.parent.path + '/$newName.aab';
        file.renameSync(newPath);
        print('✅ Renamed: $newName.aab');
        return;
      }
    }
  }
}
