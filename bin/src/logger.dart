import 'dart:math';

enum LogType {
  start,
  info,
  step,
  success,
  error,
  finished,
  buildConfigIsNotExist,
  running
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
    ]
  };

  static String _color(String text, String colorCode) =>
      '\x1B[${colorCode}m$text\x1B[0m';

  static void log(LogType type,
      {String target = '',
      String env = '',
      String file = '',
      String command = ''}) {
    final list = _messages[type];
    if (list == null || list.isEmpty) return;

    // Random tanlash
    final message = list[_random.nextInt(list.length)]
        .replaceAll('{target}', target)
        .replaceAll('{env}', env)
        .replaceAll('{file}', file)
        .replaceAll('{command}', command);

    String coloredMessage;
    switch (type) {
      case LogType.start:
        coloredMessage = _color(message, '34'); // Blue
        break;
      case LogType.step:
        coloredMessage = _color(message, '36'); // Cyan
        break;
      case LogType.success:
        coloredMessage = _color(message, '32'); // Green
        break;
      case LogType.error:
        coloredMessage = _color(message, '31'); // Red
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
