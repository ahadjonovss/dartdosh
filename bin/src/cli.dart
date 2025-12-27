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
  Future<void> run(List<String> arguments) async {
    if (arguments.isEmpty || arguments[0] != 'build') {
      throw Exception('Invalid command');
    }

    final target = arguments[1];
    final env = parseEnv(arguments);

    // Extract extra flags, excluding environment flags
    final List<String> extraFlags = arguments.length > 2
        ? arguments
            .sublist(2)
            .where((arg) =>
                arg != '--production' &&
                arg != '-p' &&
                arg != '-prod' &&
                arg != '--staging' &&
                arg != '-s' &&
                arg != '--development' &&
                arg != '-d' &&
                arg != '-dev')
            .toList()
        : [];

    await BuildManager().execute(target, env, extraFlags);
  }

  /// Parses the environment from command-line arguments.
  ///
  /// Recognizes production flags: `--production`, `-p`, `-prod`
  /// Recognizes staging flags: `--staging`, `-s`
  /// Recognizes development flags: `--development`, `-d`, `-dev`
  ///
  /// Returns the environment name or 'unknown' if not recognized.
  static String parseEnv(List<String> args) {
    if (args.contains('--production') ||
        args.contains('-p') ||
        args.contains('-prod')) {
      return 'Production';
    }
    if (args.contains('--staging') || args.contains('-s')) {
      return 'Staging';
    }
    if (args.contains('--development') ||
        args.contains('-d') ||
        args.contains('-dev')) {
      return 'Development';
    }
    return 'unknown';
  }
}
