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
  outputDirCreated,
  configFileOpened
}

class Logger {
  static final _random = Random();

  static final Map<LogType, List<String>> _messages = {
    LogType.start: [
      '🚀 Boshlash: Build {target} ({env} mode), Xo\'jayiin!',
      '✨ Tayyor tur: {target} build ishga tushdi ({env}), Xo\'jayiin!',
      '🏁 Jarayon boshlandi: {target} ({env}), Xo\'jayiin!'
    ],
    LogType.info: [
      'ℹ️ Malumot: Target file "{file}" topilmadi, Xo\'jayiin.',
      '⚠️ Ogohlantirish: "{file}" mavjud emas, build davom etadi, Xo\'jayiin.',
      'ℹ️ Eslatma: "{file}" yo\'q, default fayllar ishlatiladi, Xo\'jayiin.'
    ],
    LogType.step: [
      '🔧 {target} build bosqichi: Flutter komandalar bajarilmoqda, Xo\'jayiin...',
      '⚙️ Jarayon: Build bosqichlari ishlamoqda, Xo\'jayiin...',
      '🛠️ Step: {target} build jarayoni davom etmoqda, Xo\'jayiin...'
    ],
    LogType.success: [
      '✅ {target} build muvaffaqiyatli yakunlandi, Xo\'jayiin!',
      '🎉 Ilova tayyor: {target} ({env}), Xo\'jayiin!',
      '🏆 {target} build completed successfully, Xo\'jayiin!'
    ],
    LogType.error: [
      '❌ {target} build xatolik yuz berdi, Xo\'jayiin!',
      '💥 Nimadir noto\'g\'ri ketdi: {target} ({env}), Xo\'jayiin!',
      '⚠️ Build bajarilmadi: {target} ({env}), Xo\'jayiin!'
    ],
    LogType.finished: [
      '🏁 Build yakunlandi: {target} ({env}), Xo\'jayiin!',
      '🎯 {target} build finished successfully, Xo\'jayiin!',
      '🛑 Build tugadi: {target} ({env}), Xo\'jayiin!'
    ],
    LogType.buildConfigIsNotExist: [
      '⚠️ Build config topilmadi: build_config.json mavjud emas, Xo\'jayiin!',
      '❌ Fayl yo\'q: build_config.json topilmadi, build to\'xtadi, Xo\'jayiin!',
      'ℹ️ Eslatma: build_config.json faylini yaratishingiz kerak, Xo\'jayiin!'
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
    LogType.configFileOpened: [
      '📝 Config fayl ochildi, Xo\'jayiin!',
      '✅ Konfiguratsiya fayli ochiq, Xo\'jayiin!',
      '📄 build_config.json ochildi, Xo\'jayiin!'
    ]
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
    final list = _messages[type];
    if (list == null || list.isEmpty) return;

    // Random tanlash
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
      case LogType.configFileOpened:
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
