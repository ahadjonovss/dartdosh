import 'src/cli.dart';

/// Entry point for the DartDosh CLI application.
void main(List<String> arguments) {
  try {
    CLI().run(arguments);
  } catch (e) {
    print('❌ Xatolik: $e');
  }
}
