import 'src/cli.dart';

/// Entry point for the DartDosh CLI application.
Future<void> main(List<String> arguments) async {
  try {
    await CLI().run(arguments);
  } catch (e) {
    print('❌ Xatolik: $e');
  }
}
