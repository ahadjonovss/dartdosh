import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:yaml/yaml.dart';

/// Version manager for DartDosh CLI tool
///
/// Handles version checking, upgrades, and downgrades with fun, localized messages
class VersionManager {
  static const String packageName = 'dartdosh';

  static final _random = Random();
  static String _language = 'uz';

  static void setLanguage(String language) {
    if (['uz', 'en', 'ru'].contains(language)) {
      _language = language;
    }
  }

  /// Get dartdosh package version from its own pubspec.yaml
  static String get currentVersion {
    try {
      // Get the path where dartdosh executable is located
      final scriptPath = Platform.script.toFilePath();

      // Navigate up to find pubspec.yaml
      // Typical structure: /path/to/.pub-cache/global_packages/dartdosh/bin/dartdosh.dart
      var currentDir = Directory(scriptPath).parent;

      // Go up until we find pubspec.yaml
      for (var i = 0; i < 5; i++) {
        final pubspecFile = File('${currentDir.path}/pubspec.yaml');
        if (pubspecFile.existsSync()) {
          final content = loadYaml(pubspecFile.readAsStringSync());
          final version = content['version']?.toString();
          if (version != null && content['name'] == packageName) {
            return version;
          }
        }
        currentDir = currentDir.parent;
      }
    } catch (e) {
      // Fallback to hardcoded version if reading fails
    }
    return '0.5.10'; // Fallback version
  }

  /// Show current version with fun message
  static void showVersion() {
    final messages = {
      'uz': [
        '🎯 Sizdahoz DartDosh $currentVersion versiya ekan, Xo\'jayiin!',
        '✨ $currentVersion versiya ishlamoqda, Xo\'jayiin!',
        '🚀 DartDosh $currentVersion - ajoyib versiya, Xo\'jayiin!',
      ],
      'en': [
        '🎯 You have DartDosh version $currentVersion, Boss!',
        '✨ Version $currentVersion is running, Boss!',
        '🚀 DartDosh $currentVersion - awesome version, Boss!',
      ],
      'ru': [
        '🎯 У вас DartDosh версия $currentVersion, Босс!',
        '✨ Версия $currentVersion работает, Босс!',
        '🚀 DartDosh $currentVersion - отличная версия, Босс!',
      ],
    };

    final langMessages = messages[_language] ?? messages['en']!;
    print(_color(langMessages[_random.nextInt(langMessages.length)], '36'));
  }

  /// Check for updates
  static Future<void> checkVersion() async {
    final checking = {
      'uz': [
        '🔍 Yangilanishlar tekshirilmoqda, Xo\'jayiin...',
        '📡 Serverga ulanmoqda, Xo\'jayiin...',
        '🔎 Update bor yo\'qligini ko\'raylik, Xo\'jayiin...',
      ],
      'en': [
        '🔍 Checking for updates, Boss...',
        '📡 Connecting to server, Boss...',
        '🔎 Let\'s see if there\'s an update, Boss...',
      ],
      'ru': [
        '🔍 Проверка обновлений, Босс...',
        '📡 Подключение к серверу, Босс...',
        '🔎 Посмотрим, есть ли обновление, Босс...',
      ],
    };

    print(_color(
        checking[_language]![_random.nextInt(checking[_language]!.length)],
        '33'));

    try {
      final result = await Process.run(
        'dart',
        ['pub', 'outdated', '--json'],
        runInShell: true,
      );

      if (result.exitCode == 0) {
        final json = jsonDecode(result.stdout as String);
        final packages = json['packages'] as List;

        final dartdoshPackage = packages.firstWhere(
          (p) => p['package'] == packageName,
          orElse: () => null,
        );

        if (dartdoshPackage != null) {
          final latest = dartdoshPackage['latest']['version'] as String?;

          if (latest != null && latest != currentVersion) {
            final updateAvailable = {
              'uz': [
                '🎉 Xo\'jayiin, hozir $latest versiya chiqibti!',
                '✨ Yangi $latest versiya bor ekan, Xo\'jayiin!',
                '🚀 Ajoyib! $latest versiya tayyor, Xo\'jayiin!',
              ],
              'en': [
                '🎉 Boss, version $latest is out now!',
                '✨ New version $latest available, Boss!',
                '🚀 Great! Version $latest is ready, Boss!',
              ],
              'ru': [
                '🎉 Босс, вышла версия $latest!',
                '✨ Новая версия $latest доступна, Босс!',
                '🚀 Отлично! Версия $latest готова, Босс!',
              ],
            };

            final currentInfo = {
              'uz': '📦 Sizda hozir $currentVersion versiya bor',
              'en': '📦 You currently have version $currentVersion',
              'ru': '📦 Сейчас у вас версия $currentVersion',
            };

            final upgradeHint = {
              'uz':
                  '💡 Yangilash uchun mana bu commandni yozing: dartdosh upgrade',
              'en': '💡 To upgrade, write this command: dartdosh upgrade',
              'ru': '💡 Для обновления напишите эту команду: dartdosh upgrade',
            };

            print(_color(
                updateAvailable[_language]![
                    _random.nextInt(updateAvailable[_language]!.length)],
                '32'));
            print(_color(currentInfo[_language]!, '36'));
            print(_color(upgradeHint[_language]!, '33'));
          } else {
            final upToDate = {
              'uz': [
                '✅ Update yo\'q ekan, sizda eng oxirgi versiya, Xo\'jayiin!',
                '🎯 Yangilanish kerak emas, eng yangi versiya ishlamoqda, Xo\'jayiin!',
                '👌 Hammasi zo\'r! Sizda eng so\'nggi versiya bor, Xo\'jayiin!',
              ],
              'en': [
                '✅ No update, you have the latest version, Boss!',
                '🎯 No update needed, latest version running, Boss!',
                '👌 All good! You have the latest version, Boss!',
              ],
              'ru': [
                '✅ Нет обновлений, у вас последняя версия, Босс!',
                '🎯 Обновление не нужно, последняя версия работает, Босс!',
                '👌 Всё отлично! У вас последняя версия, Босс!',
              ],
            };

            print(_color(
                upToDate[_language]![
                    _random.nextInt(upToDate[_language]!.length)],
                '32'));
          }
        }
      }
    } catch (e) {
      final error = {
        'uz': '❌ Serverga ulanib bo\'lmadi, Xo\'jayiin!',
        'en': '❌ Could not connect to server, Boss!',
        'ru': '❌ Не удалось подключиться к серверу, Босс!',
      };
      print(_color(error[_language]!, '31'));
    }
  }

  /// Upgrade to latest version
  static Future<void> upgrade() async {
    final oldVersion = currentVersion;

    final upgrading = {
      'uz': [
        '🚀 Upgrade boshlandi, Xo\'jayiin...',
        '⬆️ Yangilanmoqda, biroz sabr qiling Xo\'jayiin...',
        '✨ Eng yangi versiyaga o\'tilmoqda, Xo\'jayiin...',
      ],
      'en': [
        '🚀 Upgrade started, Boss...',
        '⬆️ Upgrading, please wait Boss...',
        '✨ Moving to latest version, Boss...',
      ],
      'ru': [
        '🚀 Обновление начато, Босс...',
        '⬆️ Обновляем, подождите Босс...',
        '✨ Переход на последнюю версию, Босс...',
      ],
    };

    print(_color(
        upgrading[_language]![_random.nextInt(upgrading[_language]!.length)],
        '33'));

    try {
      final result = await Process.run(
        'dart',
        ['pub', 'global', 'activate', packageName],
        runInShell: true,
      );

      if (result.exitCode == 0) {
        // Parse new version from output
        final output = result.stdout.toString();
        final versionMatch =
            RegExp(r'Activated dartdosh (\d+\.\d+\.\d+)').firstMatch(output);
        final newVersion = versionMatch?.group(1) ?? 'latest';

        final success = {
          'uz': [
            '🎉 $oldVersion → $newVersion. Endi bemalol maqtanib yursangiz bo\'ladi, Xo\'jayiin!',
            '✅ Zo\'r! $oldVersion dan $newVersion ga yangilandi. Maqtaning mumkin endi, Xo\'jayiin!',
            '🏆 Ajoyib! Versiya $newVersion ga o\'tdi. Do\'stlaringizga aytib yurasiz, Xo\'jayiin!',
            '🚀 Tayyor! $oldVersion → $newVersion. Endi hammasidan oldinda turibsiz, Xo\'jayiin!',
          ],
          'en': [
            '🎉 $oldVersion → $newVersion. Now you can brag about it, Boss!',
            '✅ Great! Upgraded from $oldVersion to $newVersion. You can show off now, Boss!',
            '🏆 Awesome! Version is now $newVersion. Tell your friends, Boss!',
            '🚀 Done! $oldVersion → $newVersion. Now you\'re ahead of everyone, Boss!',
          ],
          'ru': [
            '🎉 $oldVersion → $newVersion. Теперь можете хвастаться, Босс!',
            '✅ Отлично! Обновлено с $oldVersion на $newVersion. Можете показать, Босс!',
            '🏆 Супер! Версия теперь $newVersion. Расскажите друзьям, Босс!',
            '🚀 Готово! $oldVersion → $newVersion. Теперь вы впереди всех, Босс!',
          ],
        };

        print(_color(
            success[_language]![_random.nextInt(success[_language]!.length)],
            '32'));
      } else {
        _printUpgradeError();
      }
    } catch (e) {
      _printUpgradeError();
    }
  }

  /// Downgrade to specific version or previous version
  static Future<void> downgrade([String? version]) async {
    final oldVersion = currentVersion;

    final downgrading = {
      'uz': version != null
          ? '⬇️ $version versiyaga qaytilmoqda, Xo\'jayiin...'
          : '⬇️ Oldingi versiyaga qaytilmoqda, Xo\'jayiin...',
      'en': version != null
          ? '⬇️ Downgrading to $version, Boss...'
          : '⬇️ Downgrading to previous version, Boss...',
      'ru': version != null
          ? '⬇️ Откат к версии $version, Босс...'
          : '⬇️ Откат к предыдущей версии, Босс...',
    };

    print(_color(downgrading[_language]!, '33'));

    try {
      final args = version != null
          ? ['pub', 'global', 'activate', packageName, version]
          : [
              'pub',
              'global',
              'activate',
              packageName,
              '0.4.1'
            ]; // Previous version

      final result = await Process.run('dart', args, runInShell: true);

      if (result.exitCode == 0) {
        // Parse new version from output
        final output = result.stdout.toString();
        final versionMatch =
            RegExp(r'Activated dartdosh (\d+\.\d+\.\d+)').firstMatch(output);
        final newVersion = versionMatch?.group(1) ?? (version ?? 'previous');

        final success = {
          'uz': [
            '✅ $oldVersion dan $newVersion ga qaytarildi, Xo\'jayiin!',
            '🎯 Tayyor! Versiya $newVersion ga o\'rnatildi, Xo\'jayiin!',
            '👌 Downgrade tugadi! Endi $newVersion versiyada, Xo\'jayiin!',
          ],
          'en': [
            '✅ Downgraded from $oldVersion to $newVersion, Boss!',
            '🎯 Done! Version set to $newVersion, Boss!',
            '👌 Downgrade complete! Now on version $newVersion, Boss!',
          ],
          'ru': [
            '✅ Откат с $oldVersion на $newVersion, Босс!',
            '🎯 Готово! Версия установлена на $newVersion, Босс!',
            '👌 Откат завершён! Теперь версия $newVersion, Босс!',
          ],
        };

        print(_color(
            success[_language]![_random.nextInt(success[_language]!.length)],
            '32'));
      } else {
        _printDowngradeError();
      }
    } catch (e) {
      _printDowngradeError();
    }
  }

  static void _printUpgradeError() {
    final error = {
      'uz': '❌ Yangilanmadi! Internetni tekshiring, Xo\'jayiin!',
      'en': '❌ Upgrade failed! Check your internet, Boss!',
      'ru': '❌ Обновление не удалось! Проверьте интернет, Босс!',
    };
    print(_color(error[_language]!, '31'));
  }

  static void _printDowngradeError() {
    final error = {
      'uz': '❌ Orqaga qaytarilmadi! Versiya topilmadi, Xo\'jayiin!',
      'en': '❌ Downgrade failed! Version not found, Boss!',
      'ru': '❌ Откат не удался! Версия не найдена, Босс!',
    };
    print(_color(error[_language]!, '31'));
  }

  static String _color(String text, String colorCode) =>
      '\x1B[${colorCode}m$text\x1B[0m';
}
