import 'build_manager.dart';

/// Command-line interface handler for DartDosh build commands.
///
/// This class processes command-line arguments and delegates build operations
/// to the [BuildManager].
class CLI {
  /// Runs the CLI with the provided [arguments].
  ///
  /// Expects arguments in the format: `build <target> --<environment> [flags]`
  /// where target can be `apk`, `ipa`, or `appbundle`.
  ///
  /// Throws an [Exception] if the command format is invalid.
  void run(List<String> arguments) {
    if (arguments.isEmpty || arguments[0] != 'build') {
      throw Exception('Invalid command');
    }

    final target = arguments[1];
    final env = parseEnv(arguments);

    // Extract extra flags, excluding environment flags
    final List<String> extraFlags = arguments.length > 2
        ? arguments.sublist(2).where((arg) =>
            arg != '--production' && arg != '-p' &&
            arg != '--staging' && arg != '-s' &&
            arg != '--development' && arg != '-d'
          ).toList()
        : [];

    BuildManager().execute(target, env, extraFlags);
  }

  /// Parses the environment from command-line arguments.
  ///
  /// Recognizes `--production` or `-p`, `--staging` or `-s`,
  /// and `--development` or `-d` flags.
  ///
  /// Returns the environment name or 'unknown' if not recognized.
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
