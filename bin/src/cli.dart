import 'build_manager.dart';

class CLI {
  void run(List<String> arguments) {
    if (arguments.isEmpty || arguments[0] != 'build') {
      throw Exception('Invalid command');
    }

    final target = arguments[1];
    final env = parseEnv(arguments);
    final List<String> extraFlags =
        arguments.length > 2 ? arguments.sublist(2) : [];

    BuildManager().execute(target, env, extraFlags);
  }

  static String parseEnv(List<String> args) {
    if (args.contains('--production') || args.contains('-p')) {
      return 'Production';
    }
    if (args.contains('--staging') || args.contains('-s')) {
      return 'Staging';
    }
    if (args.contains('--development') || args.contains('-d')) {
      return 'Development';
    }
    return 'unknown';
  }
}
