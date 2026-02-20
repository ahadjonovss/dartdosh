import '../managers/build_manager.dart';
import '../managers/version_manager.dart';
import '../managers/init_manager.dart';
import '../managers/clean_manager.dart';

/// Command-line interface handler for DartDosh commands.
///
/// This class processes command-line arguments and delegates operations
/// to the appropriate managers.
class CLI {
  /// Runs the CLI with the provided [arguments].
  ///
  /// Supports commands:
  /// - `init` - Initialize dartdosh configuration
  /// - `build <target> [--<environment>] [flags]` - Build Flutter app
  /// - `--version` or `-v` - Show current version
  /// - `--check-version` - Check for updates
  /// - `upgrade` - Upgrade to latest version
  /// - `downgrade [version]` - Downgrade to specific or previous version
  ///
  /// Throws an [Exception] if the command format is invalid.
  Future<void> run(List<String> arguments) async {
    if (arguments.isEmpty) {
      throw Exception('Invalid command');
    }

    // Handle init command
    if (arguments[0] == 'init') {
      await InitManager().initialize();
      return;
    }

    // Handle version commands
    if (arguments[0] == '--version' || arguments[0] == '-v') {
      VersionManager.showVersion();
      return;
    }

    if (arguments[0] == '--check-version') {
      await VersionManager.checkVersion();
      return;
    }

    if (arguments[0] == 'upgrade') {
      await VersionManager.upgrade();
      return;
    }

    if (arguments[0] == 'downgrade') {
      final version = arguments.length > 1 ? arguments[1] : null;
      await VersionManager.downgrade(version);
      return;
    }

    // Handle clean command
    if (arguments[0] == 'clean') {
      final target = arguments.length > 1 ? arguments[1] : 'all';
      final env = parseEnv(arguments);
      await CleanManager().execute(target, env);
      return;
    }

    // Handle build command
    if (arguments[0] != 'build') {
      throw Exception('Invalid command');
    }

    // Normalize target: 'aab' -> 'appbundle'
    var target = arguments[1];
    if (target == 'aab') {
      target = 'appbundle';
    }

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
  /// Returns the environment name or null if not specified.
  static String? parseEnv(List<String> args) {
    if (args.contains('--production') ||
        args.contains('-p') ||
        args.contains('-prod')) {
      return 'production';
    }
    if (args.contains('--staging') || args.contains('-s')) {
      return 'staging';
    }
    if (args.contains('--development') ||
        args.contains('-d') ||
        args.contains('-dev')) {
      return 'development';
    }
    return null; // No environment specified - use plain Flutter command
  }
}
