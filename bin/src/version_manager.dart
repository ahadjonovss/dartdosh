import 'dart:convert';
import 'dart:io';
import 'dart:math';

/// Version manager for DartDosh CLI tool
///
/// Handles version checking, upgrades, and downgrades with fun, localized messages
class VersionManager {
  static const String currentVersion = '0.5.0';
  static const String packageName = 'dartdosh';

  static final _random = Random();
  static String _language = 'uz';

  static void setLanguage(String language) {
    if (['uz', 'en', 'ru'].contains(language)) {
      _language = language;
    }
  }

  /// Show current version with fun message
  static void showVersion() {
    final messages = {
      'uz': [
        '🎯 DartDosh versiyasi: $currentVersion, Xo\'jayiin!',
        '✨ Hozirgi versiya: $currentVersion, ishlaymiz Xo\'jayiin!',
        '🚀 DartDosh $currentVersion - zo\'r versiya, Xo\'jayiin!',
      ],
      'en': [
        '🎯 DartDosh version: $currentVersion, Boss!',
        '✨ Current version: $currentVersion, running smooth Boss!',
        '🚀 DartDosh $currentVersion - great version, Boss!',
      ],
      'ru': [
        '🎯 Версия DartDosh: $currentVersion, Босс!',
        '✨ Текущая версия: $currentVersion, работаем Босс!',
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
                '🎉 Yangi versiya topildi: $latest, Xo\'jayiin!',
                '✨ Yangilanish mavjud: $latest, Xo\'jayiin!',
                '🚀 Yangi $latest versiya chiqdi, Xo\'jayiin!',
              ],
              'en': [
                '🎉 New version found: $latest, Boss!',
                '✨ Update available: $latest, Boss!',
                '🚀 New version $latest is out, Boss!',
              ],
              'ru': [
                '🎉 Новая версия найдена: $latest, Босс!',
                '✨ Доступно обновление: $latest, Босс!',
                '🚀 Вышла новая версия $latest, Босс!',
              ],
            };

            final upgradeHint = {
              'uz': '💡 Yangilash: dartdosh upgrade',
              'en': '💡 Upgrade: dartdosh upgrade',
              'ru': '💡 Обновить: dartdosh upgrade',
            };

            print(_color(
                updateAvailable[_language]![
                    _random.nextInt(updateAvailable[_language]!.length)],
                '32'));
            print(_color(upgradeHint[_language]!, '36'));
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
    final upgrading = {
      'uz': [
        '🚀 Yangilanmoqda, bir oz kuting Xo\'jayiin...',
        '⬆️ Upgrade qilinmoqda, Xo\'jayiin...',
        '✨ Eng yangi versiyaga o\'tilmoqda, Xo\'jayiin...',
      ],
      'en': [
        '🚀 Upgrading, wait a moment Boss...',
        '⬆️ Upgrading now, Boss...',
        '✨ Moving to latest version, Boss...',
      ],
      'ru': [
        '🚀 Обновление, подождите Босс...',
        '⬆️ Обновляем сейчас, Босс...',
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
        final success = {
          'uz': [
            '✅ Muvaffaqiyatli yangilandi, Xo\'jayiin!',
            '🎉 Upgrade tugadi! Endi eng yangi versiya bor, Xo\'jayiin!',
            '🏆 Tayyor! Yangi versiya o\'rnatildi, Xo\'jayiin!',
          ],
          'en': [
            '✅ Successfully upgraded, Boss!',
            '🎉 Upgrade complete! Now on latest version, Boss!',
            '🏆 Done! New version installed, Boss!',
          ],
          'ru': [
            '✅ Успешно обновлено, Босс!',
            '🎉 Обновление завершено! Теперь последняя версия, Босс!',
            '🏆 Готово! Новая версия установлена, Босс!',
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
          : ['pub', 'global', 'activate', packageName, '0.4.1']; // Previous version

      final result = await Process.run('dart', args, runInShell: true);

      if (result.exitCode == 0) {
        final success = {
          'uz': [
            '✅ Muvaffaqiyatli orqaga qaytarildi, Xo\'jayiin!',
            '🎯 Downgrade tugadi, Xo\'jayiin!',
            '👌 Tayyor! Kerakli versiya o\'rnatildi, Xo\'jayiin!',
          ],
          'en': [
            '✅ Successfully downgraded, Boss!',
            '🎯 Downgrade complete, Boss!',
            '👌 Done! Required version installed, Boss!',
          ],
          'ru': [
            '✅ Успешно откачено, Босс!',
            '🎯 Откат завершён, Босс!',
            '👌 Готово! Нужная версия установлена, Босс!',
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
