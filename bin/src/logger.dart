import 'dart:math';

enum LogType {
  start,
  info,
  step,
  success,
  error,
  finished,
  buildConfigIsNotExist,
  buildConfigCreated,
  running,
  donation,
  buildNumberIncremented,
  fileSaved,
  outputDirCreated,
  uploadStarting,
  uploadProgress,
  uploadSuccess,
  uploadFailed,
  uploadCredentialsMissing,
  totalTime,
  // Init command logs
  initStarted,
  configCreated,
  configValidationFailed,
  configCreationFailed,
  migrationStarted,
  migrationCompleted,
  migrationFailed,
  missingFieldAdded,
  alreadyConfigured,
  initCompleted,
  configNotFound
}

class Logger {
  static final _random = Random();
  static String _currentLanguage = 'uz';

  static void setLanguage(String language) {
    if (['uz', 'en', 'ru'].contains(language)) {
      _currentLanguage = language;
    } else {
      // Unsupported language - fallback to English with warning
      _currentLanguage = 'en';
      print(
          '\x1B[33m⚠️  Warning: Language "$language" is not supported. Falling back to English.\x1B[0m');
      print(
          '\x1B[33m   Supported languages: uz (Uzbek), en (English), ru (Russian)\x1B[0m\n');
    }
  }

  /// Returns localized progress task message
  static String getProgressTask(String taskKey) {
    final tasks = _progressTasks[_currentLanguage];
    return tasks?[taskKey] ?? taskKey;
  }

  /// Progress task translations
  static final Map<String, Map<String, String>> _progressTasks = {
    'uz': {
      'starting': 'Boshlanyapti...',
      'gradle': 'Gradle ishlayapti...',
      'dependencies_downloading': 'Dependencylar yuklanmoqda...',
      'dependencies_ready': 'Dependencylar tayyor...',
      'compiling': 'Flutter kodi kompilyatsiya qilinyapti...',
      'bundling': 'Bundle yaratilmoqda...',
      'assembling': 'APK/AAB yig\'ilmoqda...',
      'signing': 'Imzolanmoqda...',
      'finishing': 'Tugallanmoqda...',
      'ready': 'Tayyor!',
    },
    'en': {
      'starting': 'Starting...',
      'gradle': 'Running Gradle...',
      'dependencies_downloading': 'Downloading dependencies...',
      'dependencies_ready': 'Dependencies ready...',
      'compiling': 'Compiling Flutter code...',
      'bundling': 'Creating bundle...',
      'assembling': 'Assembling APK/AAB...',
      'signing': 'Signing...',
      'finishing': 'Finishing...',
      'ready': 'Ready!',
    },
    'ru': {
      'starting': 'Начинается...',
      'gradle': 'Запуск Gradle...',
      'dependencies_downloading': 'Загрузка зависимостей...',
      'dependencies_ready': 'Зависимости готовы...',
      'compiling': 'Компиляция кода Flutter...',
      'bundling': 'Создание bundle...',
      'assembling': 'Сборка APK/AAB...',
      'signing': 'Подписывается...',
      'finishing': 'Завершается...',
      'ready': 'Готово!',
    },
  };

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
      LogType.buildConfigCreated: [
        '\n📋 Xo\'jayiin, build_config.json yaratib qo\'ydim!\n✅ Iltimos, tekshirib ko\'ring va to\'g\'ri bo\'lsa commandni qayta run qiling.\n💼 Xizmatizga tayyorman, Xo\'jayiin!',
        '\n📝 Build config tayyor, Xo\'jayiin!\n🔍 Configni tekshirib, keyin qayta ishga tushiring.\n🚀 Buyruq kutmoqdaman, Xo\'jayiin!',
        '\n✨ Default config yaratdim, Xo\'jayiin!\n📖 Ko\'rib chiqing va mos bo\'lsa, commandni qaytadan bajaring.\n⚡ Tayyor turaman, Xo\'jayiin!'
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
      LogType.uploadStarting: [
        '📤 IPA fayl App Store Connect ga yuklanmoqda, Xo\'jayiin...',
        '🚀 Transporter ishga tushdi, IPA yuklanmoqda, Xo\'jayiin...',
        '⬆️ Upload jarayoni boshlandi, Xo\'jayiin...'
      ],
      LogType.uploadProgress: [
        '⏳ {progress}',
      ],
      LogType.uploadSuccess: [
        '✅ IPA muvaffaqiyatli App Store Connect ga yuklandi, Xo\'jayiin!',
        '🎉 Upload tayyor! IPA App Store da, Xo\'jayiin!',
        '🏆 Fayl muvaffaqiyatli yuklandi, Xo\'jayiin!'
      ],
      LogType.uploadFailed: [
        '❌ IPA upload xatolik bilan yakunlandi, Xo\'jayiin!',
        '💥 Upload muvaffaqiyatsiz, Xo\'jayiin!',
        '⚠️ Faylni yuklashda muammo, Xo\'jayiin!'
      ],
      LogType.uploadCredentialsMissing: [
        '⚠️ Upload yoqilgan, lekin Apple ID yoki parol kiritilmagan, Xo\'jayiin!',
        '🔐 Credentials topilmadi! build_config.json ga Apple ID va parol qo\'shing, Xo\'jayiin!',
        '⚡ Yuklash uchun Apple ID kerak, Xo\'jayiin!'
      ],
      LogType.totalTime: [
        '⏱️  Umumiy vaqt: {time} soniya. Siz uchun {time} soniya mehnat qildim, Xo\'jayiin! 💪',
        '🎯 Jarayon {time} soniyada tugadi. Vaqtingizni tejadim, Xo\'jayiin! ⚡',
        '✨ {time} soniyada hammasi tayyor! Sizga xizmat qilish baxt, Xo\'jayiin! 🚀'
      ],
      LogType.initStarted: [
        '🚀 Dartdosh konfiguratsiya qilinmoqda, Xo\'jayiin...',
        '✨ Init jarayoni boshlandi, Xo\'jayiin...',
        '🔧 Configuratsiya tekshirilmoqda, Xo\'jayiin...'
      ],
      LogType.configCreated: [
        '✅ Yangi config fayllar yaratildi, Xo\'jayiin!',
        '📝 Konfiguratsiya tayyor, Xo\'jayiin!',
        '🎉 Config fayllar muvaffaqiyatli yaratildi, Xo\'jayiin!'
      ],
      LogType.migrationStarted: [
        '🔄 Eski build_config.json topildi, yangi strukturaga o\'tkazilmoqda, Xo\'jayiin...',
        '📦 Migration boshlandi, Xo\'jayiin...',
        '⚡ Eski configdan ma\'lumotlar ko\'chirilmoqda, Xo\'jayiin...'
      ],
      LogType.migrationCompleted: [
        '✅ Migration muvaffaqiyatli! Barcha ma\'lumotlar yangi faylga ko\'chirildi, Xo\'jayiin!',
        '🎉 Eski config yangi formatga o\'tkazildi, Xo\'jayiin!',
        '🏆 Migration tayyor! Hamma data saqlab qoldim, Xo\'jayiin!'
      ],
      LogType.migrationFailed: [
        '❌ Migration xatolik bilan yakunlandi, Xo\'jayiin!',
        '💥 Eski configni o\'qishda muammo, Xo\'jayiin!',
        '⚠️ Migration amalga oshmadi, Xo\'jayiin!'
      ],
      LogType.missingFieldAdded: [
        '✅ Yetishmayotgan maydon qo\'shildi: {field}, Xo\'jayiin!',
        '🔧 Yangilandi: {field} qo\'shib qo\'ydim, Xo\'jayiin!',
        '📝 {field} - mana bu data yo\'q ekan, qo\'shib qo\'ydim, Xo\'jayiin!'
      ],
      LogType.alreadyConfigured: [
        '✅ Sizda hammasi bor ekan! Konfiguratsiya to\'liq, Xo\'jayiin!',
        '🎯 Hammasi tayyor, hech narsa etishmayapti, Xo\'jayiin!',
        '👌 Config to\'liq, qo\'shimcha narsa kerak emas, Xo\'jayiin!'
      ],
      LogType.initCompleted: [
        '\n✅ Configlar dartdosh_config/ papkasida yaratildi, Xo\'jayiin!\n📝 Iltimos avval bir tekshiring, keyin bemalol ishlatishingiz mumkin!\n💡 Masalan: dartdosh build apk -p',
        '\n🎉 dartdosh_config/ papkasida configlar tayyor, Xo\'jayiin!\n🔍 Birinchi fayllarni ko\'zdan kechiring, keyin build boshlashingiz mumkin!\n💡 Misol: dartdosh build ipa -p',
        '\n🏆 Config fayllar dartdosh_config/ da create qilindi, Xo\'jayiin!\n👀 Tekshirib ko\'ring va ishlatishni boshlang!\n💡 Masalan: dartdosh build aab -s'
      ],
      LogType.configValidationFailed: [
        '❌ Config faylni tekshirishda xatolik, Xo\'jayiin!',
        '💥 Validatsiya xatosi, Xo\'jayiin!',
        '⚠️ Config faylni o\'qib bo\'lmadi, Xo\'jayiin!'
      ],
      LogType.configCreationFailed: [
        '❌ Config yaratishda xatolik, Xo\'jayiin!',
        '💥 Fayllarni yaratib bo\'lmadi, Xo\'jayiin!',
        '⚠️ Konfiguratsiya yaratilmadi, Xo\'jayiin!'
      ],
      LogType.configNotFound: [
        '❌ Config fayllar topilmadi! Iltimos avval \'dartdosh init\' ni run qiling, Xo\'jayiin!',
        '⚠️ Konfiguratsiya yo\'q! \'dartdosh init\' commandini ishga tushiring, Xo\'jayiin!',
        '📝 Config kerak! Birinchi \'dartdosh init\' qiling, Xo\'jayiin!'
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
      LogType.buildConfigCreated: [
        '\n📋 Boss, I created build_config.json for you!\n✅ Please review it and if correct, run the command again.\n💼 Ready to serve, Boss!',
        '\n📝 Build config ready, Boss!\n🔍 Check the config, then run again.\n🚀 Awaiting your command, Boss!',
        '\n✨ Default config created, Boss!\n📖 Review it and if suitable, execute the command again.\n⚡ Standing by, Boss!'
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
      LogType.uploadStarting: [
        '📤 Uploading IPA to App Store Connect, Boss...',
        '🚀 Transporter started, uploading IPA, Boss...',
        '⬆️ Upload process initiated, Boss...'
      ],
      LogType.uploadProgress: [
        '⏳ {progress}',
      ],
      LogType.uploadSuccess: [
        '✅ IPA successfully uploaded to App Store Connect, Boss!',
        '🎉 Upload complete! IPA is on App Store, Boss!',
        '🏆 File uploaded successfully, Boss!'
      ],
      LogType.uploadFailed: [
        '❌ IPA upload failed, Boss!',
        '💥 Upload unsuccessful, Boss!',
        '⚠️ Problem uploading file, Boss!'
      ],
      LogType.uploadCredentialsMissing: [
        '⚠️ Upload enabled but Apple ID or password missing, Boss!',
        '🔐 Credentials not found! Add Apple ID and password to build_config.json, Boss!',
        '⚡ Apple ID required for upload, Boss!'
      ],
      LogType.totalTime: [
        '⏱️  Total time: {time} seconds. I worked {time} seconds for you, Boss! 💪',
        '🎯 Process completed in {time} seconds. Saved your time, Boss! ⚡',
        '✨ Everything ready in {time} seconds! Happy to serve you, Boss! 🚀'
      ],
      LogType.initStarted: [
        '🚀 Configuring dartdosh, Boss...',
        '✨ Init process started, Boss...',
        '🔧 Checking configuration, Boss...'
      ],
      LogType.configCreated: [
        '✅ New config files created, Boss!',
        '📝 Configuration ready, Boss!',
        '🎉 Config files successfully created, Boss!'
      ],
      LogType.migrationStarted: [
        '🔄 Old build_config.json found, migrating to new structure, Boss...',
        '📦 Migration started, Boss...',
        '⚡ Copying data from old config, Boss...'
      ],
      LogType.migrationCompleted: [
        '✅ Migration successful! All data moved to new file, Boss!',
        '🎉 Old config migrated to new format, Boss!',
        '🏆 Migration done! Saved all data, Boss!'
      ],
      LogType.migrationFailed: [
        '❌ Migration failed, Boss!',
        '💥 Error reading old config, Boss!',
        '⚠️ Migration unsuccessful, Boss!'
      ],
      LogType.missingFieldAdded: [
        '✅ Missing field added: {field}, Boss!',
        '🔧 Updated: added {field}, Boss!',
        '📝 {field} - this data was missing, added it, Boss!'
      ],
      LogType.alreadyConfigured: [
        '✅ You have everything! Configuration complete, Boss!',
        '🎯 All ready, nothing missing, Boss!',
        '👌 Config complete, no additional data needed, Boss!'
      ],
      LogType.initCompleted: [
        '\n✅ Config files created in dartdosh_config/ folder, Boss!\n📝 Please check them first, then feel free to use!\n💡 Example: dartdosh build apk -p',
        '\n🎉 Configs ready in dartdosh_config/ folder, Boss!\n🔍 First review the files, then start building!\n💡 Example: dartdosh build ipa -p',
        '\n🏆 Config files created in dartdosh_config/, Boss!\n👀 Check them out and start using!\n💡 Example: dartdosh build aab -s'
      ],
      LogType.configValidationFailed: [
        '❌ Error validating config file, Boss!',
        '💥 Validation error, Boss!',
        '⚠️ Could not read config file, Boss!'
      ],
      LogType.configCreationFailed: [
        '❌ Error creating config, Boss!',
        '💥 Could not create files, Boss!',
        '⚠️ Configuration not created, Boss!'
      ],
      LogType.configNotFound: [
        '❌ Config files not found! Please run \'dartdosh init\' first, Boss!',
        '⚠️ No configuration! Run \'dartdosh init\' command, Boss!',
        '📝 Config needed! First run \'dartdosh init\', Boss!'
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
      LogType.buildConfigCreated: [
        '\n📋 Босс, создал build_config.json для тебя!\n✅ Пожалуйста, проверь и если всё верно, запусти команду снова.\n💼 Готов служить, Босс!',
        '\n📝 Build config готов, Босс!\n🔍 Проверь конфиг, затем запусти снова.\n🚀 Жду твоей команды, Босс!',
        '\n✨ Стандартный конфиг создан, Босс!\n📖 Просмотри и если подходит, выполни команду снова.\n⚡ На готове, Босс!'
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
      LogType.uploadStarting: [
        '📤 Загрузка IPA в App Store Connect, Босс...',
        '🚀 Transporter запущен, загружается IPA, Босс...',
        '⬆️ Процесс загрузки начат, Босс...'
      ],
      LogType.uploadProgress: [
        '⏳ {progress}',
      ],
      LogType.uploadSuccess: [
        '✅ IPA успешно загружен в App Store Connect, Босс!',
        '🎉 Загрузка завершена! IPA в App Store, Босс!',
        '🏆 Файл успешно загружен, Босс!'
      ],
      LogType.uploadFailed: [
        '❌ Загрузка IPA не удалась, Босс!',
        '💥 Загрузка неудачна, Босс!',
        '⚠️ Проблема с загрузкой файла, Босс!'
      ],
      LogType.uploadCredentialsMissing: [
        '⚠️ Загрузка включена, но Apple ID или пароль отсутствуют, Босс!',
        '🔐 Учётные данные не найдены! Добавьте Apple ID и пароль в build_config.json, Босс!',
        '⚡ Для загрузки требуется Apple ID, Босс!'
      ],
      LogType.totalTime: [
        '⏱️  Общее время: {time} секунд. Я работал {time} секунд для вас, Босс! 💪',
        '🎯 Процесс завершён за {time} секунд. Сэкономил ваше время, Босс! ⚡',
        '✨ Всё готово за {time} секунд! Рад служить вам, Босс! 🚀'
      ],
      LogType.initStarted: [
        '🚀 Настройка dartdosh, Босс...',
        '✨ Процесс init начат, Босс...',
        '🔧 Проверка конфигурации, Босс...'
      ],
      LogType.configCreated: [
        '✅ Созданы новые файлы конфигурации, Босс!',
        '📝 Конфигурация готова, Босс!',
        '🎉 Файлы конфигурации успешно созданы, Босс!'
      ],
      LogType.migrationStarted: [
        '🔄 Найден старый build_config.json, переход на новую структуру, Босс...',
        '📦 Начата миграция, Босс...',
        '⚡ Копирование данных из старой конфигурации, Босс...'
      ],
      LogType.migrationCompleted: [
        '✅ Миграция успешна! Все данные перенесены в новый файл, Босс!',
        '🎉 Старая конфигурация перенесена в новый формат, Босс!',
        '🏆 Миграция завершена! Сохранил все данные, Босс!'
      ],
      LogType.migrationFailed: [
        '❌ Миграция не удалась, Босс!',
        '💥 Ошибка чтения старой конфигурации, Босс!',
        '⚠️ Миграция неуспешна, Босс!'
      ],
      LogType.missingFieldAdded: [
        '✅ Добавлено отсутствующее поле: {field}, Босс!',
        '🔧 Обновлено: добавлено {field}, Босс!',
        '📝 {field} - эти данные отсутствовали, добавил, Босс!'
      ],
      LogType.alreadyConfigured: [
        '✅ У вас всё есть! Конфигурация полная, Босс!',
        '🎯 Всё готово, ничего не отсутствует, Босс!',
        '👌 Конфигурация полная, дополнительные данные не нужны, Босс!'
      ],
      LogType.initCompleted: [
        '\n✅ Файлы конфигурации созданы в папке dartdosh_config/, Босс!\n📝 Пожалуйста, сначала проверьте их, потом используйте!\n💡 Пример: dartdosh build apk -p',
        '\n🎉 Конфигурации готовы в папке dartdosh_config/, Босс!\n🔍 Сначала просмотрите файлы, затем начинайте сборку!\n💡 Пример: dartdosh build ipa -p',
        '\n🏆 Файлы конфигурации созданы в dartdosh_config/, Босс!\n👀 Проверьте их и начинайте использовать!\n💡 Пример: dartdosh build aab -s'
      ],
      LogType.configValidationFailed: [
        '❌ Ошибка проверки файла конфигурации, Босс!',
        '💥 Ошибка валидации, Босс!',
        '⚠️ Не удалось прочитать файл конфигурации, Босс!'
      ],
      LogType.configCreationFailed: [
        '❌ Ошибка создания конфигурации, Босс!',
        '💥 Не удалось создать файлы, Босс!',
        '⚠️ Конфигурация не создана, Босс!'
      ],
      LogType.configNotFound: [
        '❌ Файлы конфигурации не найдены! Пожалуйста, сначала выполните \'dartdosh init\', Босс!',
        '⚠️ Нет конфигурации! Запустите команду \'dartdosh init\', Босс!',
        '📝 Нужна конфигурация! Сначала выполните \'dartdosh init\', Босс!'
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
      String path = '',
      String progress = '',
      String time = '',
      String field = ''}) {
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
        .replaceAll('{path}', path)
        .replaceAll('{progress}', progress)
        .replaceAll('{time}', time)
        .replaceAll('{field}', field);

    String coloredMessage;
    switch (type) {
      case LogType.start:
      case LogType.initStarted:
      case LogType.migrationStarted:
        coloredMessage = _color(message, '34'); // Blue
        break;
      case LogType.step:
        coloredMessage = _color(message, '36'); // Cyan
        break;
      case LogType.success:
      case LogType.buildNumberIncremented:
      case LogType.fileSaved:
      case LogType.outputDirCreated:
      case LogType.uploadSuccess:
      case LogType.totalTime:
      case LogType.configCreated:
      case LogType.migrationCompleted:
      case LogType.alreadyConfigured:
      case LogType.initCompleted:
      case LogType.missingFieldAdded:
        coloredMessage = _color(message, '32'); // Green
        break;
      case LogType.error:
      case LogType.uploadFailed:
      case LogType.migrationFailed:
      case LogType.configValidationFailed:
      case LogType.configCreationFailed:
      case LogType.configNotFound:
        coloredMessage = _color(message, '31'); // Red
        break;
      case LogType.donation:
        coloredMessage = _color(message, '35'); // Magenta
        break;
      case LogType.info:
      case LogType.finished:
      case LogType.buildConfigIsNotExist:
      case LogType.buildConfigCreated:
      case LogType.running:
      case LogType.uploadStarting:
      case LogType.uploadProgress:
      case LogType.uploadCredentialsMissing:
        coloredMessage = _color(message, '33'); // Yellow
        break;
    }

    print(coloredMessage);
  }
}
