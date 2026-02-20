import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:yaml/yaml.dart';
import '../translation/logger.dart';
import '../uploaders/telegram_uploader.dart';

/// Manages Flutter build operations with automatic version management.
///
/// This class handles the execution of Flutter build commands, automatically
/// increments build numbers, and manages output file naming and placement.
class BuildManager {
  /// Executes a Flutter build for the specified [target] and [env]ironment.
  ///
  /// The [target] can be 'apk', 'ipa', or 'appbundle'.
  /// The [env] specifies the build environment (production, staging, development).
  /// If [env] is null, runs plain Flutter build command without flavor.
  /// Optional [extraFlags] are appended to the build command.
  ///
  /// This method automatically:
  /// - Creates build_config.json if it doesn't exist
  /// - Increments the build number in pubspec.yaml (only if env is specified)
  /// - Renames and moves output files according to configuration
  Future<void> execute(
      String target, String? env, List<String> extraFlags) async {
    // Start time tracking
    final stopwatch = Stopwatch()..start();

    final dartdoshDir = Directory('${Directory.current.path}/dartdosh_config');
    final buildConfigFile = File('${dartdoshDir.path}/build_config.json');
    final settingsFile = File('${dartdoshDir.path}/settings.json');

    // Check if Dartdosh directory and files exist
    if (!dartdoshDir.existsSync() ||
        !buildConfigFile.existsSync() ||
        !settingsFile.existsSync()) {
      Logger.log(LogType.configNotFound);
      return; // Stop execution, tell user to run dartdosh init
    }

    final buildConfig = jsonDecode(buildConfigFile.readAsStringSync());
    final settings = jsonDecode(settingsFile.readAsStringSync());

    // Set language from settings
    final language = settings['language'] as String? ?? 'uz';
    Logger.setLanguage(language);

    // For APK builds, ask for release notes if Firebase or Telegram upload is enabled
    String? releaseNotes;
    if (target == 'apk' && env != null) {
      final firebaseConfig =
          settings['firebase_distribution'] as Map<String, dynamic>?;
      final telegramConfig =
          settings['telegram'] as Map<String, dynamic>?;

      final firebaseEnabled = (firebaseConfig?[env.toLowerCase()]
              as Map<String, dynamic>?)?['enabled'] as bool? ??
          false;
      final telegramEnabled = telegramConfig?['enabled'] as bool? ?? false;

      if (firebaseEnabled || telegramEnabled) {
        stdout.write(
            '📝 Release notes (Firebase/Telegram) (press Enter to skip): ');
        releaseNotes = stdin.readLineSync()?.trim();
      }
    }

    String cmdString = '';

    // If no environment specified, use plain Flutter build command
    if (env == null) {
      cmdString = 'flutter build $target';
    } else {
      cmdString = buildConfig[target]?[env.toLowerCase()] ?? '';

      if (cmdString.isEmpty) {
        Logger.log(LogType.error, target: target, env: env);
        stopwatch.stop();
        return;
      }
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
    // Only increment if environment is specified (flavor builds) and auto_increment is enabled
    final autoIncrement =
        settings['auto_increment_build_number'] as bool? ?? false;
    if (env != null && autoIncrement) {
      _incrementBuildNumber();
    }

    final envDisplay = env ?? 'default';
    Logger.log(LogType.step, target: target, env: envDisplay);
    Logger.log(LogType.running,
        target: target, env: envDisplay, command: cmdString);

    try {
      final parts = cmdString.split(' ');
      final process = Process.start(
        parts[0],
        parts.sublist(1),
        runInShell: true,
        workingDirectory: Directory.current.path,
      );

      final exitCode = await _handleProcessOutput(process, target, envDisplay);

      if (exitCode == 0) {
        Logger.log(LogType.success, target: target, env: envDisplay);
        // Always rename/move files, regardless of environment
        if (env != null) {
          await _renameAndMoveOutputFile(target, env, settings, releaseNotes);
        } else {
          await _renameAndMoveOutputFileNoEnv(target, settings, releaseNotes);
        }

        // Stop stopwatch and show total time
        stopwatch.stop();
        final totalSeconds =
            (stopwatch.elapsedMilliseconds / 1000).toStringAsFixed(1);
        Logger.log(LogType.totalTime, time: totalSeconds);

        // Show donation message at the very end
        Logger.log(LogType.donation);
      } else {
        Logger.log(LogType.error, target: target, env: envDisplay);
        stopwatch.stop();
      }
    } catch (e) {
      Logger.log(LogType.error, target: target, env: envDisplay);
      stopwatch.stop();
    }
  }

  /// Handles process output with progress bar
  Future<int> _handleProcessOutput(
      Future<Process> processFuture, String target, String env) async {
    final process = await processFuture;
    int currentProgress = 0;
    String currentTask = Logger.getProgressTask('starting');
    bool progressBarShown = false;

    // Timer for periodic updates
    final timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (progressBarShown) {
        _showProgress(currentProgress, currentTask, target, env);
      }
    });

    // Listen to stdout
    process.stdout.transform(utf8.decoder).listen((data) {
      progressBarShown = true;

      // Detect build stages with more comprehensive patterns
      final lowerData = data.toLowerCase();

      if (lowerData.contains('running gradle task') ||
          lowerData.contains('gradle task')) {
        currentProgress = 20;
        currentTask = Logger.getProgressTask('gradle');
      } else if (lowerData.contains('resolving dependencies') ||
          lowerData.contains('downloading')) {
        currentProgress = 30;
        currentTask = Logger.getProgressTask('dependencies_downloading');
      } else if (lowerData.contains('got dependencies')) {
        currentProgress = 40;
        currentTask = Logger.getProgressTask('dependencies_ready');
      } else if (lowerData.contains('compiling') ||
          lowerData.contains('compileflutter')) {
        currentProgress = 50;
        currentTask = Logger.getProgressTask('compiling');
      } else if (lowerData.contains('bundling') ||
          lowerData.contains('bundle')) {
        currentProgress = 60;
        currentTask = Logger.getProgressTask('bundling');
      } else if (lowerData.contains('assembling') ||
          lowerData.contains('assemble')) {
        currentProgress = 70;
        currentTask = Logger.getProgressTask('assembling');
      } else if (lowerData.contains('signing') || lowerData.contains('sign')) {
        currentProgress = 80;
        currentTask = Logger.getProgressTask('signing');
      } else if (lowerData.contains('built ') ||
          lowerData.contains('build complete')) {
        currentProgress = 95;
        currentTask = Logger.getProgressTask('finishing');
      }

      // Show warnings and errors
      if (lowerData.contains('warning') ||
          lowerData.contains('error') ||
          lowerData.contains('failed')) {
        stdout.write('\r\x1B[K'); // Clear progress bar
        stdout.write(data); // Show warning/error
      }
    });

    // Listen to stderr
    process.stderr.transform(utf8.decoder).listen((data) {
      stderr.write(data);
    });

    final exitCode = await process.exitCode;
    timer.cancel();

    if (exitCode == 0) {
      _showProgress(100, Logger.getProgressTask('ready'), target, env);
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

    // Clear line and write progress bar
    stdout.write(
        '\r\x1B[K\x1B[36m[$bar] $percentStr%\x1B[0m - \x1B[35m[$target - ${env.toLowerCase()}]\x1B[0m - \x1B[33m$task\x1B[0m');
  }

  // Pubspec.yaml dan project name o'qish
  String _getProjectName() {
    try {
      final pubspecFile = File('${Directory.current.path}/pubspec.yaml');
      if (!pubspecFile.existsSync()) {
        return 'my_project';
      }

      final pubspecContent = loadYaml(pubspecFile.readAsStringSync());
      final name = pubspecContent['name']?.toString() ?? 'my_project';
      return name;
    } catch (e) {
      return 'my_project';
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

  // Get short environment name
  String _getShortEnvName(String env) {
    final envLower = env.toLowerCase();
    if (envLower == 'production') return 'prod';
    if (envLower == 'development') return 'dev';
    if (envLower == 'staging') return 'stg';
    return envLower; // fallback to original if unknown
  }

  // Get target type folder name
  String _getTargetFolderName(String target) {
    if (target == 'appbundle') return 'aab';
    return target; // apk, ipa return as-is
  }

  // Build tugagach fayllarni rename qilib output_path ga ko'chirish
  Future<void> _renameAndMoveOutputFile(String target, String env,
      Map<String, dynamic> config, String? releaseNotes) async {
    try {
      final versionInfo = _getVersionInfo();
      final version = versionInfo['version']!;
      final buildNumber = versionInfo['build']!;

      // Format: shortEnv_version_buildNumber (e.g., prod_1.0.9_2155)
      final shortEnv = _getShortEnvName(env);
      final newName = '${shortEnv}_${version}_$buildNumber';

      // Config dan output_path va project_name olish
      String? outputPath = config['output_path'] as String?;
      final projectName =
          config['project_name'] as String? ?? _getProjectName();

      if (outputPath != null && outputPath.isNotEmpty) {
        // Output path ni to'liq path ga aylantirish
        if (!outputPath.startsWith('/')) {
          outputPath = '${Directory.current.path}/$outputPath';
        }

        // Add project name subfolder and target type subfolder
        final targetFolder = _getTargetFolderName(target);
        outputPath = '$outputPath/$projectName/$targetFolder';

        // Output directory ni yaratish (agar mavjud bo'lmasa)
        final outputDir = Directory(outputPath);
        if (!outputDir.existsSync()) {
          outputDir.createSync(recursive: true);
          Logger.log(LogType.outputDirCreated, path: outputPath);
        }
      }

      if (target == 'apk') {
        final apkPath = _renameAndMoveApk(newName, outputPath, env);
        if (apkPath != null) {
          // Upload APK to Firebase Distribution if enabled
          await _uploadApkToFirebaseIfEnabled(
              apkPath, config, releaseNotes, env);
          // Upload APK to Telegram channel if enabled
          await TelegramUploader().upload(apkPath, releaseNotes, env);
        }
      } else if (target == 'ipa' || target == 'ios') {
        final ipaPath = _renameAndMoveIpa(newName, outputPath);
        // Upload IPA to App Store if enabled
        if (ipaPath != null) {
          await _uploadIpaIfEnabled(ipaPath, config, releaseNotes);
        }
      } else if (target == 'appbundle' || target == 'aab') {
        _renameAndMoveAab(newName, outputPath);
      }
    } catch (e) {
      // Xatolik bo'lsa davom ettirish
    }
  }

  // Environment bo'lmaganda fayllarni rename qilib output_path ga ko'chirish
  Future<void> _renameAndMoveOutputFileNoEnv(
      String target, Map<String, dynamic> config, String? releaseNotes) async {
    try {
      final versionInfo = _getVersionInfo();
      final version = versionInfo['version']!;
      final buildNumber = versionInfo['build']!;

      // Format: target_version_buildNumber (no environment)
      final newName = '${target}_${version}_$buildNumber';

      // Config dan output_path va project_name olish
      String? outputPath = config['output_path'] as String?;
      final projectName =
          config['project_name'] as String? ?? _getProjectName();

      if (outputPath != null && outputPath.isNotEmpty) {
        // Output path ni to'liq path ga aylantirish
        if (!outputPath.startsWith('/')) {
          outputPath = '${Directory.current.path}/$outputPath';
        }

        // Add project name subfolder and target type subfolder
        final targetFolder = _getTargetFolderName(target);
        outputPath = '$outputPath/$projectName/$targetFolder';

        // Output directory ni yaratish (agar mavjud bo'lmasa)
        final outputDir = Directory(outputPath);
        if (!outputDir.existsSync()) {
          outputDir.createSync(recursive: true);
          Logger.log(LogType.outputDirCreated, path: outputPath);
        }
      }

      if (target == 'apk') {
        final apkPath = _renameAndMoveApkNoEnv(newName, outputPath);
        // Upload APK to Firebase Distribution if enabled (skipped for non-env builds)
        if (apkPath != null) {
          await _uploadApkToFirebaseIfEnabled(
              apkPath, config, releaseNotes, null);
        }
      } else if (target == 'ipa' || target == 'ios') {
        final ipaPath = _renameAndMoveIpa(newName, outputPath);
        // Upload IPA to App Store if enabled (same for non-env builds)
        if (ipaPath != null) {
          await _uploadIpaIfEnabled(ipaPath, config, releaseNotes);
        }
      } else if (target == 'appbundle' || target == 'aab') {
        _renameAndMoveAab(newName, outputPath);
      }
    } catch (e) {
      // Xatolik bo'lsa davom ettirish
    }
  }

  // APK rename for builds without environment (plain flutter build)
  String? _renameAndMoveApkNoEnv(String newName, String? outputPath) {
    final apkPaths = [
      'build/app/outputs/flutter-apk/app-release.apk',
      'build/app/outputs/apk/release/app-release.apk',
    ];

    for (final path in apkPaths) {
      final file = File('${Directory.current.path}/$path');
      if (file.existsSync()) {
        final fileName = '$newName.apk';
        String finalPath;

        if (outputPath != null && outputPath.isNotEmpty) {
          final destinationPath = '$outputPath/$fileName';
          file.copySync(destinationPath);
          Logger.log(LogType.fileSaved, path: destinationPath);
          finalPath = destinationPath;
        } else {
          final newPath = '${file.parent.path}/$fileName';
          file.renameSync(newPath);
          Logger.log(LogType.fileSaved, path: fileName);
          finalPath = newPath;
        }
        return finalPath;
      }
    }
    return null;
  }

  String? _renameAndMoveApk(String newName, String? outputPath, String env) {
    // Build environment-specific APK paths based on actual env
    final envLower = env.toLowerCase();
    final List<String> apkPaths = [];

    // Add environment-specific paths first (priority)
    if (envLower == 'production' || envLower == 'prod') {
      apkPaths.addAll([
        'build/app/outputs/flutter-apk/app-prod-release.apk',
        'build/app/outputs/flutter-apk/app-production-release.apk',
        'build/app/outputs/apk/prodRelease/app-prod-release.apk',
        'build/app/outputs/apk/productionRelease/app-production-release.apk',
      ]);
    } else if (envLower == 'development' || envLower == 'dev') {
      apkPaths.addAll([
        'build/app/outputs/flutter-apk/app-dev-release.apk',
        'build/app/outputs/flutter-apk/app-dev-debug.apk',
        'build/app/outputs/flutter-apk/app-development-release.apk',
        'build/app/outputs/flutter-apk/app-development-debug.apk',
        'build/app/outputs/apk/devRelease/app-dev-release.apk',
        'build/app/outputs/apk/devDebug/app-dev-debug.apk',
        'build/app/outputs/apk/developmentRelease/app-development-release.apk',
        'build/app/outputs/apk/developmentDebug/app-development-debug.apk',
      ]);
    } else if (envLower == 'staging' || envLower == 'stg') {
      apkPaths.addAll([
        'build/app/outputs/flutter-apk/app-staging-release.apk',
        'build/app/outputs/flutter-apk/app-stg-release.apk',
        'build/app/outputs/apk/stagingRelease/app-staging-release.apk',
        'build/app/outputs/apk/stgRelease/app-stg-release.apk',
      ]);
    }

    // Fallback to generic release APK
    apkPaths.add('build/app/outputs/flutter-apk/app-release.apk');
    apkPaths.add('build/app/outputs/apk/release/app-release.apk');

    for (final path in apkPaths) {
      final file = File('${Directory.current.path}/$path');
      if (file.existsSync()) {
        final fileName = '$newName.apk';
        String finalPath;

        if (outputPath != null && outputPath.isNotEmpty) {
          // Output path ga ko'chirish
          final destinationPath = '$outputPath/$fileName';
          file.copySync(destinationPath);
          Logger.log(LogType.fileSaved, path: destinationPath);
          finalPath = destinationPath;
        } else {
          // Faqat rename qilish (build papkasida)
          final newPath = '${file.parent.path}/$fileName';
          file.renameSync(newPath);
          Logger.log(LogType.fileSaved, path: fileName);
          finalPath = newPath;
        }
        return finalPath; // Return path for Firebase upload
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

          final newFileName =
              arch.isNotEmpty ? '${newName}_$arch.apk' : '$newName.apk';

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
    return null; // No APK found
  }

  String? _renameAndMoveIpa(String newName, String? outputPath) {
    final dir = Directory('${Directory.current.path}/build/ios/ipa');

    if (dir.existsSync()) {
      final ipaFiles = dir.listSync().where((e) => e.path.endsWith('.ipa'));
      for (final file in ipaFiles) {
        if (file is File) {
          final fileName = '$newName.ipa';
          String finalPath;

          if (outputPath != null && outputPath.isNotEmpty) {
            // Output path ga ko'chirish
            final destinationPath = '$outputPath/$fileName';
            file.copySync(destinationPath);
            Logger.log(LogType.fileSaved, path: destinationPath);
            finalPath = destinationPath;
          } else {
            // Faqat rename qilish
            final newPath = '${file.parent.path}/$fileName';
            file.renameSync(newPath);
            Logger.log(LogType.fileSaved, path: fileName);
            finalPath = newPath;
          }
          return finalPath; // Return path for upload
        }
      }
    }
    return null;
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

  // IPA faylni App Store Connect ga yuklash
  Future<void> _uploadIpaIfEnabled(
      String ipaPath, Map<String, dynamic> config, String? releaseNotes) async {
    try {
      // Config dan ipa_upload sozlamalarini olish
      final ipaUploadConfig = config['ipa_upload'] as Map<String, dynamic>?;

      if (ipaUploadConfig == null) {
        return; // Config yo'q - skip
      }

      final enabled = ipaUploadConfig['enabled'] as bool? ?? false;

      if (!enabled) {
        return; // Upload o'chirilgan
      }

      final appleId = ipaUploadConfig['apple_id'] as String? ?? '';
      final appPassword =
          ipaUploadConfig['app_specific_password'] as String? ?? '';

      // Credentials tekshirish
      if (appleId.isEmpty || appPassword.isEmpty) {
        Logger.log(LogType.uploadCredentialsMissing);
        return;
      }

      Logger.log(LogType.uploadStarting, path: ipaPath);
      final args = [
        'altool',
        '--upload-app',
        '--type',
        'ios',
        '--file',
        ipaPath,
        '--username',
        appleId,
        '--password',
        appPassword,
      ];

      final result = await Process.run(
        'xcrun',
        args,
        runInShell: true,
      );

      // Show upload output using Logger
      final stdout = result.stdout.toString();
      final stderr = result.stderr.toString();

      // Log stdout if not empty
      if (stdout.isNotEmpty) {
        // Split by lines and log each line
        for (final line in stdout.split('\n')) {
          if (line.trim().isNotEmpty) {
            Logger.log(LogType.uploadProgress, progress: line.trim());
          }
        }
      }

      // Log stderr if not empty
      if (stderr.isNotEmpty) {
        for (final line in stderr.split('\n')) {
          if (line.trim().isNotEmpty) {
            Logger.log(LogType.uploadProgress, progress: line.trim());
          }
        }
      }

      if (result.exitCode == 0) {
        Logger.log(LogType.uploadSuccess);
        // Show donation message after successful upload
        Logger.log(LogType.donation);
      } else {
        Logger.log(LogType.uploadFailed);
      }
    } catch (e) {
      Logger.log(LogType.uploadFailed);
      Logger.log(LogType.uploadProgress, progress: 'Xato: $e');
    }
  }

  // APK faylni Firebase App Distribution ga yuklash
  Future<void> _uploadApkToFirebaseIfEnabled(String apkPath,
      Map<String, dynamic> config, String? releaseNotes, String? env) async {
    try {
      // If no environment specified, skip
      if (env == null) {
        Logger.log(LogType.uploadProgress,
            progress: '⚠️ Firebase upload skipped: No environment specified');
        return;
      }

      // Get settings.json to check if Firebase Distribution is enabled for this environment
      final settingsFile =
          File('${Directory.current.path}/dartdosh_config/settings.json');
      final settings = jsonDecode(settingsFile.readAsStringSync());
      final firebaseSettings =
          settings['firebase_distribution'] as Map<String, dynamic>?;

      if (firebaseSettings == null) {
        Logger.log(LogType.uploadProgress,
            progress:
                '⚠️ Firebase upload skipped: No firebase_distribution in settings.json');
        return; // Settings yo'q - skip
      }

      // Get environment-specific enabled setting
      final envSettings =
          firebaseSettings[env.toLowerCase()] as Map<String, dynamic>?;
      final enabled = envSettings?['enabled'] as bool? ?? false;

      if (!enabled) {
        Logger.log(LogType.uploadProgress,
            progress:
                '⚠️ Firebase upload disabled for environment: ${env.toLowerCase()}');
        return; // Upload o'chirilgan bu environment uchun
      }

      // Get build_config.json Firebase Distribution config for app_id and tester_groups
      final buildConfigFile =
          File('${Directory.current.path}/dartdosh_config/build_config.json');
      final buildConfig = jsonDecode(buildConfigFile.readAsStringSync());
      final buildConfigFirebase =
          buildConfig['firebase_distribution'] as Map<String, dynamic>?;

      if (buildConfigFirebase == null) {
        Logger.log(LogType.uploadProgress,
            progress:
                '⚠️ Firebase upload skipped: No firebase_distribution in build_config.json');
        return; // Config yo'q - skip
      }

      // Get environment-specific config (production, staging, development)
      final envConfig =
          buildConfigFirebase[env.toLowerCase()] as Map<String, dynamic>?;

      // If no environment-specific config found, skip
      if (envConfig == null) {
        Logger.log(LogType.uploadProgress,
            progress:
                '⚠️ Firebase upload skipped: No config for environment ${env.toLowerCase()} in build_config.json');
        return;
      }

      final appId = envConfig['app_id'] as String? ?? '';
      final testerGroups = envConfig['tester_groups'] as String? ?? '';

      // App ID tekshirish
      if (appId.isEmpty) {
        Logger.log(LogType.firebaseUploadMissingAppId);
        Logger.log(LogType.uploadProgress,
            progress:
                '⚠️ Environment: $env - App ID is empty in build_config.json');
        return;
      }

      Logger.log(LogType.firebaseUploadStarting);

      // Show release notes if provided
      if (releaseNotes != null && releaseNotes.isNotEmpty) {
        Logger.log(LogType.uploadProgress,
            progress: '📝 Release Notes: $releaseNotes');
      }

      // Show app ID and tester groups
      Logger.log(LogType.uploadProgress, progress: '🎯 App ID: $appId');
      if (testerGroups.isNotEmpty) {
        Logger.log(LogType.uploadProgress,
            progress: '👥 Tester Groups: $testerGroups');
      }

      // firebase appdistribution:distribute command
      final args = [
        'appdistribution:distribute',
        apkPath,
        '--app',
        appId,
      ];

      // Add tester groups if provided
      if (testerGroups.isNotEmpty) {
        args.addAll(['--groups', testerGroups]);
      }

      // Add release notes if provided
      if (releaseNotes != null && releaseNotes.isNotEmpty) {
        args.addAll(['--release-notes', releaseNotes]);
      }

      // Show command being executed
      Logger.log(LogType.uploadProgress,
          progress: '⚙️ Running: firebase ${args.join(' ')}');

      // Start process for real-time progress monitoring
      final process = await Process.start(
        'firebase',
        args,
        runInShell: true,
      );

      int uploadProgress = 0;
      bool uploadComplete = false;

      // Listen to stdout for upload progress
      process.stdout.transform(utf8.decoder).listen((data) {
        final lines = data.split('\n');
        for (final line in lines) {
          if (line.trim().isEmpty) continue;

          // Parse Firebase CLI output for progress indicators
          if (line.contains('Uploading') || line.contains('uploading')) {
            if (uploadProgress < 50) {
              uploadProgress = 50;
              Logger.log(LogType.uploadProgress,
                  progress: '📤 50% - Yuklanmoqda...');
            }
          } else if (line.contains('Processing') ||
              line.contains('processing')) {
            if (uploadProgress < 75) {
              uploadProgress = 75;
              Logger.log(LogType.uploadProgress,
                  progress: '⚙️ 75% - Firebase qayta ishlamoqda...');
            }
          } else if (line.contains('success') || line.contains('Success')) {
            uploadProgress = 100;
            uploadComplete = true;
          }

          // Show Firebase output
          if (line.contains('http') ||
              line.contains('View') ||
              uploadComplete) {
            Logger.log(LogType.uploadProgress, progress: line.trim());
          }
        }
      });

      // Listen to stderr
      process.stderr.transform(utf8.decoder).listen((data) {
        final lines = data.split('\n');
        for (final line in lines) {
          if (line.trim().isNotEmpty) {
            Logger.log(LogType.uploadProgress, progress: '⚠️ ${line.trim()}');
          }
        }
      });

      final exitCode = await process.exitCode;

      if (exitCode == 0) {
        Logger.log(LogType.uploadProgress, progress: '✅ 100% - Tayyor!');
        Logger.log(LogType.firebaseUploadSuccess);
        // Show donation message after successful upload
        Logger.log(LogType.donation);
      } else {
        Logger.log(LogType.firebaseUploadFailed);
      }
    } catch (e, stackTrace) {
      Logger.log(LogType.firebaseUploadFailed);
      Logger.log(LogType.uploadProgress, progress: '❌ Error: $e');
      Logger.log(LogType.uploadProgress,
          progress:
              '📋 Stack trace: ${stackTrace.toString().split('\n').take(3).join('\n')}');
    }
  }
}
