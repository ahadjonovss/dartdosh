import 'dart:io';
import 'dart:convert';
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

    if (target == 'apk' && extraFlags.contains('--split')) {
      cmdString += ' --split-per-abi';
    }

    if (extraFlags.isNotEmpty) cmdString += ' ' + extraFlags.join(' ');

    Logger.log(LogType.step, target: target, env: env);
    print('Ishga tushirilmoqda: $cmdString');

    try {
      final parts = cmdString.split(' ');
      final result = Process.runSync(parts[0], parts.sublist(1),
          runInShell: true, workingDirectory: Directory.current.path);

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
  }
}
