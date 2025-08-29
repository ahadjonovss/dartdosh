import 'dart:io';
import 'dart:convert';
import 'package:args/args.dart';
import 'src/logger.dart';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addFlag('production', abbr: 'p', negatable: false)
    ..addFlag('staging', abbr: 's', negatable: false)
    ..addFlag('development', abbr: 'd', negatable: false);

  ArgResults argResults;
  try {
    argResults = parser.parse(arguments);
  } catch (e) {
    Logger.log(LogType.error, target: 'unknown', env: 'unknown');
    exit(1);
  }

  if (argResults.rest.isEmpty || argResults.rest[0] != 'build') {
    Logger.log(LogType.error, target: 'unknown', env: 'unknown');
    exit(1);
  }

  final target = argResults.rest[1];

  // Environment
  String env = '';
  if (argResults['production'] as bool) env = 'production';
  if (argResults['staging'] as bool) env = 'staging';
  if (argResults['development'] as bool) env = 'development';

  if (env.isEmpty) {
    Logger.log(LogType.error, target: target, env: env);
    exit(1);
  }

  // Start log
  Logger.log(LogType.start, target: target, env: env);

  // Target file check
  final mainFile = File('${Directory.current.path}/lib/main.dart');
  if (!mainFile.existsSync()) {
    Logger.log(LogType.info, file: 'lib/main.dart', target: target, env: env);
  }

  // Step log
  Logger.log(LogType.step, target: target, env: env);

  // Build config check
  final configFile = File('${Directory.current.path}/build_config.json');
  if (!configFile.existsSync()) {
    Logger.log(LogType.buildConfigIsNotExist, target: target, env: env);
    exit(1);
  }

  final config = jsonDecode(configFile.readAsStringSync());
  String cmdString = config[target]?[env] ?? '';

  // Extra flags: 2 tagacha flaglardan keyin kelganlar
  final extraFlags = arguments.length > 3 ? arguments.sublist(3) : [];

  // APK --split flagini --split-per-abi ga aylantirish
  if (target == 'apk' &&
      extraFlags.contains('--split') &&
      !cmdString.contains('--split-per-abi')) {
    cmdString += ' --split-per-abi';
  }

  // Qo‘shimcha flaglarni qo‘shish
  if (extraFlags.isNotEmpty) cmdString += ' ${extraFlags.join(' ')}';

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
    } else {
      Logger.log(LogType.error, target: target, env: env);
    }
  } catch (e) {
    Logger.log(LogType.error, target: target, env: env);
  }

  // Finished log
  Logger.log(LogType.finished, target: target, env: env);
}
