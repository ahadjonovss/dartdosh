import 'dart:math';

enum LogType {
  start,
  info,
  step,
  success,
  error,
  finished,
  buildConfigIsNotExist,
  running,
  donation,
  buildNumberIncremented,
  fileSaved,
  outputDirCreated
}

class Logger {
  static final _random = Random();
  static String _currentLanguage = 'uz';

  static void setLanguage(String language) {
    if (['uz', 'en', 'ru'].contains(language)) {
      _currentLanguage = language;
    }
  }

  static final Map<String, Map<LogType, List<String>>> _translations = {
    'uz': {
      LogType.start: [
        '🚀 Boshlash: Build {target} ({env} mode), Xo\'jayiin!',
        '✨ Tayyor tur: {target} build ishga tushdi ({env}), Xo\'jayiin!',
        '🏁 Jarayon boshlandi: {target} ({env}), Xo\'jayiin!'
      ],
      LogType.step: [
        '🔧 {target} build bosqichi: Flutter komandalar bajarilmoqda, Xo\'jayiin...',
        '⚙️ Jarayon: Build bosqichlari ishlamoqda, Xo\'jayiin...',
        '🛠️ Step: {target} build jarayoni davom etmoqda, Xo\'jayiin...'
      ],
      LogType.success: [
        '✅ {target} build muvaffaqiyatli yakunlandi, Xo\'jayiin!',
        '🎉 Ilova tayyor: {target} ({env}), Xo\'jayiin!',
        '🏆 {target} build muvaffaqiyatli tugadi, Xo\'jayiin!'
      ],
      LogType.error: [
        '❌ {target} build xatolik yuz berdi, Xo\'jayiin!',
        '💥 Nimadir noto\'g\'ri ketdi: {target} ({env}), Xo\'jayiin!',
        '⚠️ Build bajarilmadi: {target} ({env}), Xo\'jayiin!'
      ],
      LogType.buildConfigIsNotExist: [
        '⚠️ Build config topilmadi, default yaratilmoqda, Xo\'jayiin!',
        '📝 build_config.json yo\'q, default config yaratdim, Xo\'jayiin!',
        'ℹ️ Konfiguratsiya yaratilmoqda, Xo\'jayiin!'
      ],
      LogType.running: [
        '🔄 Ishga tushirilmoqda: {command}, Xo\'jayiin!',
        '⏳ Komanda bajarilmoqda: {command}, Xo\'jayiin!',
        '🏃 Jarayon: {command}, Xo\'jayiin!'
      ],
      LogType.donation: [
        '\n☕ Xo\'jayiin, agar dartdosh yoqsa, menga bir choy pul tashlang: https://www.tirikchilik.uz/ahadjonovss\n   Qahva ichib, yanada zo\'r toollar yasayman! 😄',
        '\n💰 Xo\'jayiin, bu tool foydali bo\'lsa, bir gap emas, donat qilaverasiz: https://www.tirikchilik.uz/ahadjonovss\n   Bir gap qilsangiz, yangi featurelar chiqaraman! 🚀',
        '\n🎁 Xo\'jayiin, dartdosh yordamchi bo\'lyaptimi? Unda shu linkka bir nazar: https://www.tirikchilik.uz/ahadjonovss\n   Sponsor bo\'ling, yanada kuchli qilib qo\'yamiz! 💪',
        '\n🍕 Build tayyor bo\'ldi, endi mening navbat! Pizza uchun yordam bersangiz: https://www.tirikchilik.uz/ahadjonovss\n   Coding bilan pizza - eng zo\'r kombinatsiya! 🤩',
        '\n🤑 Xo\'jayiin, bu tooldan foydalanib vaqtingizni tejadingizmi? Unda menga ham yordam qiling: https://www.tirikchilik.uz/ahadjonovss\n   Bitta kofe puli bo\'lsa ham, ruhim ko\'tariladi! ☕',
        '\n💝 Ey Xo\'jayiin, dartdosh sizga yoqdimi? Quvontirdimmi? Unda bir donationcha: https://www.tirikchilik.uz/ahadjonovss\n   Katta pul emas, dildan keladigani yetarli! 😊',
        '\n🎯 Build muvaffaqiyatli! Endi meni ham unutmang: https://www.tirikchilik.uz/ahadjonovss\n   Sizning supportingiz bilan yanada zo\'r toollar yaratamiz! 🔥',
        '\n🌟 Xo\'jayiin, open source developer hayoti qiyin-ku! Yordam qo\'lingizni cho\'zing: https://www.tirikchilik.uz/ahadjonovss\n   Bir lagmon puli ham katta gap! 🍜',
        '\n🎊 Build tayyor, siz ham baxtli, men ham! Endi menga ham bir iltifoat: https://www.tirikchilik.uz/ahadjonovss\n   Support qilsangiz, keyingi versiya tezroq chiqadi! ⚡',
        '\n😎 Xo\'jayiin, dartdosh sizning vaqtingizni tejaydimi? Unda mening vaqtimni ham qadrlang: https://www.tirikchilik.uz/ahadjonovss\n   Bir choynak choy puli kerak xolos! 🍵'
      ],
      LogType.buildNumberIncremented: [
        '✅ Build number yangilandi: {oldBuild} → {newBuild}, Xo\'jayiin!',
        '🔢 Build raqami ko\'tarildi: {oldBuild} → {newBuild}, Xo\'jayiin!',
        '📈 Yangi build number: {newBuild} (oldingi: {oldBuild}), Xo\'jayiin!'
      ],
      LogType.fileSaved: [
        '✅ Build saqlandi: {path}, Xo\'jayiin!',
        '💾 Fayl tayyor: {path}, Xo\'jayiin!',
        '📦 Build muvaffaqiyatli ko\'chirildi: {path}, Xo\'jayiin!'
      ],
      LogType.outputDirCreated: [
        '📁 Output directory yaratildi: {path}, Xo\'jayiin!',
        '🗂️ Yangi papka tuzildi: {path}, Xo\'jayiin!',
        '✨ Output papka tayyor: {path}, Xo\'jayiin!'
      ],
    },
    'en': {
      LogType.start: [
        '🚀 Starting: Build {target} ({env} mode), Boss!',
        '✨ Ready: {target} build started ({env}), Boss!',
        '🏁 Process started: {target} ({env}), Boss!'
      ],
      LogType.step: [
        '🔧 {target} build step: Running Flutter commands, Boss...',
        '⚙️ Process: Build steps in progress, Boss...',
        '🛠️ Step: {target} build process ongoing, Boss...'
      ],
      LogType.success: [
        '✅ {target} build completed successfully, Boss!',
        '🎉 App ready: {target} ({env}), Boss!',
        '🏆 {target} build finished successfully, Boss!'
      ],
      LogType.error: [
        '❌ {target} build failed, Boss!',
        '💥 Something went wrong: {target} ({env}), Boss!',
        '⚠️ Build failed: {target} ({env}), Boss!'
      ],
      LogType.buildConfigIsNotExist: [
        '⚠️ Build config not found, creating default, Boss!',
        '📝 build_config.json missing, created default config, Boss!',
        'ℹ️ Creating configuration, Boss!'
      ],
      LogType.running: [
        '🔄 Running: {command}, Boss!',
        '⏳ Executing command: {command}, Boss!',
        '🏃 Process: {command}, Boss!'
      ],
      LogType.donation: [
        '\n☕ Boss, if you like dartdosh, buy me a coffee: https://www.tirikchilik.uz/ahadjonovss\n   I\'ll make even better tools! 😄',
        '\n💰 Boss, if this tool is useful, consider donating: https://www.tirikchilik.uz/ahadjonovss\n   Your support brings new features! 🚀',
        '\n🎁 Boss, is dartdosh helpful? Check out this link: https://www.tirikchilik.uz/ahadjonovss\n   Become a sponsor, let\'s make it even better! 💪',
        '\n🍕 Build ready, now it\'s my turn! Help me get pizza: https://www.tirikchilik.uz/ahadjonovss\n   Coding with pizza - best combo! 🤩',
        '\n🤑 Boss, did this tool save you time? Help me too: https://www.tirikchilik.uz/ahadjonovss\n   Even a coffee would brighten my day! ☕',
        '\n💝 Hey Boss, do you like dartdosh? Made you happy? Then donate: https://www.tirikchilik.uz/ahadjonovss\n   Not much needed, whatever comes from heart! 😊',
        '\n🎯 Build successful! Don\'t forget about me: https://www.tirikchilik.uz/ahadjonovss\n   Your support helps create better tools! 🔥',
        '\n🌟 Boss, open source dev life is tough! Lend a hand: https://www.tirikchilik.uz/ahadjonovss\n   Even small support means a lot! 🍜',
        '\n🎊 Build ready, you\'re happy, me too! Now treat me: https://www.tirikchilik.uz/ahadjonovss\n   Support brings faster updates! ⚡',
        '\n😎 Boss, does dartdosh save your time? Value mine too: https://www.tirikchilik.uz/ahadjonovss\n   Just enough for tea! 🍵'
      ],
      LogType.buildNumberIncremented: [
        '✅ Build number updated: {oldBuild} → {newBuild}, Boss!',
        '🔢 Build number incremented: {oldBuild} → {newBuild}, Boss!',
        '📈 New build number: {newBuild} (previous: {oldBuild}), Boss!'
      ],
      LogType.fileSaved: [
        '✅ Build saved: {path}, Boss!',
        '💾 File ready: {path}, Boss!',
        '📦 Build successfully moved: {path}, Boss!'
      ],
      LogType.outputDirCreated: [
        '📁 Output directory created: {path}, Boss!',
        '🗂️ New folder created: {path}, Boss!',
        '✨ Output folder ready: {path}, Boss!'
      ],
    },
    'ru': {
      LogType.start: [
        '🚀 Начало: Сборка {target} (режим {env}), Босс!',
        '✨ Готово: запущена сборка {target} ({env}), Босс!',
        '🏁 Процесс начат: {target} ({env}), Босс!'
      ],
      LogType.step: [
        '🔧 Шаг сборки {target}: выполняются команды Flutter, Босс...',
        '⚙️ Процесс: идут этапы сборки, Босс...',
        '🛠️ Шаг: процесс сборки {target} продолжается, Босс...'
      ],
      LogType.success: [
        '✅ Сборка {target} успешно завершена, Босс!',
        '🎉 Приложение готово: {target} ({env}), Босс!',
        '🏆 Сборка {target} успешно завершена, Босс!'
      ],
      LogType.error: [
        '❌ Ошибка сборки {target}, Босс!',
        '💥 Что-то пошло не так: {target} ({env}), Босс!',
        '⚠️ Сборка не удалась: {target} ({env}), Босс!'
      ],
      LogType.buildConfigIsNotExist: [
        '⚠️ Конфиг сборки не найден, создаю стандартный, Босс!',
        '📝 build_config.json отсутствует, создал стандартный конфиг, Босс!',
        'ℹ️ Создаю конфигурацию, Босс!'
      ],
      LogType.running: [
        '🔄 Запуск: {command}, Босс!',
        '⏳ Выполняется команда: {command}, Босс!',
        '🏃 Процесс: {command}, Босс!'
      ],
      LogType.donation: [
        '\n☕ Босс, если dartdosh нравится, купи мне кофе: https://www.tirikchilik.uz/ahadjonovss\n   Сделаю ещё лучшие инструменты! 😄',
        '\n💰 Босс, если инструмент полезен, поддержи донатом: https://www.tirikchilik.uz/ahadjonovss\n   Твоя поддержка приносит новые фичи! 🚀',
        '\n🎁 Босс, dartdosh помогает? Загляни по ссылке: https://www.tirikchilik.uz/ahadjonovss\n   Стань спонсором, сделаем ещё круче! 💪',
        '\n🍕 Сборка готова, теперь моя очередь! Помоги с пиццей: https://www.tirikchilik.uz/ahadjonovss\n   Код с пиццей - лучшее комбо! 🤩',
        '\n🤑 Босс, инструмент сэкономил время? Помоги и мне: https://www.tirikchilik.uz/ahadjonovss\n   Даже кофе поднимет настроение! ☕',
        '\n💝 Эй Босс, нравится dartdosh? Порадовал? Тогда задонать: https://www.tirikchilik.uz/ahadjonovss\n   Много не нужно, сколько от души! 😊',
        '\n🎯 Сборка успешна! Не забудь про меня: https://www.tirikchilik.uz/ahadjonovss\n   Твоя поддержка создаёт лучшие инструменты! 🔥',
        '\n🌟 Босс, жизнь open source разработчика тяжела! Протяни руку: https://www.tirikchilik.uz/ahadjonovss\n   Даже малая поддержка важна! 🍜',
        '\n🎊 Сборка готова, ты счастлив, я тоже! Теперь угости меня: https://www.tirikchilik.uz/ahadjonovss\n   Поддержка ускоряет обновления! ⚡',
        '\n😎 Босс, dartdosh экономит время? Цени и моё: https://www.tirikchilik.uz/ahadjonovss\n   Хватит на чай! 🍵'
      ],
      LogType.buildNumberIncremented: [
        '✅ Build number обновлён: {oldBuild} → {newBuild}, Босс!',
        '🔢 Build number увеличен: {oldBuild} → {newBuild}, Босс!',
        '📈 Новый build number: {newBuild} (предыдущий: {oldBuild}), Босс!'
      ],
      LogType.fileSaved: [
        '✅ Сборка сохранена: {path}, Босс!',
        '💾 Файл готов: {path}, Босс!',
        '📦 Сборка успешно перемещена: {path}, Босс!'
      ],
      LogType.outputDirCreated: [
        '📁 Выходная папка создана: {path}, Босс!',
        '🗂️ Новая папка создана: {path}, Босс!',
        '✨ Выходная папка готова: {path}, Босс!'
      ],
    },
  };

  static String _color(String text, String colorCode) =>
      '\x1B[${colorCode}m$text\x1B[0m';

  static void log(LogType type,
      {String target = '',
      String env = '',
      String file = '',
      String command = '',
      String oldBuild = '',
      String newBuild = '',
      String path = ''}) {
    final messages = _translations[_currentLanguage];
    if (messages == null) return;

    final list = messages[type];
    if (list == null || list.isEmpty) return;

    // Random selection
    final message = list[_random.nextInt(list.length)]
        .replaceAll('{target}', target)
        .replaceAll('{env}', env)
        .replaceAll('{file}', file)
        .replaceAll('{command}', command)
        .replaceAll('{oldBuild}', oldBuild)
        .replaceAll('{newBuild}', newBuild)
        .replaceAll('{path}', path);

    String coloredMessage;
    switch (type) {
      case LogType.start:
        coloredMessage = _color(message, '34'); // Blue
        break;
      case LogType.step:
        coloredMessage = _color(message, '36'); // Cyan
        break;
      case LogType.success:
      case LogType.buildNumberIncremented:
      case LogType.fileSaved:
      case LogType.outputDirCreated:
        coloredMessage = _color(message, '32'); // Green
        break;
      case LogType.error:
        coloredMessage = _color(message, '31'); // Red
        break;
      case LogType.donation:
        coloredMessage = _color(message, '35'); // Magenta
        break;
      case LogType.info:
      case LogType.finished:
      case LogType.buildConfigIsNotExist:
      case LogType.running:
        coloredMessage = _color(message, '33'); // Yellow
        break;
    }

    print(coloredMessage);
  }
}
