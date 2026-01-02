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

  /// Get current version from pubspec.yaml
  static String _getCurrentVersion() {
    try {
      final pubspecFile = File('pubspec.yaml');
      if (pubspecFile.existsSync()) {
        final content = loadYaml(pubspecFile.readAsStringSync());
        return content['version']?.toString() ?? '0.0.0';
      }
    } catch (e) {
      // Fallback
    }
    return '0.0.0';
  }

  /// Show current version with fun message
  static void showVersion() {
    final currentVersion = _getCurrentVersion();

    final messages = {
      'uz': [
        '🎯 Sizda DartDosh $currentVersion versiya bor ekan, Xo\'jayiin!',
        '✨ Hozir $currentVersion versiyada ishlamoqdasiz, Xo\'jayiin!',
        '🚀 Versiyangiz: $currentVersion - zo\'r versiya, Xo\'jayiin!',
      ],
      'en': [
        '🎯 You have DartDosh version $currentVersion, Boss!',
        '✨ Currently running version $currentVersion, Boss!',
        '🚀 Your version: $currentVersion - great version, Boss!',
      ],
      'ru': [
        '🎯 У вас DartDosh версия $currentVersion, Босс!',
        '✨ Сейчас работает версия $currentVersion, Босс!',
        '🚀 Ваша версия: $currentVersion - отличная версия, Босс!',
      ],
    };

    final langMessages = messages[_language] ?? messages['en']!;
    print(_color(langMessages[_random.nextInt(langMessages.length)], '36'));
  }

  /// Check for updates
  static Future<void> checkVersion() async {
    final currentVersion = _getCurrentVersion();

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
              'uz': '💡 Yangilash uchun: dartdosh upgrade deb yozing, Xo\'jayiin!',
              'en': '💡 To upgrade: type dartdosh upgrade, Boss!',
              'ru': '💡 Для обновления: напишите dartdosh upgrade, Босс!',
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
                '✅ Siz eng so\'nggi versiyada turibsiz, Xo\'jayiin!',
                '🎯 Hammasi yangi, update kerak emas, Xo\'jayiin!',
                '👌 Zo\'r! Eng yangi versiya ishlamoqda, Xo\'jayiin!',
              ],
              'en': [
                '✅ You\'re on the latest version, Boss!',
                '🎯 All fresh, no update needed, Boss!',
                '👌 Great! Latest version running, Boss!',
              ],
              'ru': [
                '✅ У вас последняя версия, Босс!',
                '🎯 Всё свежее, обновление не нужно, Босс!',
                '👌 Отлично! Последняя версия работает, Босс!',
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
    final oldVersion = _getCurrentVersion();

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
        // Get new version after upgrade
        final newVersion = _getCurrentVersion();

        final success = {
          'uz': [
            '✅ Versiyangiz $oldVersion dan $newVersion ga yangilandi, Xo\'jayiin!',
            '🎉 Tayyor! $oldVersion → $newVersion. Endi bemalol maqtanib yursangiz bo\'ladi, Xo\'jayiin!',
            '🏆 Zo\'r! Yangi $newVersion versiya o\'rnatildi. Maqtaning kerak, Xo\'jayiin!',
          ],
          'en': [
            '✅ Your version upgraded from $oldVersion to $newVersion, Boss!',
            '🎉 Done! $oldVersion → $newVersion. Now you can brag about it, Boss!',
            '🏆 Great! New version $newVersion installed. Show off now, Boss!',
          ],
          'ru': [
            '✅ Версия обновлена с $oldVersion на $newVersion, Босс!',
            '🎉 Готово! $oldVersion → $newVersion. Теперь можете хвастаться, Босс!',
            '🏆 Отлично! Новая версия $newVersion установлена. Пора похвастаться, Босс!',
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
    final oldVersion = _getCurrentVersion();

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
        final newVersion = _getCurrentVersion();

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
