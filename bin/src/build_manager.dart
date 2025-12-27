import 'dart:io';
import 'dart:convert';
import 'dart:async';
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
  Future<void> execute(String target, String env, List<String> extraFlags) async {
    final configFile = File('${Directory.current.path}/build_config.json');

    if (!configFile.existsSync()) {
      _createDefaultConfig(configFile);
    }

    final config = jsonDecode(configFile.readAsStringSync());
    String cmdString = config[target]?[env.toLowerCase()] ?? '';

    if (cmdString.isEmpty) {
      Logger.log(LogType.error, target: target, env: env);
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
      final process = Process.start(
        parts[0],
        parts.sublist(1),
        runInShell: true,
        workingDirectory: Directory.current.path,
      );

      final exitCode = await _handleProcessOutput(process, target, env);

      if (exitCode == 0) {
        Logger.log(LogType.success, target: target, env: env);
        _renameAndMoveOutputFile(target, env, config);
        Logger.log(LogType.donation);
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

    Logger.log(LogType.buildConfigIsNotExist);

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

    Logger.log(LogType.fileSaved, path: configFile.path);
    Logger.log(LogType.outputDirCreated, path: desktopPath);
  }

  /// Handles process output with progress bar
  Future<int> _handleProcessOutput(Future<Process> processFuture, String target, String env) async {
    final process = await processFuture;
    int currentProgress = 0;
    String currentTask = 'Boshlanyapti...';

    // Timer for periodic updates
    final timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _showProgress(currentProgress, currentTask, target, env);
    });

    // Listen to stdout
    process.stdout.transform(utf8.decoder).listen((data) {
      stdout.write(data);

      // Detect build stages
      if (data.contains('Running Gradle task')) {
        currentProgress = 20;
        currentTask = 'Gradle ishlayapti...';
      } else if (data.contains('Downloading') || data.contains('download')) {
        currentProgress = 30;
        currentTask = 'Fayllar yuklanmoqda...';
      } else if (data.contains('Compiling') || data.contains('compileFlutter')) {
        currentProgress = 50;
        currentTask = 'Flutter kodi kompilyatsiya qilinyapti...';
      } else if (data.contains('Gradle task') && data.contains('assemble')) {
        currentProgress = 70;
        currentTask = 'APK/AAB yig\'ilmoqda...';
      } else if (data.contains('Built ')) {
        currentProgress = 95;
        currentTask = 'Tugallanmoqda...';
      }
    });

    // Listen to stderr
    process.stderr.transform(utf8.decoder).listen((data) {
      stderr.write(data);
    });

    final exitCode = await process.exitCode;
    timer.cancel();

    if (exitCode == 0) {
      _showProgress(100, 'Tayyor!', target, env);
      stdout.write('\n\n');
    } else {
      stdout.write('\n\n');
    }

    return exitCode;
  }

  /// Shows progress bar with task info
  void _showProgress(int percent, String task, String target, String env) {
    final barLength = 30;
    final filled = (barLength * percent / 100).round();
    final empty = barLength - filled;

    final bar = '█' * filled + '░' * empty;
    final percentStr = percent.toString().padLeft(3);

    // Clear previous line and move cursor up, then write new progress
    stdout.write('\r'); // Move cursor to start
    stdout.write('\x1B[K'); // Clear from cursor to end of line
    stdout.write('\x1B[36m[$bar] $percentStr%\x1B[0m - \x1B[35m[$target - ${env.toLowerCase()}]\x1B[0m - \x1B[33m$task\x1B[0m');
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
      return {'version': '1.0.0', 'build': '1'};
    }
  }

  // Build number ni +1 qilish
  void _incrementBuildNumber() {
    try {
      final pubspecFile = File('${Directory.current.path}/pubspec.yaml');
      if (!pubspecFile.existsSync()) {
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
      Logger.log(LogType.buildNumberIncremented,
          oldBuild: currentBuild.toString(), newBuild: newBuild.toString());
    } catch (e) {
      // Xatolik bo'lsa, davom ettirish
    }
  }

  // Build tugagach fayllarni rename qilib output_path ga ko'chirish
  void _renameAndMoveOutputFile(
      String target, String env, Map<String, dynamic> config) {
    try {
      final versionInfo = _getVersionInfo();
      final version = versionInfo['version']!;
      final buildNumber = versionInfo['build']!;

      // Format: target_env_version_buildNumber
      final newName = '${target}_${env.toLowerCase()}_${version}_$buildNumber';

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
          Logger.log(LogType.outputDirCreated, path: outputPath);
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
      // Xatolik bo'lsa davom ettirish
    }
  }

  void _renameAndMoveApk(String newName, String? outputPath) {
    final apkPaths = [
      'build/app/outputs/flutter-apk/app-production-release.apk',
      'build/app/outputs/flutter-apk/app-staging-release.apk',
      'build/app/outputs/flutter-apk/app-development-debug.apk',
      'build/app/outputs/flutter-apk/app-release.apk',
      'build/app/outputs/apk/productionRelease/app-production-release.apk',
      'build/app/outputs/apk/stagingRelease/app-staging-release.apk',
      'build/app/outputs/apk/developmentDebug/app-development-debug.apk',
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
          Logger.log(LogType.fileSaved, path: destinationPath);
        } else {
          // Faqat rename qilish (build papkasida)
          final newPath = '${file.parent.path}/$fileName';
          file.renameSync(newPath);
          Logger.log(LogType.fileSaved, path: fileName);
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
          // Extract only architecture from filename
          String arch = '';
          if (fileName.contains('armeabi-v7a')) {
            arch = 'armeabi-v7a';
          } else if (fileName.contains('arm64-v8a')) {
            arch = 'arm64-v8a';
          } else if (fileName.contains('x86_64')) {
            arch = 'x86_64';
          } else if (fileName.contains('x86')) {
            arch = 'x86';
          }

          final newFileName = arch.isNotEmpty ? '${newName}_$arch.apk' : '$newName.apk';

          if (outputPath != null && outputPath.isNotEmpty) {
            // Output path ga ko'chirish
            final destinationPath = '$outputPath/$newFileName';
            file.copySync(destinationPath);
            Logger.log(LogType.fileSaved, path: destinationPath);
          } else {
            // Faqat rename qilish
            final newPath = '${file.parent.path}/$newFileName';
            file.renameSync(newPath);
            Logger.log(LogType.fileSaved, path: newFileName);
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
            Logger.log(LogType.fileSaved, path: destinationPath);
          } else {
            // Faqat rename qilish
            final newPath = '${file.parent.path}/$fileName';
            file.renameSync(newPath);
            Logger.log(LogType.fileSaved, path: fileName);
          }
          return;
        }
      }
    }
  }

  void _renameAndMoveAab(String newName, String? outputPath) {
    final aabPaths = [
      'build/app/outputs/bundle/productionRelease/app-production-release.aab',
      'build/app/outputs/bundle/stagingRelease/app-staging-release.aab',
      'build/app/outputs/bundle/developmentDebug/app-development-debug.aab',
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
          Logger.log(LogType.fileSaved, path: destinationPath);
        } else {
          // Faqat rename qilish
          final newPath = '${file.parent.path}/$fileName';
          file.renameSync(newPath);
          Logger.log(LogType.fileSaved, path: fileName);
        }
        return;
      }
    }
  }
}
