import 'dart:io';
import 'dart:convert';
import 'package:args/args.dart';

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print(
        'Usage: dartdosh build <target> [--production|--staging|--development] [other flags]');
    exit(0);
  }

  final parser = ArgParser()
    ..addFlag('production', abbr: 'p', negatable: false)
    ..addFlag('staging', abbr: 's', negatable: false)
    ..addFlag('development', abbr: 'd', negatable: false);

  ArgResults argResults;
  try {
    argResults = parser.parse(arguments);
  } catch (e) {
    print('Invalid arguments: $e');
    exit(1);
  }

  if (argResults.rest.length < 2 || argResults.rest[0] != 'build') {
    print(
        'Usage: dartdosh build <target> [--production|--staging|--development] [other flags]');
    exit(1);
  }

  final target = argResults.rest[1]; // ios / android / apk
  String env = '';
  if (argResults['production'] as bool) env = 'production';
  if (argResults['staging'] as bool) env = 'staging';
  if (argResults['development'] as bool) env = 'development';

  if (env.isEmpty) {
    print(
        'Please specify environment: --production, --staging, or --development');
    exit(1);
  }

  final configFile = File('build_config.json');
  if (!configFile.existsSync()) {
    print('build_config.json not found!');
    exit(1);
  }

  final config = jsonDecode(configFile.readAsStringSync());

  if (!config.containsKey(target)) {
    print('Invalid target: $target');
    exit(1);
  }

  String cmdString = config[target][env];
  if (cmdString == null) {
    print('No command found for $target $env');
    exit(1);
  }

  // Terminaldan kelgan qo'shimcha flaglar (3-va undan keyingi argumentlar)
  final extraFlags = arguments.length > 2 ? arguments.sublist(2) : [];

  // Agar original build android/apk bo'lsa va --split kelgan bo'lsa
  if (target == 'apk' &&
      extraFlags.contains('--split') &&
      !cmdString.contains('--split-per-abi')) {
    cmdString += ' --split-per-abi';
  }

  // Boshqa barcha qo'shimcha flaglarni qo'shish
  if (extraFlags.isNotEmpty) {
    cmdString += ' ' + extraFlags.join(' ');
  }

  print('Running: $cmdString');

  final parts = cmdString.split(' ');

  try {
    final result =
        Process.runSync(parts[0], parts.sublist(1), runInShell: true);
    stdout.write(result.stdout);
    stderr.write(result.stderr);
    print('Build finished.');
  } catch (e) {
    print('Error running command: $e');
    exit(1);
  }
}
