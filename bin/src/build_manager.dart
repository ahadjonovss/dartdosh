import 'dart:io';
import 'dart:convert';
import 'package:yaml/yaml.dart';
import 'logger.dart';

/// Manages Flutter build operations with automatic version management.
///
/// This class handles the execution of Flutter build commands, automatically
/// increments build numbers, and manages output file naming and placement.
class BuildManager {
  /// Executes a Flutter build for the specified [target] and [env]ironment.
  ///
  /// The [target] can be 'apk', 'ipa', or 'appbundle'.
  /// The [env] specifies the build environment (production, staging, development).
  /// Optional [extraFlags] are appended to the build command.
  ///
  /// This method automatically:
  /// - Creates build_config.json if it doesn't exist
  /// - Increments the build number in pubspec.yaml
  /// - Renames and moves output files according to configuration
  void execute(String target, String env, List<String> extraFlags) {
    final configFile = File('${Directory.current.path}/build_config.json');

    if (!configFile.existsSync()) {
      _createDefaultConfig(configFile);
    }

    final config = jsonDecode(configFile.readAsStringSync());
    String cmdString = config[target]?[env.toLowerCase()] ?? '';

    if (cmdString.isEmpty) {
      Logger.log(LogType.error, target: target, env: env);
      print('❌ Config topilmadi: $target -> $env');
      return;
    }

    // Handle --split flag based on target
    if (extraFlags.contains('--split')) {
      extraFlags.remove('--split');

      // Only apply split for APK builds
      if (target == 'apk' && !cmdString.contains('--split-per-abi')) {
        cmdString += ' --split-per-abi';
      }
      // For IPA and AppBundle, --split is ignored (iOS doesn't support it)
    }

    if (extraFlags.isNotEmpty) {
      cmdString += ' ${extraFlags.join(' ')}';
    }

    // Build boshlashdan oldin pubspec.yaml da build number oshirish
    _incrementBuildNumber();

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
        _renameAndMoveOutputFile(target, env, config);
      } else {
        Logger.log(LogType.error, target: target, env: env);
      }
    } catch (e) {
      Logger.log(LogType.error, target: target, env: env);
    }
  }

  // Default config yaratish
  void _createDefaultConfig(File configFile) {
    // Get Desktop path cross-platform
    final home = Platform.environment['HOME'] ??
        Platform.environment['USERPROFILE'] ??
        Directory.current.path;
    final desktopPath = '$home/Desktop/dartdosh-builds';

    print('\n🔍 build_config.json topilmadi...');
    print('📝 Default konfiguratsiya yaratilmoqda, Xo\'jayiin!\n');

    final defaultConfig = {
      "output_path": desktopPath,
      "apk": {
        "production": "flutter build apk --release --flavor production",
        "staging": "flutter build apk --release --flavor staging",
        "development": "flutter build apk --debug --flavor development"
      },
      "ipa": {
        "production": "flutter build ipa --release --flavor production",
        "staging": "flutter build ipa --release --flavor staging"
      },
      "appbundle": {
        "production": "flutter build appbundle --release --flavor production",
        "staging": "flutter build appbundle --release --flavor staging",
        "development": "flutter build appbundle --debug --flavor development"
      }
    };

    const encoder = JsonEncoder.withIndent('  ');
    final prettyJson = encoder.convert(defaultConfig);
    configFile.writeAsStringSync(prettyJson);

    print('✅ build_config.json muvaffaqiyatli yaratildi, Xo\'jayiin!');
    print('📁 Joylashuv: ${configFile.path}');
    print('📂 Output papka: $desktopPath');
    print('\n💡 Xo\'jayiin, default configlarni yaratdim, tekshirib ko\'ring!\n');

    // Open config file in default editor
    _openConfigFile(configFile.path);
  }

  /// Opens the config file in the user's default editor
  void _openConfigFile(String filePath) {
    try {
      final String command;

      if (Platform.isMacOS) {
        command = 'open';
      } else if (Platform.isLinux) {
        command = 'xdg-open';
      } else if (Platform.isWindows) {
        command = 'start';
      } else {
        print(
            '⚠️  Faylni avtomatik ochib bo\'lmadi. Qo\'lda oching: $filePath');
        return;
      }

      Process.runSync(
        command,
        [filePath],
        runInShell: true,
      );

      print('📝 Config fayl ochildi!\n');
    } catch (e) {
      print('⚠️  Faylni ochishda xatolik: $e');
      print('📝 Faylni qo\'lda oching: $filePath\n');
    }
  }

  // Pubspec.yaml dan version va build number o'qish
  Map<String, String> _getVersionInfo() {
    try {
      final pubspecFile = File('${Directory.current.path}/pubspec.yaml');
      if (!pubspecFile.existsSync()) {
        return {'version': '1.0.0', 'build': '1'};
      }

      final pubspecContent = loadYaml(pubspecFile.readAsStringSync());
      final versionField = pubspecContent['version']?.toString() ?? '1.0.0+1';
      final versionParts = versionField.split('+');
      final version = versionParts.isNotEmpty ? versionParts[0] : '1.0.0';
      final build = versionParts.length > 1 ? versionParts[1] : '1';

      return {'version': version, 'build': build};
    } catch (e) {
      print('⚠️ Version ma\'lumotini o\'qishda xatolik: $e');
      return {'version': '1.0.0', 'build': '1'};
    }
  }

  // Build number ni +1 qilish
  void _incrementBuildNumber() {
    try {
      final pubspecFile = File('${Directory.current.path}/pubspec.yaml');
      if (!pubspecFile.existsSync()) {
        print('⚠️ pubspec.yaml topilmadi');
        return;
      }

      final content = pubspecFile.readAsStringSync();
      final pubspecContent = loadYaml(content);
      final versionField = pubspecContent['version']?.toString() ?? '1.0.0+1';
      final versionParts = versionField.split('+');
      final version = versionParts.isNotEmpty ? versionParts[0] : '1.0.0';
      final currentBuild =
          versionParts.length > 1 ? int.tryParse(versionParts[1]) ?? 1 : 1;
      final newBuild = currentBuild + 1;

      // Yangi version stringini yaratish
      final newVersion = '$version+$newBuild';

      // Faylni yangilash (regex bilan version qatorini topib almashtirish)
      final updatedContent = content.replaceFirst(
        RegExp(r'^version:\s*.*$', multiLine: true),
        'version: $newVersion',
      );

      pubspecFile.writeAsStringSync(updatedContent);
      print('✅ Build number yangilandi: $currentBuild → $newBuild');
    } catch (e) {
      print('⚠️ Build number yangilashda xatolik: $e');
    }
  }

  // Build tugagach fayllarni rename qilib output_path ga ko'chirish
  void _renameAndMoveOutputFile(
      String target, String env, Map<String, dynamic> config) {
    try {
      final versionInfo = _getVersionInfo();
      final version = versionInfo['version']!;
      final buildNumber = versionInfo['build']!;

      final flavor = env.toLowerCase();
      // Format: flavor_version_buildNumber
      final newName = '${flavor}_${version}_$buildNumber';

      // Config dan output_path olish
      String? outputPath = config['output_path'] as String?;

      if (outputPath != null && outputPath.isNotEmpty) {
        // Output path ni to'liq path ga aylantirish
        if (!outputPath.startsWith('/')) {
          outputPath = '${Directory.current.path}/$outputPath';
        }

        // Output directory ni yaratish (agar mavjud bo'lmasa)
        final outputDir = Directory(outputPath);
        if (!outputDir.existsSync()) {
          outputDir.createSync(recursive: true);
          print('📁 Output directory yaratildi: $outputPath');
        }
      }

      if (target == 'apk') {
        _renameAndMoveApk(newName, outputPath);
      } else if (target == 'ipa' || target == 'ios') {
        _renameAndMoveIpa(newName, outputPath);
      } else if (target == 'appbundle' || target == 'aab') {
        _renameAndMoveAab(newName, outputPath);
      }
    } catch (e) {
      print('⚠️ Rename va ko\'chirish xatosi: $e');
    }
  }

  void _renameAndMoveApk(String newName, String? outputPath) {
    final apkPaths = [
      'build/app/outputs/flutter-apk/app-release.apk',
      'build/app/outputs/apk/release/app-release.apk',
    ];

    for (final path in apkPaths) {
      final file = File('${Directory.current.path}/$path');
      if (file.existsSync()) {
        final fileName = '$newName.apk';

        if (outputPath != null && outputPath.isNotEmpty) {
          // Output path ga ko'chirish
          final destinationPath = '$outputPath/$fileName';
          file.copySync(destinationPath);
          print('✅ Build saqlandi: $destinationPath');
        } else {
          // Faqat rename qilish (build papkasida)
          final newPath = '${file.parent.path}/$fileName';
          file.renameSync(newPath);
          print('✅ Renamed: $fileName');
        }
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
          final newFileName = '${newName}_$arch.apk';

          if (outputPath != null && outputPath.isNotEmpty) {
            // Output path ga ko'chirish
            final destinationPath = '$outputPath/$newFileName';
            file.copySync(destinationPath);
            print('✅ Build saqlandi: $destinationPath');
          } else {
            // Faqat rename qilish
            final newPath = '${file.parent.path}/$newFileName';
            file.renameSync(newPath);
            print('✅ Renamed: $newFileName');
          }
        }
      }
    }
  }

  void _renameAndMoveIpa(String newName, String? outputPath) {
    final dir = Directory('${Directory.current.path}/build/ios/ipa');

    if (dir.existsSync()) {
      final ipaFiles = dir.listSync().where((e) => e.path.endsWith('.ipa'));
      for (final file in ipaFiles) {
        if (file is File) {
          final fileName = '$newName.ipa';

          if (outputPath != null && outputPath.isNotEmpty) {
            // Output path ga ko'chirish
            final destinationPath = '$outputPath/$fileName';
            file.copySync(destinationPath);
            print('✅ Build saqlandi: $destinationPath');
          } else {
            // Faqat rename qilish
            final newPath = '${file.parent.path}/$fileName';
            file.renameSync(newPath);
            print('✅ Renamed: $fileName');
          }
          return;
        }
      }
    }
  }

  void _renameAndMoveAab(String newName, String? outputPath) {
    final aabPaths = [
      'build/app/outputs/bundle/release/app-release.aab',
    ];

    for (final path in aabPaths) {
      final file = File('${Directory.current.path}/$path');
      if (file.existsSync()) {
        final fileName = '$newName.aab';

        if (outputPath != null && outputPath.isNotEmpty) {
          // Output path ga ko'chirish
          final destinationPath = '$outputPath/$fileName';
          file.copySync(destinationPath);
          print('✅ Build saqlandi: $destinationPath');
        } else {
          // Faqat rename qilish
          final newPath = '${file.parent.path}/$fileName';
          file.renameSync(newPath);
          print('✅ Renamed: $fileName');
        }
        return;
      }
    }
  }
}
