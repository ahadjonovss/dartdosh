/// Embedded translations for dartdosh CLI
///
/// These translations are used as fallback when JSON files are not found.
/// This ensures the CLI works even if translation files are missing.
library;

const Map<String, String> embeddedTranslations = {
  'uz': r'''
{
  "version": "1.0.0",
  "language": "uz",
  "metadata": {
    "name": "O'zbek tili",
    "native_name": "Uzbek",
    "contributors": ["ahadjonovss"]
  },
  "progress_tasks": {
    "starting": "Boshlanyapti...",
    "gradle": "Gradle ishlayapti...",
    "dependencies_downloading": "Dependencylar yuklanmoqda...",
    "dependencies_ready": "Dependencylar tayyor...",
    "compiling": "Flutter kodi kompilyatsiya qilinyapti...",
    "bundling": "Bundle yaratilmoqda...",
    "assembling": "APK/AAB yig'ilmoqda...",
    "signing": "Imzolanmoqda...",
    "finishing": "Tugallanmoqda...",
    "ready": "Tayyor!"
  },
  "log_types": {
    "start": {
      "variants": [
        "🚀 Boshlash: Build {target} ({env} mode), Xo'jayiin!",
        "✨ Tayyor tur: {target} build ishga tushdi ({env}), Xo'jayiin!",
        "🏁 Jarayon boshlandi: {target} ({env}), Xo'jayiin!"
      ]
    },
    "info": {
      "variants": []
    },
    "step": {
      "variants": [
        "🔧 {target} build bosqichi: Flutter komandalar bajarilmoqda, Xo'jayiin...",
        "⚙️ Jarayon: Build bosqichlari ishlamoqda, Xo'jayiin...",
        "🛠️ Step: {target} build jarayoni davom etmoqda, Xo'jayiin..."
      ]
    },
    "success": {
      "variants": [
        "✅ {target} build muvaffaqiyatli yakunlandi, Xo'jayiin!",
        "🎉 Ilova tayyor: {target} ({env}), Xo'jayiin!",
        "🏆 {target} build muvaffaqiyatli tugadi, Xo'jayiin!"
      ]
    },
    "error": {
      "variants": [
        "❌ {target} build xatolik yuz berdi, Xo'jayiin!",
        "💥 Nimadir noto'g'ri ketdi: {target} ({env}), Xo'jayiin!",
        "⚠️ Build bajarilmadi: {target} ({env}), Xo'jayiin!"
      ]
    },
    "finished": {
      "variants": []
    },
    "build_config_is_not_exist": {
      "variants": [
        "⚠️ Build config topilmadi, default yaratilmoqda, Xo'jayiin!",
        "📝 build_config.json yo'q, default config yaratdim, Xo'jayiin!",
        "ℹ️ Konfiguratsiya yaratilmoqda, Xo'jayiin!"
      ]
    },
    "build_config_created": {
      "variants": [
        "\n📋 Xo'jayiin, build_config.json yaratib qo'ydim!\n✅ Iltimos, tekshirib ko'ring va to'g'ri bo'lsa commandni qayta run qiling.\n💼 Xizmatizga tayyorman, Xo'jayiin!",
        "\n📝 Build config tayyor, Xo'jayiin!\n🔍 Configni tekshirib, keyin qayta ishga tushiring.\n🚀 Buyruq kutmoqdaman, Xo'jayiin!",
        "\n✨ Default config yaratdim, Xo'jayiin!\n📖 Ko'rib chiqing va mos bo'lsa, commandni qaytadan bajaring.\n⚡ Tayyor turaman, Xo'jayiin!"
      ]
    },
    "running": {
      "variants": [
        "🔄 Ishga tushirilmoqda: {command}, Xo'jayiin!",
        "⏳ Komanda bajarilmoqda: {command}, Xo'jayiin!",
        "🏃 Jarayon: {command}, Xo'jayiin!"
      ]
    },
    "donation": {
      "variants": [
        "\n☕ Xo'jayiin, agar dartdosh yoqsa, menga bir choy pul tashlang: https://www.tirikchilik.uz/ahadjonovss\n   Qahva ichib, yanada zo'r toollar yasayman! 😄",
        "\n💰 Xo'jayiin, bu tool foydali bo'lsa, bir gap emas, donat qilaverasiz: https://www.tirikchilik.uz/ahadjonovss\n   Bir gap qilsangiz, yangi featurelar chiqaraman! 🚀",
        "\n🎁 Xo'jayiin, dartdosh yordamchi bo'lyaptimi? Unda shu linkka bir nazar: https://www.tirikchilik.uz/ahadjonovss\n   Sponsor bo'ling, yanada kuchli qilib qo'yamiz! 💪",
        "\n🍕 Build tayyor bo'ldi, endi mening navbat! Pizza uchun yordam bersangiz: https://www.tirikchilik.uz/ahadjonovss\n   Coding bilan pizza - eng zo'r kombinatsiya! 🤩",
        "\n🤑 Xo'jayiin, bu tooldan foydalanib vaqtingizni tejadingizmi? Unda menga ham yordam qiling: https://www.tirikchilik.uz/ahadjonovss\n   Bitta kofe puli bo'lsa ham, ruhim ko'tariladi! ☕",
        "\n💝 Ey Xo'jayiin, dartdosh sizga yoqdimi? Quvontirdimmi? Unda bir donationcha: https://www.tirikchilik.uz/ahadjonovss\n   Katta pul emas, dildan keladigani yetarli! 😊",
        "\n🎯 Build muvaffaqiyatli! Endi meni ham unutmang: https://www.tirikchilik.uz/ahadjonovss\n   Sizning supportingiz bilan yanada zo'r toollar yaratamiz! 🔥",
        "\n🌟 Xo'jayiin, open source developer hayoti qiyin-ku! Yordam qo'lingizni cho'zing: https://www.tirikchilik.uz/ahadjonovss\n   Bir lagmon puli ham katta gap! 🍜",
        "\n🎊 Build tayyor, siz ham baxtli, men ham! Endi menga ham bir iltifoat: https://www.tirikchilik.uz/ahadjonovss\n   Support qilsangiz, keyingi versiya tezroq chiqadi! ⚡",
        "\n😎 Xo'jayiin, dartdosh sizning vaqtingizni tejaydimi? Unda mening vaqtimni ham qadrlang: https://www.tirikchilik.uz/ahadjonovss\n   Bir choynak choy puli kerak xolos! 🍵"
      ]
    },
    "build_number_incremented": {
      "variants": [
        "✅ Build number yangilandi: {oldBuild} → {newBuild}, Xo'jayiin!",
        "🔢 Build raqami ko'tarildi: {oldBuild} → {newBuild}, Xo'jayiin!",
        "📈 Yangi build number: {newBuild} (oldingi: {oldBuild}), Xo'jayiin!"
      ]
    },
    "file_saved": {
      "variants": [
        "✅ Build saqlandi: {path}, Xo'jayiin!",
        "💾 Fayl tayyor: {path}, Xo'jayiin!",
        "📦 Build muvaffaqiyatli ko'chirildi: {path}, Xo'jayiin!"
      ]
    },
    "output_dir_created": {
      "variants": [
        "📁 Output directory yaratildi: {path}, Xo'jayiin!",
        "🗂️ Yangi papka tuzildi: {path}, Xo'jayiin!",
        "✨ Output papka tayyor: {path}, Xo'jayiin!"
      ]
    },
    "upload_starting": {
      "variants": [
        "📤 IPA fayl App Store Connect ga yuklanmoqda, Xo'jayiin...",
        "🚀 Transporter ishga tushdi, IPA yuklanmoqda, Xo'jayiin...",
        "⬆️ Upload jarayoni boshlandi, Xo'jayiin..."
      ]
    },
    "upload_progress": {
      "variants": [
        "⏳ {progress}"
      ]
    },
    "upload_success": {
      "variants": [
        "✅ IPA muvaffaqiyatli App Store Connect ga yuklandi, Xo'jayiin!",
        "🎉 Upload tayyor! IPA App Store da, Xo'jayiin!",
        "🏆 Fayl muvaffaqiyatli yuklandi, Xo'jayiin!"
      ]
    },
    "upload_failed": {
      "variants": [
        "❌ IPA upload xatolik bilan yakunlandi, Xo'jayiin!",
        "💥 Upload muvaffaqiyatsiz, Xo'jayiin!",
        "⚠️ Faylni yuklashda muammo, Xo'jayiin!"
      ]
    },
    "upload_credentials_missing": {
      "variants": [
        "⚠️ Upload yoqilgan, lekin Apple ID yoki parol kiritilmagan, Xo'jayiin!",
        "🔐 Credentials topilmadi! build_config.json ga Apple ID va parol qo'shing, Xo'jayiin!",
        "⚡ Yuklash uchun Apple ID kerak, Xo'jayiin!"
      ]
    },
    "total_time": {
      "variants": [
        "⏱️  Umumiy vaqt: {time} soniya. Siz uchun {time} soniya mehnat qildim, Xo'jayiin! 💪",
        "🎯 Jarayon {time} soniyada tugadi. Vaqtingizni tejadim, Xo'jayiin! ⚡",
        "✨ {time} soniyada hammasi tayyor! Sizga xizmat qilish baxt, Xo'jayiin! 🚀"
      ]
    },
    "init_started": {
      "variants": [
        "🚀 Dartdosh konfiguratsiya qilinmoqda, Xo'jayiin...",
        "✨ Init jarayoni boshlandi, Xo'jayiin...",
        "🔧 Configuratsiya tekshirilmoqda, Xo'jayiin..."
      ]
    },
    "config_created": {
      "variants": [
        "✅ Yangi config fayllar yaratildi, Xo'jayiin!",
        "📝 Konfiguratsiya tayyor, Xo'jayiin!",
        "🎉 Config fayllar muvaffaqiyatli yaratildi, Xo'jayiin!"
      ]
    },
    "config_validation_failed": {
      "variants": [
        "❌ Config faylni tekshirishda xatolik, Xo'jayiin!",
        "💥 Validatsiya xatosi, Xo'jayiin!",
        "⚠️ Config faylni o'qib bo'lmadi, Xo'jayiin!"
      ]
    },
    "config_creation_failed": {
      "variants": [
        "❌ Config yaratishda xatolik, Xo'jayiin!",
        "💥 Fayllarni yaratib bo'lmadi, Xo'jayiin!",
        "⚠️ Konfiguratsiya yaratilmadi, Xo'jayiin!"
      ]
    },
    "migration_started": {
      "variants": [
        "🔄 Eski build_config.json topildi, yangi strukturaga o'tkazilmoqda, Xo'jayiin...",
        "📦 Migration boshlandi, Xo'jayiin...",
        "⚡ Eski configdan ma'lumotlar ko'chirilmoqda, Xo'jayiin..."
      ]
    },
    "migration_completed": {
      "variants": [
        "✅ Migration muvaffaqiyatli! Barcha ma'lumotlar yangi faylga ko'chirildi, Xo'jayiin!",
        "🎉 Eski config yangi formatga o'tkazildi, Xo'jayiin!",
        "🏆 Migration tayyor! Hamma data saqlab qoldim, Xo'jayiin!"
      ]
    },
    "migration_failed": {
      "variants": [
        "❌ Migration xatolik bilan yakunlandi, Xo'jayiin!",
        "💥 Eski configni o'qishda muammo, Xo'jayiin!",
        "⚠️ Migration amalga oshmadi, Xo'jayiin!"
      ]
    },
    "missing_field_added": {
      "variants": [
        "✅ Yetishmayotgan maydon qo'shildi: {field}, Xo'jayiin!",
        "🔧 Yangilandi: {field} qo'shib qo'ydim, Xo'jayiin!",
        "📝 {field} - mana bu data yo'q ekan, qo'shib qo'ydim, Xo'jayiin!"
      ]
    },
    "already_configured": {
      "variants": [
        "✅ Sizda hammasi bor ekan! Konfiguratsiya to'liq, Xo'jayiin!",
        "🎯 Hammasi tayyor, hech narsa etishmayapti, Xo'jayiin!",
        "👌 Config to'liq, qo'shimcha narsa kerak emas, Xo'jayiin!"
      ]
    },
    "init_completed": {
      "variants": [
        "\n✅ Configlar dartdosh_config/ papkasida yaratildi, Xo'jayiin!\n📝 Iltimos avval bir tekshiring, keyin bemalol ishlatishingiz mumkin!\n💡 Masalan: dartdosh build apk -p",
        "\n🎉 dartdosh_config/ papkasida configlar tayyor, Xo'jayiin!\n🔍 Birinchi fayllarni ko'zdan kechiring, keyin build boshlashingiz mumkin!\n💡 Misol: dartdosh build ipa -p",
        "\n🏆 Config fayllar dartdosh_config/ da create qilindi, Xo'jayiin!\n👀 Tekshirib ko'ring va ishlatishni boshlang!\n💡 Masalan: dartdosh build aab -s"
      ]
    },
    "config_not_found": {
      "variants": [
        "❌ Config fayllar topilmadi! Iltimos avval 'dartdosh init' ni run qiling, Xo'jayiin!",
        "⚠️ Konfiguratsiya yo'q! 'dartdosh init' commandini ishga tushiring, Xo'jayiin!",
        "📝 Config kerak! Birinchi 'dartdosh init' qiling, Xo'jayiin!"
      ]
    },
    "version_show": {
      "variants": [
        "🎯 Sizdahoz DartDosh {version} versiya ekan, Xo'jayiin!",
        "✨ {version} versiya ishlamoqda, Xo'jayiin!",
        "🚀 DartDosh {version} - ajoyib versiya, Xo'jayiin!"
      ]
    },
    "version_checking": {
      "variants": [
        "🔍 Yangilanishlar tekshirilmoqda, Xo'jayiin...",
        "📡 Serverga ulanmoqda, Xo'jayiin...",
        "🔎 Update bor yo'qligini ko'raylik, Xo'jayiin..."
      ]
    },
    "version_update_available": {
      "variants": [
        "🎉 Xo'jayiin, hozir {latest} versiya chiqibti!",
        "✨ Yangi {latest} versiya bor ekan, Xo'jayiin!",
        "🚀 Ajoyib! {latest} versiya tayyor, Xo'jayiin!"
      ]
    },
    "version_current_info": {
      "variants": [
        "📦 Sizda hozir {version} versiya bor"
      ]
    },
    "version_upgrade_hint": {
      "variants": [
        "💡 Yangilash uchun mana bu commandni yozing: dartdosh upgrade"
      ]
    },
    "version_up_to_date": {
      "variants": [
        "✅ Update yo'q ekan, sizda eng oxirgi versiya, Xo'jayiin!",
        "🎯 Yangilanish kerak emas, eng yangi versiya ishlamoqda, Xo'jayiin!",
        "👌 Hammasi zo'r! Sizda eng so'nggi versiya bor, Xo'jayiin!"
      ]
    },
    "version_server_error": {
      "variants": [
        "❌ Serverga ulanib bo'lmadi, Xo'jayiin!"
      ]
    },
    "version_upgrading": {
      "variants": [
        "🚀 Upgrade boshlandi, Xo'jayiin...",
        "⬆️ Yangilanmoqda, biroz sabr qiling Xo'jayiin...",
        "✨ Eng yangi versiyaga o'tilmoqda, Xo'jayiin..."
      ]
    },
    "version_upgrade_success": {
      "variants": [
        "🎉 {oldVersion} → {newVersion}. Endi bemalol maqtanib yursangiz bo'ladi, Xo'jayiin!",
        "✅ Zo'r! {oldVersion} dan {newVersion} ga yangilandi. Maqtaning mumkin endi, Xo'jayiin!",
        "🏆 Ajoyib! Versiya {newVersion} ga o'tdi. Do'stlaringizga aytib yurasiz, Xo'jayiin!",
        "🚀 Tayyor! {oldVersion} → {newVersion}. Endi hammasidan oldinda turibsiz, Xo'jayiin!"
      ]
    },
    "version_upgrade_failed": {
      "variants": [
        "❌ Yangilanmadi! Internetni tekshiring, Xo'jayiin!"
      ]
    },
    "version_downgrading": {
      "variants": [
        "⬇️ {version} versiyaga qaytilmoqda, Xo'jayiin..."
      ]
    },
    "version_downgrading_previous": {
      "variants": [
        "⬇️ Oldingi versiyaga qaytilmoqda, Xo'jayiin..."
      ]
    },
    "version_downgrade_success": {
      "variants": [
        "✅ {oldVersion} dan {newVersion} ga qaytarildi, Xo'jayiin!",
        "🎯 Tayyor! Versiya {newVersion} ga o'rnatildi, Xo'jayiin!",
        "👌 Downgrade tugadi! Endi {newVersion} versiyada, Xo'jayiin!"
      ]
    },
    "version_downgrade_failed": {
      "variants": [
        "❌ Orqaga qaytarilmadi! Versiya topilmadi, Xo'jayiin!"
      ]
    },
    "firebase_upload_missing_app_id": {
      "variants": [
        "⚠️ Firebase App ID kiritilmagan, Xo'jayiin!"
      ]
    },
    "firebase_upload_starting": {
      "variants": [
        "📤 APK Firebase App Distribution ga yuklanmoqda, Xo'jayiin..."
      ]
    },
    "firebase_upload_success": {
      "variants": [
        "✅ APK muvaffaqiyatli Firebase ga yuklandi, Xo'jayiin!"
      ]
    },
    "firebase_upload_failed": {
      "variants": [
        "❌ Firebase ga yuklashda xatolik, Xo'jayiin!"
      ]
    },
    "telegram_upload_starting": {
      "variants": [
        "✈️ APK Telegram kanaliga yuklanmoqda, Xo'jayiin...",
        "📲 APK MTProto orqali Telegram ga jo'natilmoqda, Xo'jayiin...",
        "🚀 Telegram yuklanishi boshlandi, Xo'jayiin..."
      ]
    },
    "telegram_upload_success": {
      "variants": [
        "✅ APK muvaffaqiyatli Telegram kanaliga yuklandi, Xo'jayiin!",
        "🎉 Telegram yuklanishi tugadi! APK kanalda, Xo'jayiin!",
        "🏆 APK Telegram ga muvaffaqiyatli yuklandi, Xo'jayiin!"
      ]
    },
    "telegram_upload_failed": {
      "variants": [
        "❌ Telegram ga yuklashda xatolik, Xo'jayiin!",
        "💥 APK ni Telegram ga yuborib bo'lmadi, Xo'jayiin!",
        "⚠️ Telegram yuklanishi muvaffaqiyatsiz, Xo'jayiin!"
      ]
    },
    "telegram_upload_missing_chat_id": {
      "variants": [
        "⚠️ Bu environment uchun build_config.json da chat_id ko'rsatilmagan, Xo'jayiin!",
        "🔐 build_config.json da bu environment uchun chat_id topilmadi, Xo'jayiin!"
      ]
    },
    "telegram_upload_python_not_found": {
      "variants": [
        "❌ Python 3 topilmadi! Telegram upload uchun Python 3 o'rnating, Xo'jayiin!",
        "⚠️ Telegram upload Python 3 talab qiladi. Avval o'rnating, Xo'jayiin!"
      ]
    },
    "telegram_upload_telethon_not_found": {
      "variants": [
        "❌ telethon topilmadi! Buyruq: pip install telethon, Xo'jayiin!",
        "⚠️ Telegram upload telethon talab qiladi. O'rnating: pip3 install telethon, Xo'jayiin!"
      ]
    },
    "clean_started": {
      "variants": [
        "🗑️ {target} fayllar tozalanmoqda...",
        "🧹 {target} build fayllar o'chirilmoqda, Xo'jayiin...",
        "♻️ {target} tozalanmoqda, Xo'jayiin..."
      ]
    },
    "clean_success": {
      "variants": [
        "✅ Tayyor! {file} ta fayl o'chirildi, {path} bo'shadi, Xo'jayiin!",
        "🎉 Tozalandi! {file} ta fayl o'chirildi, {path} tejaldi, Xo'jayiin!",
        "🏆 {file} ta fayl o'chirildi — {path} bo'shatildi, Xo'jayiin!"
      ]
    },
    "clean_nothing_to_delete": {
      "variants": [
        "ℹ️ O'chiriladigan fayl yo'q, Xo'jayiin!",
        "✨ Allaqachon toza — fayl topilmadi, Xo'jayiin!",
        "👌 Bu yerda o'chiriladigan narsa yo'q, Xo'jayiin!"
      ]
    },
    "clean_output_path_not_configured": {
      "variants": [
        "❌ build_config.json da output_path ko'rsatilmagan, Xo'jayiin!",
        "⚠️ output_path yo'q — avval build_config.json ga qo'shing, Xo'jayiin!"
      ]
    }
  }
}

''',
  'en': r'''
{
  "version": "1.0.0",
  "language": "en",
  "metadata": {
    "name": "English",
    "native_name": "English",
    "contributors": ["ahadjonovss"]
  },
  "progress_tasks": {
    "starting": "Starting...",
    "gradle": "Running Gradle...",
    "dependencies_downloading": "Downloading dependencies...",
    "dependencies_ready": "Dependencies ready...",
    "compiling": "Compiling Flutter code...",
    "bundling": "Creating bundle...",
    "assembling": "Assembling APK/AAB...",
    "signing": "Signing...",
    "finishing": "Finishing...",
    "ready": "Ready!"
  },
  "log_types": {
    "start": {
      "variants": [
        "🚀 Starting: Build {target} ({env} mode), Boss!",
        "✨ Ready: {target} build started ({env}), Boss!",
        "🏁 Process started: {target} ({env}), Boss!"
      ]
    },
    "info": {
      "variants": []
    },
    "step": {
      "variants": [
        "🔧 {target} build step: Running Flutter commands, Boss...",
        "⚙️ Process: Build steps in progress, Boss...",
        "🛠️ Step: {target} build process ongoing, Boss..."
      ]
    },
    "success": {
      "variants": [
        "✅ {target} build completed successfully, Boss!",
        "🎉 App ready: {target} ({env}), Boss!",
        "🏆 {target} build finished successfully, Boss!"
      ]
    },
    "error": {
      "variants": [
        "❌ {target} build failed, Boss!",
        "💥 Something went wrong: {target} ({env}), Boss!",
        "⚠️ Build failed: {target} ({env}), Boss!"
      ]
    },
    "finished": {
      "variants": []
    },
    "build_config_is_not_exist": {
      "variants": [
        "⚠️ Build config not found, creating default, Boss!",
        "📝 build_config.json missing, created default config, Boss!",
        "ℹ️ Creating configuration, Boss!"
      ]
    },
    "build_config_created": {
      "variants": [
        "\n📋 Boss, I created build_config.json for you!\n✅ Please review it and if correct, run the command again.\n💼 Ready to serve, Boss!",
        "\n📝 Build config ready, Boss!\n🔍 Check the config, then run again.\n🚀 Awaiting your command, Boss!",
        "\n✨ Default config created, Boss!\n📖 Review it and if suitable, execute the command again.\n⚡ Standing by, Boss!"
      ]
    },
    "running": {
      "variants": [
        "🔄 Running: {command}, Boss!",
        "⏳ Executing command: {command}, Boss!",
        "🏃 Process: {command}, Boss!"
      ]
    },
    "donation": {
      "variants": [
        "\n☕ Boss, if you like dartdosh, buy me a coffee: https://www.tirikchilik.uz/ahadjonovss\n   I'll make even better tools! 😄",
        "\n💰 Boss, if this tool is useful, consider donating: https://www.tirikchilik.uz/ahadjonovss\n   Your support brings new features! 🚀",
        "\n🎁 Boss, is dartdosh helpful? Check out this link: https://www.tirikchilik.uz/ahadjonovss\n   Become a sponsor, let's make it even better! 💪",
        "\n🍕 Build ready, now it's my turn! Help me get pizza: https://www.tirikchilik.uz/ahadjonovss\n   Coding with pizza - best combo! 🤩",
        "\n🤑 Boss, did this tool save you time? Help me too: https://www.tirikchilik.uz/ahadjonovss\n   Even a coffee would brighten my day! ☕",
        "\n💝 Hey Boss, do you like dartdosh? Made you happy? Then donate: https://www.tirikchilik.uz/ahadjonovss\n   Not much needed, whatever comes from heart! 😊",
        "\n🎯 Build successful! Don't forget about me: https://www.tirikchilik.uz/ahadjonovss\n   Your support helps create better tools! 🔥",
        "\n🌟 Boss, open source dev life is tough! Lend a hand: https://www.tirikchilik.uz/ahadjonovss\n   Even small support means a lot! 🍜",
        "\n🎊 Build ready, you're happy, me too! Now treat me: https://www.tirikchilik.uz/ahadjonovss\n   Support brings faster updates! ⚡",
        "\n😎 Boss, does dartdosh save your time? Value mine too: https://www.tirikchilik.uz/ahadjonovss\n   Just enough for tea! 🍵"
      ]
    },
    "build_number_incremented": {
      "variants": [
        "✅ Build number updated: {oldBuild} → {newBuild}, Boss!",
        "🔢 Build number incremented: {oldBuild} → {newBuild}, Boss!",
        "📈 New build number: {newBuild} (previous: {oldBuild}), Boss!"
      ]
    },
    "file_saved": {
      "variants": [
        "✅ Build saved: {path}, Boss!",
        "💾 File ready: {path}, Boss!",
        "📦 Build successfully moved: {path}, Boss!"
      ]
    },
    "output_dir_created": {
      "variants": [
        "📁 Output directory created: {path}, Boss!",
        "🗂️ New folder created: {path}, Boss!",
        "✨ Output folder ready: {path}, Boss!"
      ]
    },
    "upload_starting": {
      "variants": [
        "📤 Uploading IPA to App Store Connect, Boss...",
        "🚀 Transporter started, uploading IPA, Boss...",
        "⬆️ Upload process initiated, Boss..."
      ]
    },
    "upload_progress": {
      "variants": [
        "⏳ {progress}"
      ]
    },
    "upload_success": {
      "variants": [
        "✅ IPA successfully uploaded to App Store Connect, Boss!",
        "🎉 Upload complete! IPA is on App Store, Boss!",
        "🏆 File uploaded successfully, Boss!"
      ]
    },
    "upload_failed": {
      "variants": [
        "❌ IPA upload failed, Boss!",
        "💥 Upload unsuccessful, Boss!",
        "⚠️ Problem uploading file, Boss!"
      ]
    },
    "upload_credentials_missing": {
      "variants": [
        "⚠️ Upload enabled but Apple ID or password missing, Boss!",
        "🔐 Credentials not found! Add Apple ID and password to build_config.json, Boss!",
        "⚡ Apple ID required for upload, Boss!"
      ]
    },
    "total_time": {
      "variants": [
        "⏱️  Total time: {time} seconds. I worked {time} seconds for you, Boss! 💪",
        "🎯 Process completed in {time} seconds. Saved your time, Boss! ⚡",
        "✨ Everything ready in {time} seconds! Happy to serve you, Boss! 🚀"
      ]
    },
    "init_started": {
      "variants": [
        "🚀 Configuring dartdosh, Boss...",
        "✨ Init process started, Boss...",
        "🔧 Checking configuration, Boss..."
      ]
    },
    "config_created": {
      "variants": [
        "✅ New config files created, Boss!",
        "📝 Configuration ready, Boss!",
        "🎉 Config files successfully created, Boss!"
      ]
    },
    "config_validation_failed": {
      "variants": [
        "❌ Error validating config file, Boss!",
        "💥 Validation error, Boss!",
        "⚠️ Could not read config file, Boss!"
      ]
    },
    "config_creation_failed": {
      "variants": [
        "❌ Error creating config, Boss!",
        "💥 Could not create files, Boss!",
        "⚠️ Configuration not created, Boss!"
      ]
    },
    "migration_started": {
      "variants": [
        "🔄 Old build_config.json found, migrating to new structure, Boss...",
        "📦 Migration started, Boss...",
        "⚡ Copying data from old config, Boss..."
      ]
    },
    "migration_completed": {
      "variants": [
        "✅ Migration successful! All data moved to new file, Boss!",
        "🎉 Old config migrated to new format, Boss!",
        "🏆 Migration done! Saved all data, Boss!"
      ]
    },
    "migration_failed": {
      "variants": [
        "❌ Migration failed, Boss!",
        "💥 Error reading old config, Boss!",
        "⚠️ Migration unsuccessful, Boss!"
      ]
    },
    "missing_field_added": {
      "variants": [
        "✅ Missing field added: {field}, Boss!",
        "🔧 Updated: added {field}, Boss!",
        "📝 {field} - this data was missing, added it, Boss!"
      ]
    },
    "already_configured": {
      "variants": [
        "✅ You have everything! Configuration complete, Boss!",
        "🎯 All ready, nothing missing, Boss!",
        "👌 Config complete, no additional data needed, Boss!"
      ]
    },
    "init_completed": {
      "variants": [
        "\n✅ Config files created in dartdosh_config/ folder, Boss!\n📝 Please check them first, then feel free to use!\n💡 Example: dartdosh build apk -p",
        "\n🎉 Configs ready in dartdosh_config/ folder, Boss!\n🔍 First review the files, then start building!\n💡 Example: dartdosh build ipa -p",
        "\n🏆 Config files created in dartdosh_config/, Boss!\n👀 Check them out and start using!\n💡 Example: dartdosh build aab -s"
      ]
    },
    "config_not_found": {
      "variants": [
        "❌ Config files not found! Please run 'dartdosh init' first, Boss!",
        "⚠️ No configuration! Run 'dartdosh init' command, Boss!",
        "📝 Config needed! First run 'dartdosh init', Boss!"
      ]
    },
    "version_show": {
      "variants": [
        "🎯 You have DartDosh version {version}, Boss!",
        "✨ Version {version} is running, Boss!",
        "🚀 DartDosh {version} - awesome version, Boss!"
      ]
    },
    "version_checking": {
      "variants": [
        "🔍 Checking for updates, Boss...",
        "📡 Connecting to server, Boss...",
        "🔎 Let's see if there's an update, Boss..."
      ]
    },
    "version_update_available": {
      "variants": [
        "🎉 Boss, version {latest} is out now!",
        "✨ New version {latest} available, Boss!",
        "🚀 Great! Version {latest} is ready, Boss!"
      ]
    },
    "version_current_info": {
      "variants": [
        "📦 You currently have version {version}"
      ]
    },
    "version_upgrade_hint": {
      "variants": [
        "💡 To upgrade, write this command: dartdosh upgrade"
      ]
    },
    "version_up_to_date": {
      "variants": [
        "✅ No update, you have the latest version, Boss!",
        "🎯 No update needed, latest version running, Boss!",
        "👌 All good! You have the latest version, Boss!"
      ]
    },
    "version_server_error": {
      "variants": [
        "❌ Could not connect to server, Boss!"
      ]
    },
    "version_upgrading": {
      "variants": [
        "🚀 Upgrade started, Boss...",
        "⬆️ Upgrading, please wait Boss...",
        "✨ Moving to latest version, Boss..."
      ]
    },
    "version_upgrade_success": {
      "variants": [
        "🎉 {oldVersion} → {newVersion}. Now you can brag about it, Boss!",
        "✅ Great! Upgraded from {oldVersion} to {newVersion}. You can show off now, Boss!",
        "🏆 Awesome! Version is now {newVersion}. Tell your friends, Boss!",
        "🚀 Done! {oldVersion} → {newVersion}. Now you're ahead of everyone, Boss!"
      ]
    },
    "version_upgrade_failed": {
      "variants": [
        "❌ Upgrade failed! Check your internet, Boss!"
      ]
    },
    "version_downgrading": {
      "variants": [
        "⬇️ Downgrading to {version}, Boss..."
      ]
    },
    "version_downgrading_previous": {
      "variants": [
        "⬇️ Downgrading to previous version, Boss..."
      ]
    },
    "version_downgrade_success": {
      "variants": [
        "✅ Downgraded from {oldVersion} to {newVersion}, Boss!",
        "🎯 Done! Version set to {newVersion}, Boss!",
        "👌 Downgrade complete! Now on version {newVersion}, Boss!"
      ]
    },
    "version_downgrade_failed": {
      "variants": [
        "❌ Downgrade failed! Version not found, Boss!"
      ]
    },
    "firebase_upload_missing_app_id": {
      "variants": [
        "⚠️ Firebase App ID missing, Boss!"
      ]
    },
    "firebase_upload_starting": {
      "variants": [
        "📤 Uploading APK to Firebase App Distribution, Boss..."
      ]
    },
    "firebase_upload_success": {
      "variants": [
        "✅ APK successfully uploaded to Firebase, Boss!"
      ]
    },
    "firebase_upload_failed": {
      "variants": [
        "❌ Firebase upload failed, Boss!"
      ]
    },
    "telegram_upload_starting": {
      "variants": [
        "✈️ Uploading APK to Telegram channel, Boss...",
        "📲 Sending APK via Telegram MTProto, Boss...",
        "🚀 Telegram upload started, Boss..."
      ]
    },
    "telegram_upload_success": {
      "variants": [
        "✅ APK successfully sent to Telegram channel, Boss!",
        "🎉 Telegram upload complete! APK is in the channel, Boss!",
        "🏆 APK uploaded to Telegram successfully, Boss!"
      ]
    },
    "telegram_upload_failed": {
      "variants": [
        "❌ Telegram upload failed, Boss!",
        "💥 Could not send APK to Telegram, Boss!",
        "⚠️ Telegram upload unsuccessful, Boss!"
      ]
    },
    "telegram_upload_missing_chat_id": {
      "variants": [
        "⚠️ Telegram chat_id missing for this environment in build_config.json, Boss!",
        "🔐 No chat_id configured for this environment in build_config.json, Boss!"
      ]
    },
    "telegram_upload_python_not_found": {
      "variants": [
        "❌ Python 3 not found! Install Python 3 to use Telegram upload, Boss!",
        "⚠️ Telegram upload requires Python 3. Please install it first, Boss!"
      ]
    },
    "telegram_upload_telethon_not_found": {
      "variants": [
        "❌ telethon not found! Run: pip install telethon, Boss!",
        "⚠️ Telegram upload requires telethon. Install it with: pip3 install telethon, Boss!"
      ]
    },
    "clean_started": {
      "variants": [
        "🗑️ Cleaning {target}...",
        "🧹 Removing {target} build files, Boss...",
        "♻️ Clearing {target}, Boss..."
      ]
    },
    "clean_success": {
      "variants": [
        "✅ Done! {file} file(s) deleted, {path} freed, Boss!",
        "🎉 Cleaned up! Removed {file} file(s), saved {path}, Boss!",
        "🏆 {file} file(s) deleted — {path} freed, Boss!"
      ]
    },
    "clean_nothing_to_delete": {
      "variants": [
        "ℹ️ Nothing to delete, Boss!",
        "✨ Already clean — no files found, Boss!",
        "👌 Nothing here to remove, Boss!"
      ]
    },
    "clean_output_path_not_configured": {
      "variants": [
        "❌ output_path is not configured in build_config.json, Boss!",
        "⚠️ No output_path set — add it to build_config.json first, Boss!"
      ]
    }
  }
}

''',
  'ru': r'''
{
  "version": "1.0.0",
  "language": "ru",
  "metadata": {
    "name": "Русский язык",
    "native_name": "Russian",
    "contributors": ["ahadjonovss"]
  },
  "progress_tasks": {
    "starting": "Начинается...",
    "gradle": "Запуск Gradle...",
    "dependencies_downloading": "Загрузка зависимостей...",
    "dependencies_ready": "Зависимости готовы...",
    "compiling": "Компиляция кода Flutter...",
    "bundling": "Создание bundle...",
    "assembling": "Сборка APK/AAB...",
    "signing": "Подписывается...",
    "finishing": "Завершается...",
    "ready": "Готово!"
  },
  "log_types": {
    "start": {
      "variants": [
        "🚀 Начало: Сборка {target} (режим {env}), Босс!",
        "✨ Готово: запущена сборка {target} ({env}), Босс!",
        "🏁 Процесс начат: {target} ({env}), Босс!"
      ]
    },
    "info": {
      "variants": []
    },
    "step": {
      "variants": [
        "🔧 Шаг сборки {target}: выполняются команды Flutter, Босс...",
        "⚙️ Процесс: идут этапы сборки, Босс...",
        "🛠️ Шаг: процесс сборки {target} продолжается, Босс..."
      ]
    },
    "success": {
      "variants": [
        "✅ Сборка {target} успешно завершена, Босс!",
        "🎉 Приложение готово: {target} ({env}), Босс!",
        "🏆 Сборка {target} успешно завершена, Босс!"
      ]
    },
    "error": {
      "variants": [
        "❌ Ошибка сборки {target}, Босс!",
        "💥 Что-то пошло не так: {target} ({env}), Босс!",
        "⚠️ Сборка не удалась: {target} ({env}), Босс!"
      ]
    },
    "finished": {
      "variants": []
    },
    "build_config_is_not_exist": {
      "variants": [
        "⚠️ Конфиг сборки не найден, создаю стандартный, Босс!",
        "📝 build_config.json отсутствует, создал стандартный конфиг, Босс!",
        "ℹ️ Создаю конфигурацию, Босс!"
      ]
    },
    "build_config_created": {
      "variants": [
        "\n📋 Босс, создал build_config.json для тебя!\n✅ Пожалуйста, проверь и если всё верно, запусти команду снова.\n💼 Готов служить, Босс!",
        "\n📝 Build config готов, Босс!\n🔍 Проверь конфиг, затем запусти снова.\n🚀 Жду твоей команды, Босс!",
        "\n✨ Стандартный конфиг создан, Босс!\n📖 Просмотри и если подходит, выполни команду снова.\n⚡ На готове, Босс!"
      ]
    },
    "running": {
      "variants": [
        "🔄 Запуск: {command}, Босс!",
        "⏳ Выполняется команда: {command}, Босс!",
        "🏃 Процесс: {command}, Босс!"
      ]
    },
    "donation": {
      "variants": [
        "\n☕ Босс, если dartdosh нравится, купи мне кофе: https://www.tirikchilik.uz/ahadjonovss\n   Сделаю ещё лучшие инструменты! 😄",
        "\n💰 Босс, если инструмент полезен, поддержи донатом: https://www.tirikchilik.uz/ahadjonovss\n   Твоя поддержка приносит новые фичи! 🚀",
        "\n🎁 Босс, dartdosh помогает? Загляни по ссылке: https://www.tirikchilik.uz/ahadjonovss\n   Стань спонсором, сделаем ещё круче! 💪",
        "\n🍕 Сборка готова, теперь моя очередь! Помоги с пиццей: https://www.tirikchilik.uz/ahadjonovss\n   Код с пиццей - лучшее комбо! 🤩",
        "\n🤑 Босс, инструмент сэкономил время? Помоги и мне: https://www.tirikchilik.uz/ahadjonovss\n   Даже кофе поднимет настроение! ☕",
        "\n💝 Эй Босс, нравится dartdosh? Порадовал? Тогда задонать: https://www.tirikchilik.uz/ahadjonovss\n   Много не нужно, сколько от души! 😊",
        "\n🎯 Сборка успешна! Не забудь про меня: https://www.tirikchilik.uz/ahadjonovss\n   Твоя поддержка создаёт лучшие инструменты! 🔥",
        "\n🌟 Босс, жизнь open source разработчика тяжела! Протяни руку: https://www.tirikchilik.uz/ahadjonovss\n   Даже малая поддержка важна! 🍜",
        "\n🎊 Сборка готова, ты счастлив, я тоже! Теперь угости меня: https://www.tirikchilik.uz/ahadjonovss\n   Поддержка ускоряет обновления! ⚡",
        "\n😎 Босс, dartdosh экономит время? Цени и моё: https://www.tirikchilik.uz/ahadjonovss\n   Хватит на чай! 🍵"
      ]
    },
    "build_number_incremented": {
      "variants": [
        "✅ Build number обновлён: {oldBuild} → {newBuild}, Босс!",
        "🔢 Build number увеличен: {oldBuild} → {newBuild}, Босс!",
        "📈 Новый build number: {newBuild} (предыдущий: {oldBuild}), Босс!"
      ]
    },
    "file_saved": {
      "variants": [
        "✅ Сборка сохранена: {path}, Босс!",
        "💾 Файл готов: {path}, Босс!",
        "📦 Сборка успешно перемещена: {path}, Босс!"
      ]
    },
    "output_dir_created": {
      "variants": [
        "📁 Выходная папка создана: {path}, Босс!",
        "🗂️ Новая папка создана: {path}, Босс!",
        "✨ Выходная папка готова: {path}, Босс!"
      ]
    },
    "upload_starting": {
      "variants": [
        "📤 Загрузка IPA в App Store Connect, Босс...",
        "🚀 Transporter запущен, загружается IPA, Босс...",
        "⬆️ Процесс загрузки начат, Босс..."
      ]
    },
    "upload_progress": {
      "variants": [
        "⏳ {progress}"
      ]
    },
    "upload_success": {
      "variants": [
        "✅ IPA успешно загружен в App Store Connect, Босс!",
        "🎉 Загрузка завершена! IPA в App Store, Босс!",
        "🏆 Файл успешно загружен, Босс!"
      ]
    },
    "upload_failed": {
      "variants": [
        "❌ Загрузка IPA не удалась, Босс!",
        "💥 Загрузка неудачна, Босс!",
        "⚠️ Проблема с загрузкой файла, Босс!"
      ]
    },
    "upload_credentials_missing": {
      "variants": [
        "⚠️ Загрузка включена, но Apple ID или пароль отсутствуют, Босс!",
        "🔐 Учётные данные не найдены! Добавьте Apple ID и пароль в build_config.json, Босс!",
        "⚡ Для загрузки требуется Apple ID, Босс!"
      ]
    },
    "total_time": {
      "variants": [
        "⏱️  Общее время: {time} секунд. Я работал {time} секунд для вас, Босс! 💪",
        "🎯 Процесс завершён за {time} секунд. Сэкономил ваше время, Босс! ⚡",
        "✨ Всё готово за {time} секунд! Рад служить вам, Босс! 🚀"
      ]
    },
    "init_started": {
      "variants": [
        "🚀 Настройка dartdosh, Босс...",
        "✨ Процесс init начат, Босс...",
        "🔧 Проверка конфигурации, Босс..."
      ]
    },
    "config_created": {
      "variants": [
        "✅ Созданы новые файлы конфигурации, Босс!",
        "📝 Конфигурация готова, Босс!",
        "🎉 Файлы конфигурации успешно созданы, Босс!"
      ]
    },
    "config_validation_failed": {
      "variants": [
        "❌ Ошибка проверки файла конфигурации, Босс!",
        "💥 Ошибка валидации, Босс!",
        "⚠️ Не удалось прочитать файл конфигурации, Босс!"
      ]
    },
    "config_creation_failed": {
      "variants": [
        "❌ Ошибка создания конфигурации, Босс!",
        "💥 Не удалось создать файлы, Босс!",
        "⚠️ Конфигурация не создана, Босс!"
      ]
    },
    "migration_started": {
      "variants": [
        "🔄 Найден старый build_config.json, переход на новую структуру, Босс...",
        "📦 Начата миграция, Босс...",
        "⚡ Копирование данных из старой конфигурации, Босс..."
      ]
    },
    "migration_completed": {
      "variants": [
        "✅ Миграция успешна! Все данные перенесены в новый файл, Босс!",
        "🎉 Старая конфигурация перенесена в новый формат, Босс!",
        "🏆 Миграция завершена! Сохранил все данные, Босс!"
      ]
    },
    "migration_failed": {
      "variants": [
        "❌ Миграция не удалась, Босс!",
        "💥 Ошибка чтения старой конфигурации, Босс!",
        "⚠️ Миграция неуспешна, Босс!"
      ]
    },
    "missing_field_added": {
      "variants": [
        "✅ Добавлено отсутствующее поле: {field}, Босс!",
        "🔧 Обновлено: добавлено {field}, Босс!",
        "📝 {field} - эти данные отсутствовали, добавил, Босс!"
      ]
    },
    "already_configured": {
      "variants": [
        "✅ У вас всё есть! Конфигурация полная, Босс!",
        "🎯 Всё готово, ничего не отсутствует, Босс!",
        "👌 Конфигурация полная, дополнительные данные не нужны, Босс!"
      ]
    },
    "init_completed": {
      "variants": [
        "\n✅ Файлы конфигурации созданы в папке dartdosh_config/, Босс!\n📝 Пожалуйста, сначала проверьте их, потом используйте!\n💡 Пример: dartdosh build apk -p",
        "\n🎉 Конфигурации готовы в папке dartdosh_config/, Босс!\n🔍 Сначала просмотрите файлы, затем начинайте сборку!\n💡 Пример: dartdosh build ipa -p",
        "\n🏆 Файлы конфигурации созданы в dartdosh_config/, Босс!\n👀 Проверьте их и начинайте использовать!\n💡 Пример: dartdosh build aab -s"
      ]
    },
    "config_not_found": {
      "variants": [
        "❌ Файлы конфигурации не найдены! Пожалуйста, сначала выполните 'dartdosh init', Босс!",
        "⚠️ Нет конфигурации! Запустите команду 'dartdosh init', Босс!",
        "📝 Нужна конфигурация! Сначала выполните 'dartdosh init', Босс!"
      ]
    },
    "version_show": {
      "variants": [
        "🎯 У вас DartDosh версия {version}, Босс!",
        "✨ Версия {version} работает, Босс!",
        "🚀 DartDosh {version} - отличная версия, Босс!"
      ]
    },
    "version_checking": {
      "variants": [
        "🔍 Проверка обновлений, Босс...",
        "📡 Подключение к серверу, Босс...",
        "🔎 Посмотрим, есть ли обновление, Босс..."
      ]
    },
    "version_update_available": {
      "variants": [
        "🎉 Босс, вышла версия {latest}!",
        "✨ Новая версия {latest} доступна, Босс!",
        "🚀 Отлично! Версия {latest} готова, Босс!"
      ]
    },
    "version_current_info": {
      "variants": [
        "📦 Сейчас у вас версия {version}"
      ]
    },
    "version_upgrade_hint": {
      "variants": [
        "💡 Для обновления напишите эту команду: dartdosh upgrade"
      ]
    },
    "version_up_to_date": {
      "variants": [
        "✅ Нет обновлений, у вас последняя версия, Босс!",
        "🎯 Обновление не нужно, последняя версия работает, Босс!",
        "👌 Всё отлично! У вас последняя версия, Босс!"
      ]
    },
    "version_server_error": {
      "variants": [
        "❌ Не удалось подключиться к серверу, Босс!"
      ]
    },
    "version_upgrading": {
      "variants": [
        "🚀 Обновление начато, Босс...",
        "⬆️ Обновляем, подождите Босс...",
        "✨ Переход на последнюю версию, Босс..."
      ]
    },
    "version_upgrade_success": {
      "variants": [
        "🎉 {oldVersion} → {newVersion}. Теперь можете хвастаться, Босс!",
        "✅ Отлично! Обновлено с {oldVersion} на {newVersion}. Можете показать, Босс!",
        "🏆 Супер! Версия теперь {newVersion}. Расскажите друзьям, Босс!",
        "🚀 Готово! {oldVersion} → {newVersion}. Теперь вы впереди всех, Босс!"
      ]
    },
    "version_upgrade_failed": {
      "variants": [
        "❌ Обновление не удалось! Проверьте интернет, Босс!"
      ]
    },
    "version_downgrading": {
      "variants": [
        "⬇️ Откат к версии {version}, Босс..."
      ]
    },
    "version_downgrading_previous": {
      "variants": [
        "⬇️ Откат к предыдущей версии, Босс..."
      ]
    },
    "version_downgrade_success": {
      "variants": [
        "✅ Откат с {oldVersion} на {newVersion}, Босс!",
        "🎯 Готово! Версия установлена на {newVersion}, Босс!",
        "👌 Откат завершён! Теперь версия {newVersion}, Босс!"
      ]
    },
    "version_downgrade_failed": {
      "variants": [
        "❌ Откат не удался! Версия не найдена, Босс!"
      ]
    },
    "firebase_upload_missing_app_id": {
      "variants": [
        "⚠️ Firebase App ID не указан, Босс!"
      ]
    },
    "firebase_upload_starting": {
      "variants": [
        "📤 Загрузка APK в Firebase App Distribution, Босс..."
      ]
    },
    "firebase_upload_success": {
      "variants": [
        "✅ APK успешно загружен в Firebase, Босс!"
      ]
    },
    "firebase_upload_failed": {
      "variants": [
        "❌ Ошибка загрузки в Firebase, Босс!"
      ]
    },
    "telegram_upload_starting": {
      "variants": [
        "✈️ Загрузка APK в Telegram-канал, Босс...",
        "📲 Отправка APK через Telegram MTProto, Босс...",
        "🚀 Загрузка в Telegram началась, Босс..."
      ]
    },
    "telegram_upload_success": {
      "variants": [
        "✅ APK успешно отправлен в Telegram-канал, Босс!",
        "🎉 Загрузка завершена! APK в канале, Босс!",
        "🏆 APK успешно загружен в Telegram, Босс!"
      ]
    },
    "telegram_upload_failed": {
      "variants": [
        "❌ Ошибка загрузки в Telegram, Босс!",
        "💥 Не удалось отправить APK в Telegram, Босс!",
        "⚠️ Загрузка в Telegram не удалась, Босс!"
      ]
    },
    "telegram_upload_missing_chat_id": {
      "variants": [
        "⚠️ chat_id для этого окружения не указан в build_config.json, Босс!",
        "🔐 Не найден chat_id для данного окружения в build_config.json, Босс!"
      ]
    },
    "telegram_upload_python_not_found": {
      "variants": [
        "❌ Python 3 не найден! Установите Python 3 для загрузки в Telegram, Босс!",
        "⚠️ Загрузка в Telegram требует Python 3. Сначала установите его, Босс!"
      ]
    },
    "telegram_upload_telethon_not_found": {
      "variants": [
        "❌ telethon не найден! Выполните: pip install telethon, Босс!",
        "⚠️ Загрузка в Telegram требует telethon. Установите: pip3 install telethon, Босс!"
      ]
    },
    "clean_started": {
      "variants": [
        "🗑️ Очистка {target}...",
        "🧹 Удаление файлов {target}, Босс...",
        "♻️ Очищаю {target}, Босс..."
      ]
    },
    "clean_success": {
      "variants": [
        "✅ Готово! Удалено {file} файл(ов), освобождено {path}, Босс!",
        "🎉 Очищено! Удалено {file} файл(ов), сэкономлено {path}, Босс!",
        "🏆 {file} файл(ов) удалено — освобождено {path}, Босс!"
      ]
    },
    "clean_nothing_to_delete": {
      "variants": [
        "ℹ️ Нечего удалять, Босс!",
        "✨ Уже чисто — файлы не найдены, Босс!",
        "👌 Здесь нечего удалять, Босс!"
      ]
    },
    "clean_output_path_not_configured": {
      "variants": [
        "❌ output_path не настроен в build_config.json, Босс!",
        "⚠️ output_path не задан — сначала добавьте его в build_config.json, Босс!"
      ]
    }
  }
}

''',
  'tr': r'''
{
  "version": "1.0.0",
  "language": "tr",
  "metadata": {
    "name": "Türkçe",
    "native_name": "Turkish",
    "contributors": ["ahadjonovss"]
  },
  "progress_tasks": {
    "starting": "Başlatılıyor...",
    "gradle": "Gradle çalışıyor...",
    "dependencies_downloading": "Bağımlılıklar indiriliyor...",
    "dependencies_ready": "Bağımlılıklar hazır...",
    "compiling": "Flutter kodu derleniyor...",
    "bundling": "Bundle oluşturuluyor...",
    "assembling": "APK/AAB derleniyor...",
    "signing": "İmzalanıyor...",
    "finishing": "Tamamlanıyor...",
    "ready": "Hazır!"
  },
  "log_types": {
    "start": {
      "variants": [
        "🚀 Başlatma: Build {target} ({env} modu), Patron!",
        "✨ Hazır olun: {target} build başlatıldı ({env}), Patron!",
        "🏁 İşlem başladı: {target} ({env}), Patron!"
      ]
    },
    "info": {
      "variants": []
    },
    "step": {
      "variants": [
        "🔧 {target} build aşaması: Flutter komutları çalışıyor, Patron...",
        "⚙️ İşlem: Build aşamaları yürütülüyor, Patron...",
        "🛠️ Adım: {target} build işlemi devam ediyor, Patron..."
      ]
    },
    "success": {
      "variants": [
        "✅ {target} build başarıyla tamamlandı, Patron!",
        "🎉 Uygulama hazır: {target} ({env}), Patron!",
        "🏆 {target} build başarıyla bitti, Patron!"
      ]
    },
    "error": {
      "variants": [
        "❌ {target} build hatası oluştu, Patron!",
        "💥 Bir şeyler ters gitti: {target} ({env}), Patron!",
        "⚠️ Build başarısız: {target} ({env}), Patron!"
      ]
    },
    "finished": {
      "variants": []
    },
    "build_config_is_not_exist": {
      "variants": [
        "⚠️ Build yapılandırması bulunamadı, varsayılan oluşturuluyor, Patron!",
        "📝 build_config.json yok, varsayılan yapılandırma oluşturdum, Patron!",
        "ℹ️ Yapılandırma oluşturuluyor, Patron!"
      ]
    },
    "build_config_created": {
      "variants": [
        "\n📋 Patron, build_config.json oluşturdum!\n✅ Lütfen kontrol edin ve doğruysa komutu tekrar çalıştırın.\n💼 Hizmetinizdeyim, Patron!",
        "\n📝 Build yapılandırması hazır, Patron!\n🔍 Yapılandırmayı kontrol edin, sonra tekrar çalıştırın.\n🚀 Komut bekliyorum, Patron!",
        "\n✨ Varsayılan yapılandırma oluşturdum, Patron!\n📖 İnceleyin ve uygunsa komutu tekrar çalıştırın.\n⚡ Hazır bekliyorum, Patron!"
      ]
    },
    "running": {
      "variants": [
        "🔄 Çalıştırılıyor: {command}, Patron!",
        "⏳ Komut yürütülüyor: {command}, Patron!",
        "🏃 İşlem: {command}, Patron!"
      ]
    },
    "donation": {
      "variants": [
        "\n☕ Patron, dartdosh hoşunuza gittiyse, bana bir çay parası atın: https://www.tirikchilik.uz/ahadjonovss\n   Kahve içip daha harika araçlar yapacağım! 😄",
        "\n💰 Patron, bu araç faydalıysa, sorun değil bağış yaparsınız: https://www.tirikchilik.uz/ahadjonovss\n   Bir şey yaparsanız, yeni özellikler çıkaracağım! 🚀",
        "\n🎁 Patron, dartdosh yardımcı oluyor mu? O zaman bu linke bir göz atın: https://www.tirikchilik.uz/ahadjonovss\n   Sponsor olun, daha güçlü hale getirelim! 💪",
        "\n🍕 Build hazır oldu, şimdi benim sıram! Pizza için yardım ederseniz: https://www.tirikchilik.uz/ahadjonovss\n   Kodlama ve pizza - en iyi kombinasyon! 🤩",
        "\n🤑 Patron, bu aracı kullanarak zamanınızı kazandınız mı? O zaman bana da yardım edin: https://www.tirikchilik.uz/ahadjonovss\n   Bir kahve parası bile olsa moralim yükselir! ☕",
        "\n💝 Hey Patron, dartdosh hoşunuza gitti mi? Sevindirdim mi? O zaman küçük bir bağış: https://www.tirikchilik.uz/ahadjonovss\n   Büyük para değil, gönülden gelen yeterli! 😊",
        "\n🎯 Build başarılı! Şimdi beni de unutmayın: https://www.tirikchilik.uz/ahadjonovss\n   Desteğinizle daha harika araçlar yaratacağız! 🔥",
        "\n🌟 Patron, açık kaynak geliştirici hayatı zor! Yardım elinizi uzatın: https://www.tirikchilik.uz/ahadjonovss\n   Bir çorba parası bile büyük lütuf! 🍜",
        "\n🎊 Build hazır, siz de mutlusunuz, ben de! Şimdi bana da bir iltifat: https://www.tirikchilik.uz/ahadjonovss\n   Destek olursanız, sonraki sürüm daha hızlı çıkar! ⚡",
        "\n😎 Patron, dartdosh zamanınızı mı kazandırıyor? O zaman benim zamanımı da takdir edin: https://www.tirikchilik.uz/ahadjonovss\n   Bir demlik çay parası lazım sadece! 🍵"
      ]
    },
    "build_number_incremented": {
      "variants": [
        "✅ Build numarası güncellendi: {oldBuild} → {newBuild}, Patron!",
        "🔢 Build numarası artırıldı: {oldBuild} → {newBuild}, Patron!",
        "📈 Yeni build numarası: {newBuild} (önceki: {oldBuild}), Patron!"
      ]
    },
    "file_saved": {
      "variants": [
        "✅ Build kaydedildi: {path}, Patron!",
        "💾 Dosya hazır: {path}, Patron!",
        "📦 Build başarıyla kopyalandı: {path}, Patron!"
      ]
    },
    "output_dir_created": {
      "variants": [
        "📁 Çıktı dizini oluşturuldu: {path}, Patron!",
        "🗂️ Yeni klasör oluşturuldu: {path}, Patron!",
        "✨ Çıktı klasörü hazır: {path}, Patron!"
      ]
    },
    "upload_starting": {
      "variants": [
        "📤 IPA dosyası App Store Connect'e yükleniyor, Patron...",
        "🚀 Transporter başlatıldı, IPA yükleniyor, Patron...",
        "⬆️ Yükleme işlemi başladı, Patron..."
      ]
    },
    "upload_progress": {
      "variants": [
        "⏳ {progress}"
      ]
    },
    "upload_success": {
      "variants": [
        "✅ IPA başarıyla App Store Connect'e yüklendi, Patron!",
        "🎉 Yükleme hazır! IPA App Store'da, Patron!",
        "🏆 Dosya başarıyla yüklendi, Patron!"
      ]
    },
    "upload_failed": {
      "variants": [
        "❌ IPA yükleme hata ile tamamlandı, Patron!",
        "💥 Yükleme başarısız, Patron!",
        "⚠️ Dosya yüklerken sorun oluştu, Patron!"
      ]
    },
    "upload_credentials_missing": {
      "variants": [
        "⚠️ Yükleme açık ama Apple ID veya şifre girilmemiş, Patron!",
        "🔐 Kimlik bilgileri bulunamadı! build_config.json'a Apple ID ve şifre ekleyin, Patron!",
        "⚡ Yükleme için Apple ID gerekli, Patron!"
      ]
    },
    "total_time": {
      "variants": [
        "⏱️  Toplam süre: {time} saniye. Sizin için {time} saniye çalıştım, Patron! 💪",
        "🎯 İşlem {time} saniyede tamamlandı. Zamanınızı kazandırdım, Patron! ⚡",
        "✨ {time} saniyede her şey hazır! Size hizmet etmek bir onur, Patron! 🚀"
      ]
    },
    "init_started": {
      "variants": [
        "🚀 Dartdosh yapılandırılıyor, Patron...",
        "✨ Init işlemi başladı, Patron...",
        "🔧 Yapılandırma kontrol ediliyor, Patron..."
      ]
    },
    "config_created": {
      "variants": [
        "✅ Yeni config dosyaları oluşturuldu, Patron!",
        "📝 Yapılandırma hazır, Patron!",
        "🎉 Config dosyaları başarıyla oluşturuldu, Patron!"
      ]
    },
    "config_validation_failed": {
      "variants": [
        "❌ Config dosyası kontrol edilirken hata oluştu, Patron!",
        "💥 Doğrulama hatası, Patron!",
        "⚠️ Config dosyası okunamadı, Patron!"
      ]
    },
    "config_creation_failed": {
      "variants": [
        "❌ Config oluştururken hata oluştu, Patron!",
        "💥 Dosyalar oluşturulamadı, Patron!",
        "⚠️ Yapılandırma oluşturulamadı, Patron!"
      ]
    },
    "migration_started": {
      "variants": [
        "🔄 Eski build_config.json bulundu, yeni yapıya geçiliyor, Patron...",
        "📦 Migration başladı, Patron...",
        "⚡ Eski config'den veriler kopyalanıyor, Patron..."
      ]
    },
    "migration_completed": {
      "variants": [
        "✅ Migration başarılı! Tüm veriler yeni dosyaya kopyalandı, Patron!",
        "🎉 Eski config yeni formata dönüştürüldü, Patron!",
        "🏆 Migration hazır! Tüm verileri sakladım, Patron!"
      ]
    },
    "migration_failed": {
      "variants": [
        "❌ Migration hata ile tamamlandı, Patron!",
        "💥 Eski config okunurken sorun oluştu, Patron!",
        "⚠️ Migration gerçekleştirilemedi, Patron!"
      ]
    },
    "missing_field_added": {
      "variants": [
        "✅ Eksik alan eklendi: {field}, Patron!",
        "🔧 Güncellendi: {field} ekledim, Patron!",
        "📝 {field} - bu veri yoktu, ekledim, Patron!"
      ]
    },
    "already_configured": {
      "variants": [
        "✅ Her şey tamam! Yapılandırma eksiksiz, Patron!",
        "🎯 Her şey hazır, hiçbir şey eksik değil, Patron!",
        "👌 Config tam, ek bir şey gerekli değil, Patron!"
      ]
    },
    "init_completed": {
      "variants": [
        "\n✅ Config'ler dartdosh_config/ klasöründe oluşturuldu, Patron!\n📝 Lütfen önce kontrol edin, sonra kullanabilirsiniz!\n💡 Örneğin: dartdosh build apk -p",
        "\n🎉 dartdosh_config/ klasöründe config'ler hazır, Patron!\n🔍 Önce dosyalara göz atın, sonra build başlatabilirsiniz!\n💡 Örnek: dartdosh build ipa -p",
        "\n🏆 Config dosyalar dartdosh_config/ içinde oluşturuldu, Patron!\n👀 Kontrol edin ve kullanmaya başlayın!\n💡 Örneğin: dartdosh build aab -s"
      ]
    },
    "config_not_found": {
      "variants": [
        "❌ Config dosyalar bulunamadı! Lütfen önce 'dartdosh init' çalıştırın, Patron!",
        "⚠️ Yapılandırma yok! 'dartdosh init' komutunu çalıştırın, Patron!",
        "📝 Config gerekli! Önce 'dartdosh init' yapın, Patron!"
      ]
    },
    "version_show": {
      "variants": [
        "🎯 Sizde şu an DartDosh {version} versiyonu var, Patron!",
        "✨ {version} versiyonu çalışıyor, Patron!",
        "🚀 DartDosh {version} - harika versiyon, Patron!"
      ]
    },
    "version_checking": {
      "variants": [
        "🔍 Güncellemeler kontrol ediliyor, Patron...",
        "📡 Sunucuya bağlanılıyor, Patron...",
        "🔎 Update var mı bakalım, Patron..."
      ]
    },
    "version_update_available": {
      "variants": [
        "🎉 Patron, şimdi {latest} versiyonu çıkmış!",
        "✨ Yeni {latest} versiyonu var, Patron!",
        "🚀 Harika! {latest} versiyonu hazır, Patron!"
      ]
    },
    "version_current_info": {
      "variants": [
        "📦 Sizde şu an {version} versiyonu var"
      ]
    },
    "version_upgrade_hint": {
      "variants": [
        "💡 Güncellemek için bu komutu yazın: dartdosh upgrade"
      ]
    },
    "version_up_to_date": {
      "variants": [
        "✅ Güncelleme yok, sizde en son versiyon var, Patron!",
        "🎯 Güncellemeye gerek yok, en yeni versiyon çalışıyor, Patron!",
        "👌 Her şey süper! Sizde en son versiyon var, Patron!"
      ]
    },
    "version_server_error": {
      "variants": [
        "❌ Sunucuya bağlanılamadı, Patron!"
      ]
    },
    "version_upgrading": {
      "variants": [
        "🚀 Upgrade başladı, Patron...",
        "⬆️ Güncelleniyor, biraz sabır Patron...",
        "✨ En yeni versiyona geçiliyor, Patron..."
      ]
    },
    "version_upgrade_success": {
      "variants": [
        "🎉 {oldVersion} → {newVersion}. Artık övünebilirsiniz, Patron!",
        "✅ Süper! {oldVersion}'dan {newVersion}'a güncellendi. Övünebilirsiniz, Patron!",
        "🏆 Harika! Versiyon {newVersion}'a geçti. Arkadaşlarınıza söyleyin, Patron!",
        "🚀 Hazır! {oldVersion} → {newVersion}. Artık herkesten öndesiniz, Patron!"
      ]
    },
    "version_upgrade_failed": {
      "variants": [
        "❌ Güncellenemedi! İnterneti kontrol edin, Patron!"
      ]
    },
    "version_downgrading": {
      "variants": [
        "⬇️ {version} versiyonuna geri dönülüyor, Patron..."
      ]
    },
    "version_downgrading_previous": {
      "variants": [
        "⬇️ Önceki versiyona geri dönülüyor, Patron..."
      ]
    },
    "version_downgrade_success": {
      "variants": [
        "✅ {oldVersion}'dan {newVersion}'a geri döndü, Patron!",
        "🎯 Hazır! Versiyon {newVersion}'a ayarlandı, Patron!",
        "👌 Downgrade tamamlandı! Şimdi {newVersion} versiyondasınız, Patron!"
      ]
    },
    "version_downgrade_failed": {
      "variants": [
        "❌ Geri döndürülemedi! Versiyon bulunamadı, Patron!"
      ]
    },
    "firebase_upload_missing_app_id": {
      "variants": [
        "⚠️ Firebase App ID girilmemiş, Patron!"
      ]
    },
    "firebase_upload_starting": {
      "variants": [
        "📤 APK Firebase App Distribution'a yükleniyor, Patron..."
      ]
    },
    "firebase_upload_success": {
      "variants": [
        "✅ APK başarıyla Firebase'e yüklendi, Patron!"
      ]
    },
    "firebase_upload_failed": {
      "variants": [
        "❌ Firebase'e yüklerken hata oluştu, Patron!"
      ]
    },
    "telegram_upload_starting": {
      "variants": [
        "✈️ APK Telegram kanalına yükleniyor, Patron...",
        "📲 APK MTProto üzerinden Telegram'a gönderiliyor, Patron...",
        "🚀 Telegram yüklemesi başladı, Patron..."
      ]
    },
    "telegram_upload_success": {
      "variants": [
        "✅ APK başarıyla Telegram kanalına gönderildi, Patron!",
        "🎉 Telegram yüklemesi tamamlandı! APK kanalda, Patron!",
        "🏆 APK Telegram'a başarıyla yüklendi, Patron!"
      ]
    },
    "telegram_upload_failed": {
      "variants": [
        "❌ Telegram yüklemesi başarısız oldu, Patron!",
        "💥 APK Telegram'a gönderilemedi, Patron!",
        "⚠️ Telegram yüklemesi tamamlanamadı, Patron!"
      ]
    },
    "telegram_upload_missing_chat_id": {
      "variants": [
        "⚠️ Bu ortam için build_config.json'da chat_id belirtilmemiş, Patron!",
        "🔐 build_config.json'da bu ortam için chat_id bulunamadı, Patron!"
      ]
    },
    "telegram_upload_python_not_found": {
      "variants": [
        "❌ Python 3 bulunamadı! Telegram yüklemesi için Python 3 kurun, Patron!",
        "⚠️ Telegram yüklemesi Python 3 gerektirir. Lütfen önce kurun, Patron!"
      ]
    },
    "telegram_upload_telethon_not_found": {
      "variants": [
        "❌ telethon bulunamadı! Çalıştırın: pip install telethon, Patron!",
        "⚠️ Telegram yüklemesi telethon gerektirir. Kurun: pip3 install telethon, Patron!"
      ]
    },
    "clean_started": {
      "variants": [
        "🗑️ {target} temizleniyor...",
        "🧹 {target} derleme dosyaları siliniyor, Patron...",
        "♻️ {target} temizleniyor, Patron..."
      ]
    },
    "clean_success": {
      "variants": [
        "✅ Tamam! {file} dosya silindi, {path} boşaltıldı, Patron!",
        "🎉 Temizlendi! {file} dosya kaldırıldı, {path} kazanıldı, Patron!",
        "🏆 {file} dosya silindi — {path} boşaltıldı, Patron!"
      ]
    },
    "clean_nothing_to_delete": {
      "variants": [
        "ℹ️ Silinecek dosya yok, Patron!",
        "✨ Zaten temiz — dosya bulunamadı, Patron!",
        "👌 Burada kaldırılacak bir şey yok, Patron!"
      ]
    },
    "clean_output_path_not_configured": {
      "variants": [
        "❌ build_config.json'da output_path yapılandırılmamış, Patron!",
        "⚠️ output_path ayarlanmamış — önce build_config.json'a ekleyin, Patron!"
      ]
    }
  }
}

'''
};
