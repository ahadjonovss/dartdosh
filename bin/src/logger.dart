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
      '🚀 Boshlash: Build {target} ({env} mode)',
      '✨ Tayyor tur: {target} build ishga tushdi ({env})',
      '🏁 Jarayon boshlandi: {target} ({env})'
    ],
    LogType.info: [
      'ℹ️ Malumot: Target file "{file}" topilmadi.',
      '⚠️ Ogohlantirish: "{file}" mavjud emas, build davom etadi.',
      'ℹ️ Eslatma: "{file}" yo‘q, default fayllar ishlatiladi.'
    ],
    LogType.step: [
      '🔧 {target} build bosqichi: Flutter komandalar bajarilmoqda...',
      '⚙️ Jarayon: Build bosqichlari ishlamoqda...',
      '🛠️ Step: {target} build jarayoni davom etmoqda...'
    ],
    LogType.success: [
      '✅ {target} build muvaffaqiyatli yakunlandi!',
      '🎉 Ilova tayyor: {target} ({env})',
      '🏆 {target} build completed successfully!'
    ],
    LogType.error: [
      '❌ {target} build xatolik yuz berdi!',
      '💥 Nimadir noto‘g‘ri ketdi: {target} ({env})',
      '⚠️ Build bajarilmadi: {target} ({env})'
    ],
    LogType.finished: [
      '🏁 Build yakunlandi: {target} ({env})',
      '🎯 {target} build finished successfully!',
      '🛑 Build tugadi: {target} ({env})'
    ],
    LogType.buildConfigIsNotExist: [
      '⚠️ Build config topilmadi: build_config.json mavjud emas!',
      '❌ Fayl yo‘q: build_config.json topilmadi, build to‘xtadi!',
      'ℹ️ Eslatma: build_config.json faylini yaratishingiz kerak!'
    ],
    LogType.running: [
      '🔄 Ishga tushirilmoqda: {command}',
      '⏳ Komanda bajarilmoqda: {command}',
      '🏃 Jarayon: {command}'
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
