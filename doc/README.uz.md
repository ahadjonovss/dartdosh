# DartDosh CLI – Foydalanuvchi Qo'llanmasi

**📖 Boshqa tillarda o'qish:**
[🇬🇧 English](../README.md) | [🇷🇺 Русский](README.ru.md) | [🇹🇷 Türkçe](README.tr.md)

---

`DartDosh` - bu Flutter build jarayonlarini avtomatik versiya boshqaruvi, ko'p tillilik va aqlli chiqish boshqaruvi bilan soddalashtiruvchi kuchli CLI vositasi.

## 🌍 Ko'p Tillilik Qo'llab-quvvatlash

**DartDosh endi 4 tilni qo'llab-quvvatlaydi!**

- 🇺🇿 **O'zbekcha** (uz) - "Xo'jayiin" uslubi - Standart
- 🇬🇧 **Inglizcha** (en) - "Boss" uslubi
- 🇷🇺 **Ruscha** (ru) - "Босс" uslubi
- 🇹🇷 **Turkcha** (tr) - "Patron" uslubi - **YANGI!**

## 📺 Video Qo'llanma

[![DartDosh Tutorial](https://img.youtube.com/vi/QpNVwk4SVZA/maxresdefault.jpg)](https://youtu.be/QpNVwk4SVZA?si=kV7kTtHcnZLfv1ZP)

To'liq qo'llanmani YouTube'da tomosha qiling: [DartDosh - Flutter Build Automation](https://youtu.be/QpNVwk4SVZA?si=kV7kTtHcnZLfv1ZP)

---

```bash
dartdosh build <target> --<environment> [qo'shimcha flaglar]
```

**Misollar:**

```bash
# Muhit bilan (flavor builds) - avtomatik versiya boshqaruvi
dartdosh build ipa --production --split
dartdosh build apk --development --other-flag
dartdosh build appbundle --staging

# Qisqa flaglar (qulayroq!)
dartdosh build apk -p              # production
dartdosh build apk -prod           # production
dartdosh build apk -d              # development
dartdosh build apk -dev            # development
dartdosh build apk -s              # staging

# Muhitsiz - oddiy Flutter build (versiya boshqaruvisiz)
dartdosh build apk                 # flutter build apk
dartdosh build apk --release       # flutter build apk --release
dartdosh build ipa --split         # flutter build ipa --split-per-abi
```

---

## 🔧 --dart-define-from-file Ishlatish

DartDosh Flutter'ning `--dart-define-from-file` flagini to'liq qo'llab-quvvatlaydi - JSON fayllardan konfiguratsiya yuklash uchun. Uni **ikki usulda** ishlatishingiz mumkin:

### 1-Usul: Bevosita Buyruq Qatori Orqali

Flagni to'g'ridan-to'g'ri build paytida bering:

```bash
# Fayldan config yuklash
dartdosh build apk -p --dart-define-from-file=config/prod.json
dartdosh build ipa -s --dart-define-from-file=config/staging.json

# Boshqa flaglar bilan birga
dartdosh build apk -p --dart-define-from-file=config/prod.json --obfuscate
```

### 2-Usul: build_config.json'da Sozlash (Jamoalar Uchun Tavsiya Etiladi)

`dartdosh_config/build_config.json` faylidagi build buyruqlariga `--dart-define-from-file` qo'shing:

```json
{
  "apk": {
    "production": "flutter build apk --release --flavor production --dart-define-from-file=config/prod.json",
    "staging": "flutter build apk --release --flavor staging --dart-define-from-file=config/staging.json"
  },
  "ipa": {
    "production": "flutter build ipa --release --flavor production --dart-define-from-file=config/prod.json",
    "staging": "flutter build ipa --release --flavor staging --dart-define-from-file=config/staging.json"
  }
}
```

**Keyin oddiy ishga tushiring:**
```bash
dartdosh build apk -p    # Avtomatik config/prod.json ishlatadi
dartdosh build ipa -s    # Avtomatik config/staging.json ishlatadi
```

**Nega 2-Usulni Ishlatasiz?**
- ✅ Jamoa birligi - Hamma bir xil config fayllardan foydalanadi
- ✅ Fayl yo'llarini eslab qolish shart emas
- ✅ Barcha muhitlar uchun bitta buyruq
- ✅ Jamoalarda boshqarish osonroq

**Config fayl namunasi** (`config/prod.json`):
```json
{
  "API_URL": "https://api.production.com",
  "API_KEY": "prod-key-12345",
  "ENABLE_ANALYTICS": "true"
}
```

---

## Talablar

* Dart SDK ≥ 3.0
* Flutter SDK o'rnatilgan bo'lishi kerak
* Terminal (Mac/Linux/Windows)

---

## O'rnatish

### pub.dev'dan o'rnatish

```bash
dart pub global activate dartdosh
```

### PATH'ga qo'shish (agar kerak bo'lsa)

**Mac/Linux (`.zshrc` yoki `.bashrc`):**

```bash
export PATH="$PATH:$HOME/.pub-cache/bin"
source ~/.zshrc
```

**Windows PowerShell:**

```powershell
$env:PATH += ";$env:USERPROFILE\.pub-cache\bin"
```

---

## Konfiguratsiya

### DartDosh'ni Ishga Tushirish

Flutter loyihangizda avval ushbu buyruqni ishga tushiring:

```bash
dartdosh init
```

Bu 2 ta fayl bilan `dartdosh_config` papkasini yaratadi:

### 1. `build_config.json` (Jamoa Uchun Umumiy - Git'da Kuzatiladi)

Jamoangiz uchun build buyruqlari. Hamma bir xil buyruqlardan foydalanadi:

```json
{
  "apk": {
    "production": "flutter build apk --release --flavor production",
    "staging": "flutter build apk --release --flavor staging",
    "development": "flutter build apk --debug --flavor development"
  },
  "ipa": {
    "production": "flutter build ipa --release --flavor production",
    "staging": "flutter build ipa --release --flavor staging",
    "development": "flutter build ipa --debug --flavor development"
  },
  "appbundle": {
    "production": "flutter build appbundle --release --flavor production",
    "staging": "flutter build appbundle --release --flavor staging",
    "development": "flutter build appbundle --debug --flavor development"
  },
  "firebase_distribution": {
    "production": {
      "app_id": "1:123456789:android:prodabc123",
      "tester_groups": "production-testers,management"
    },
    "staging": {
      "app_id": "1:123456789:android:stagabc123",
      "tester_groups": "qa-team,staging-testers"
    },
    "development": {
      "app_id": "1:123456789:android:devabc123",
      "tester_groups": "developers,internal-testers"
    }
  }
}
```

### 2. `settings.json` (Shaxsiy - Git'da E'tiborga Olinmaydi)

Sizning shaxsiy sozlamalaringiz. Har bir dasturchi o'zinikiga ega:

```json
{
  "language": "uz",
  "project_name": "my_app",
  "auto_increment_build_number": false,
  "output_path": "~/Desktop/dartdosh-builds",
  "ipa_upload": {
    "enabled": true,
    "apple_id": "developer@example.com",
    "app_specific_password": "abcd-efgh-ijkl-mnop"
  },
  "firebase_distribution": {
    "production": {
      "enabled": false
    },
    "staging": {
      "enabled": true
    },
    "development": {
      "enabled": true
    }
  }
}
```

**Nega 2 ta fayl?**

- `build_config.json` → Jamoa build buyruqlarini almashadi (Git'da kuzatiladi)
- `settings.json` → Sizning Apple ID kabi shaxsiy sozlamalaringiz (Git'da e'tiborga olinmaydi)
- Jamoada boshqa autentifikatsiya to'qnashuvlari bo'lmaydi!

**Sozlamalar Parametrlari:**

* `language`: Interfeys tili
  - `uz` (O'zbekcha), `en` (Inglizcha), `ru` (Ruscha), `tr` (Turkcha)
  - Standart: `uz`

* `project_name`: Build'larni tartibga solish uchun loyiha nomi
  - Standart: `pubspec.yaml`dan o'qiladi

* `auto_increment_build_number`: Versiyani avtomatik oshirish
  - `true`: Har bir build'dan oldin build raqamini oshiradi
  - `false`: Joriy versiyani saqlaydi (standart)

* `output_path`: Build'larni qayerga saqlash
  - Standart: `~/Desktop/dartdosh-builds`
  - Mutlaq yoki nisbiy yo'l

* `ipa_upload`: IPA'ni App Store'ga avtomatik yuklash
  - `enabled`: true/false
  - `apple_id`: Sizning Apple ID'ingiz
  - `app_specific_password`: appleid.apple.com'dan oling
  - Faqat macOS

* `firebase_distribution`: APK'ni Firebase App Distribution'ga avtomatik yuklash (muhit bo'yicha)
  - Har bir muhit (production, staging, development) uchun:
    - `enabled`: true/false - Ushbu muhit uchun yuklashni yoqish/o'chirish
  - App ID va tester guruhlari `build_config.json`da konfiguratsiya qilinadi
  - Firebase CLI o'rnatilgan bo'lishi kerak

**App-Specific Password Qanday Olish Kerak:**
1. https://appleid.apple.com'ga o'ting
2. Xavfsizlik → Parol Yaratish
3. Uni "DartDosh" deb nomlang
4. Nusxalang va settings.json'ga joylashtiring

**Firebase App Distribution'ni Qanday Sozlash Kerak:**
1. Firebase CLI'ni o'rnating: `npm install -g firebase-tools`
2. Kiring: `firebase login`
3. App ID'ni Firebase Console → Project Settings'dan oling
4. Firebase Console → App Distribution'da tester guruhlarini qo'shing
5. `settings.json`da yoqing va konfiguratsiya qiling

---

## Foydalanish

```bash
dartdosh build <target> [--<environment>] [qo'shimcha flaglar]
```

**Parametrlar:**

* `<target>`: Build maqsadi
  - `apk` - Android APK
  - `ipa` - iOS IPA
  - `appbundle` yoki `aab` - Android App Bundle (ikkala buyruq ham qo'llab-quvvatlanadi)

* `<environment>`: Build muhiti (IXTIYORIY - ko'p flag variantlari qo'llab-quvvatlanadi!)
  - **Production**: `--production`, `-p`, `-prod`
  - **Staging**: `--staging`, `-s`
  - **Development**: `--development`, `-d`, `-dev`
  - **Eslatma**: Agar muhit ko'rsatilmagan bo'lsa, versiya boshqaruvisiz oddiy Flutter build ishga tushadi

* `[qo'shimcha flaglar]`: Qo'shimcha Flutter build flaglari
  - `--split` - APK build'lari uchun, avtomatik ravishda `--split-per-abi` qo'shadi
  - `--obfuscate` - Dart kodini obfuskatsiya qilish
  - `--dart-define=KEY=VALUE` - Muhit o'zgaruvchilarini belgilash
  - Boshqa har qanday Flutter build flaglari

---

## 📱 iOS (IPA) Build Tezkor Qo'llanma

DartDosh bilan iOS ilovalarini yaratish oson va App Store Connect'ga avtomatik yuklashni o'z ichiga oladi.

### Oldindan Talab Qilinadigan Narsalar

1. **Xcode bilan macOS** - iOS build'lari uchun talab qilinadi
2. **Yaroqli Apple Developer Akkaunt** - Tarqatish build'lari uchun
3. **Code Signing Sozlamalari** - Xcode'da sertifikatlar va provisioning profillari konfiguratsiya qilingan

### Asosiy IPA Build

```bash
# Production build
dartdosh build ipa --production
dartdosh build ipa -p

# Staging build
dartdosh build ipa --staging
dartdosh build ipa -s

# Obfuskatsiya bilan
dartdosh build ipa -p --obfuscate

# dart-define o'zgaruvchilari bilan
dartdosh build ipa -p --dart-define=API_URL=https://api.production.com
```

### App Store Connect'ga Avtomatik Yuklash

DartDosh muvaffaqiyatli build'dan keyin IPA'ni App Store Connect'ga avtomatik yuklashi mumkin.

**1. App-Specific Password Oling**

1. [appleid.apple.com](https://appleid.apple.com)'ga o'ting
2. Apple ID bilan kiring
3. **Xavfsizlik** bo'limida → **App-Specific Passwords** → **Generate Password**
4. Uni "DartDosh" deb nomlang va parolni nusxalang (format: `xxxx-xxxx-xxxx-xxxx`)

**2. `build_config.json`da Konfiguratsiya Qiling**

```json
{
  "ipa_upload": {
    "enabled": true,
    "apple_id": "your-email@example.com",
    "app_specific_password": "xxxx-xxxx-xxxx-xxxx"
  }
}
```

**3. Build va Yuklash**

```bash
dartdosh build ipa -p
```

**Chiqish:**
```
[████████████████████████████████] 100% - [ipa - production] - Tayyor!
✅ ipa build muvaffaqiyatli yakunlandi, Xo'jayiin!
✅ Build saqlandi: ~/Desktop/dartdosh-builds/my_app/ipa/prod_1.0.0_100.ipa, Xo'jayiin!

📤 IPA App Store Connect'ga yuklanmoqda...
📊 Yuklash jarayonda...
✅ IPA muvaffaqiyatli App Store Connect'ga yuklandi, Xo'jayiin!

⏱️ Umumiy vaqt: 180.5 soniya
```

### Chiqish Fayllari

IPA fayllari avtomatik ravishda tartibga solinadi:

```
~/Desktop/dartdosh-builds/
└── my_app/
    └── ipa/
        ├── prod_1.0.0_100.ipa
        ├── prod_1.0.0_101.ipa
        └── stg_1.0.0_50.ipa
```

**Fayl nomlash formati:** `{env}_{version}_{buildNumber}.ipa`

### Muhim Eslatmalar

- **Yuklash macOS talab qiladi** - `xcrun altool`dan foydalanadi (Xcode'ga o'rnatilgan)
- **Yuklash ixtiyoriy** - O'chirish uchun `"enabled": false` qo'ying
- **Xavfsizlik** - Autentifikatsiya ma'lumotlarini himoya qilish uchun `build_config.json`ni `.gitignore`ga qo'shing
- **Ilova App Store Connect'da mavjud bo'lishi kerak** - Avval ilovangizni [appstoreconnect.apple.com](https://appstoreconnect.apple.com)da yarating
- **Yuklash taqdim etmaydi** - Bu faqat build'ni yuklaydi; siz hali ham App Store Connect orqali taqdim etishingiz kerak

### Muammolarni Bartaraf Etish

**Yuklash muvaffaqiyatsiz bo'ldimi?**
- Apple ID va app-specific parolingizni tekshiring
- Ilova App Store Connect'da mavjudligini ta'minlang
- Internet aloqasini tekshiring
- Xcode buyruq qatori vositalarining o'rnatilganligini tekshiring: `xcode-select --install`

**Build muvaffaqiyatsiz bo'ldimi?**
- Xcode'da code signing'ni tekshiring
- Provisioning profillarining yaroqliligini tekshiring
- iOS sozlamalarini tekshirish uchun `flutter doctor`ni ishga tushiring

---

## Xususiyatlar

### 🌍 Ko'p Tillilik Qo'llab-quvvatlash
DartDosh barcha interfeys xabarlari va progress ko'rsatkichlari uchun uch tilni qo'llab-quvvatlaydi:

* **O'zbekcha (uz)** - "Xo'jayiin" murojaat uslubi bilan standart til
* **Inglizcha (en)** - "Boss" murojaat uslubi bilan professional inglizcha interfeys
* **Ruscha (ru)** - "Босс" (Boss) murojaat uslubi bilan ruscha interfeys

**Tilni O'rnatish:**
```json
{
  "language": "en"  // build_config.json'da o'rnating
}
```

**Til Xususiyatlari:**
* Barcha log xabarlari tarjima qilingan
* Progress bar bosqichlari lokalizatsiya qilingan
* Tanlangan tildagi build holat xabarlari
* Madaniy hazil bilan xayriya xabarlari
* Qo'llab-quvvatlanmaydigan tillar uchun ogohlantirish bilan inglizchaga avtomatik qaytish

**O'zbekcha Misol:**
```
📈 Yangi build number: 46 (oldingi: 45), Xo'jayiin!
[████████████████░░░░░░░░░░░░░░]  60% - [apk - production] - Bundle yaratilmoqda...
✅ apk build muvaffaqiyatli yakunlandi, Xo'jayiin!
```

**Inglizcha Misol:**
```
📈 New build number: 46 (previous: 45), Boss!
[████████████████░░░░░░░░░░░░░░]  60% - [apk - production] - Creating bundle...
✅ apk build completed successfully, Boss!
```

### 🤖 Avtomatik Konfiguratsiya
Flutter loyihangizda `build_config.json` mavjud bo'lmaganda, DartDosh:
1. **Standart sozlamalar bilan konfiguratsiya yaratadi**
2. **Uni ko'rib chiqish uchun IDE'da avtomatik ochadi**
3. **Bajarilishni to'xtatadi** va buyruqni qayta ishga tushirishni so'raydi

Bu birinchi build'dan oldin konfiguratsiyani ko'rib chiqish va sozlash imkonini beradi.

**Misol ish jarayoni:**
```bash
# Birinchi ishga tushirish (konfiguratsiya yo'q)
dartdosh build apk --production
# Chiqish: Konfiguratsiya yaratildi va IDE'da ochildi, iltimos ko'rib chiqing va qayta ishga tushiring

# Ikkinchi ishga tushirish (konfiguratsiya ko'rib chiqildi)
dartdosh build apk --production
# Chiqish: Oddiy build davom etadi
```

### 🔢 Avtomatik Versiya Boshqaruvi (Ixtiyoriy)

**Muhit flaglaridan foydalanganda** (flavor builds) va `auto_increment_build_number: true` bo'lganda, DartDosh avtomatik ravishda:
1. `pubspec.yaml`dan joriy versiyani o'qiydi
2. Build raqamini 1 ga oshiradi
3. `pubspec.yaml`ni yangi build raqami bilan yangilaydi

**Misol:**
```yaml
# Build'dan oldin (muhit flagi va auto_increment yoqilgan)
version: 1.2.3+45

# Build'dan keyin
version: 1.2.3+46
```

**Eslatmalar**:
- **Standart**: `false` (avtomatik oshirish standart bo'yicha o'chirilgan)
- Versiya oshirish faqat flavor build'lari uchun sodir bo'ladi (muhit flagi bilan)
- `auto_increment_build_number: true`ni konfiguratsiyada o'rnatish orqali yoqing
- Oddiy build'lar (`dartdosh build apk`) hech qachon versiya raqamlarini o'zgartirmaydi

### 📦 Aqlli Fayl Nomlash

**Flavor build'lari uchun** (muhit flaglari bilan), yaratilgan fayllar quyidagi format yordamida avtomatik ravishda nomlanadi:
```
{shortEnv}_{version}_{buildNumber}.{extension}
```

**Muhit qisqa nomlari:**
- `production` → `prod`
- `development` → `dev`
- `staging` → `stg`

**Misollar:**
* `prod_1.2.3_46.apk`
* `stg_2.0.0_12.ipa`
* `dev_1.5.0_78.aab`

Split APK'lar uchun:
* `prod_1.2.3_46_arm64-v8a.apk`
* `prod_1.2.3_46_armeabi-v7a.apk`
* `prod_1.2.3_46_x86_64.apk`

**Oddiy build'lar uchun** (muhitsiz), fayllar quyidagi format yordamida nomlanadi:
```
{target}_{version}_{buildNumber}.{extension}
```

**Misollar:**
* `apk_1.2.3_46.apk`
* `ipa_2.0.0_12.ipa`
* `appbundle_1.5.0_78.aab`

Eslatma: Oddiy build'lar versiyani oshirmaydi, lekin hali ham nomlanadi va output_path'ga ko'chiriladi.

### 📁 Chiqish Yo'li Boshqaruvi

Agar `output_path` `build_config.json`da ko'rsatilgan bo'lsa:
* Yaratilgan fayllar tartibga solingan struktura bilan belgilangan katalogga **nusxalanadi**
* Fayllar quyidagicha tartibga solinadi: `output_path/project_name/{apk|ipa|aab}/`
* Har bir build turi yaxshiroq tashkillashtirish uchun o'z pastki papkasiga ega bo'ladi
* Asl fayllar build katalogida qoladi
* Katalog strukturasi avtomatik ravishda yaratiladi

**Misol struktura:**
```
~/Desktop/dartdosh-builds/
└── my_app/
    ├── apk/
    │   ├── prod_1.0.0_100.apk
    │   └── dev_1.0.0_101.apk
    ├── ipa/
    │   └── prod_1.0.0_100.ipa
    └── aab/
        └── prod_1.0.0_100.aab
```

`output_path`siz:
* Fayllar faqat build katalogida **nomlanadi**

---

## 🚀 IPA'ni App Store Connect'ga Avtomatik Yuklash

DartDosh muvaffaqiyatli build'dan keyin Apple'ning rasmiy Transporter vositasidan foydalanib IPA fayllaringizni App Store Connect'ga avtomatik yuklashi mumkin.

### Oldindan Talab Qilinadigan Narsalar

1. **Xcode o'rnatilgan macOS** - `xcrun iTMSTransporter` uchun talab qilinadi
2. **Yaroqli Apple Developer Akkaunt** - App Store Connect'da yaratilgan ilova bilan
3. **Yaroqli Sertifikatlar va Provisioning Profillari** - iOS Distribution sertifikati va provisioning profil
4. **App-Specific Password** - Apple ID sozlamalaridan yaratilgan

### 1-qadam: App-Specific Password Yaratish

1. https://appleid.apple.com'ga o'ting
2. Apple ID bilan kiring (App Store Connect uchun ishlatiladigan)
3. **Xavfsizlik** bo'limiga o'ting
4. **App-Specific Passwords** ostida **Generate Password** tugmasini bosing
5. Yorliq kiriting (masalan, "DartDosh CLI Tool")
6. **Create** tugmasini bosing
7. **Yaratilgan parolni nusxalang** (format: `xxxx-xxxx-xxxx-xxxx`)
   - ⚠️ Ushbu parolni saqlang - uni qayta ko'ra olmaysiz!

### 2-qadam: build_config.json'ni Konfiguratsiya Qilish

`build_config.json`ni oching va `ipa_upload` bo'limini qo'shing/yangilang:

```json
{
  "language": "uz",
  "project_name": "my_app",
  "auto_increment_build_number": false,
  "output_path": "~/Desktop/dartdosh-builds",
  "ipa_upload": {
    "enabled": true,                                    // ← true'ga o'rnating
    "apple_id": "developer@example.com",                // ← Sizning Apple ID'ingiz
    "app_specific_password": "abcd-efgh-ijkl-mnop"     // ← Yaratilgan parolni joylashtiring
  }
}
```

### 3-qadam: Build va Yuklash

Oddiy IPA'ni odatdagidek yarating:

```bash
dartdosh build ipa --production
```

**Nima sodir bo'ladi:**
1. ✅ Flutter IPA'ni yaratadi
2. ✅ DartDosh faylni nomlaydi va ko'chiradi
3. ✅ App Store Connect'ga avtomatik yuklaydi
4. ✅ Yuklash jarayoni va natijasini ko'rsatadi

**Misol chiqish:**
```
✅ ipa build muvaffaqiyatli yakunlandi, Xo'jayiin!
📂 Fayl saqlandi: ~/Desktop/dartdosh-builds/my_app/ipa/prod_1.0.0_100.ipa

📤 IPA App Store Connect'ga yuklanmoqda...
Fayl: ~/Desktop/dartdosh-builds/my_app/ipa/prod_1.0.0_100.ipa
Apple ID: developer@example.com
✅ IPA muvaffaqiyatli App Store Connect'ga yuklandi!
```

### Konfiguratsiya Parametrlari

| Maydon | Turi | Standart | Ta'rif |
|-------|------|---------|-------------|
| `enabled` | boolean | `false` | Avtomatik yuklashni yoqish/o'chirish |
| `apple_id` | string | `""` | Sizning Apple ID email manzilingiz |
| `app_specific_password` | string | `""` | Apple ID'dan olingan app-specific parol |

### Muammolarni Bartaraf Etish

**Xato: "IPA upload enabled but credentials not set!"**
- Konfiguratsiyada `apple_id` va `app_specific_password` to'ldirilganligiga ishonch hosil qiling

**Xato: "xcrun: error: unable to find utility"**
- Xcode o'rnatilmagan yoki buyruq qatori vositalari konfiguratsiya qilinmagan
- Mac App Store'dan Xcode'ni o'rnating
- Ishga tushiring: `xcode-select --install`

**Xato: "Authentication failed"**
- App-specific parol noto'g'ri yoki muddati tugagan bo'lishi mumkin
- Yangi app-specific parol yarating va konfiguratsiyani yangilang
- To'g'ri Apple ID'dan foydalanayotganingizga ishonch hosil qiling

**Xato: "Package upload failed"**
- Ilovangiz App Store Connect'da mavjudligini tekshiring
- iOS tarqatish sertifikatining yaroqliligini tasdiqlang
- Provisioning profilining build'ga mos kelishini ta'minlang

**Yuklash sekin yoki to'xtab qolmoqda**
- Bu katta IPA fayllari uchun normal (bir necha daqiqa davom etishi mumkin)
- Internet aloqangizni tekshiring
- Vosita progress ko'rsatadi va tugashini kutadi

### Xavfsizlik Eslatmalari

⚠️ **Muhim Xavfsizlik Mulohazalari:**

1. **Autentifikatsiya ma'lumotlarini git'ga yuklamang**
   - `build_config.json`ni `.gitignore`ga qo'shing
   - App-specific parolingizni o'z ichiga olgan fayllarni hech qachon push qilmang

2. **App-specific parollar xavfsizroq**
   - Ular alohida bekor qilinishi mumkin
   - Asosiy Apple ID parolingizga kirish bermaydi
   - Buzilgan taqdirda qayta yaratilishi mumkin

3. **Jamoa ish jarayonlari**
   - Har bir dasturchi o'z Apple ID va parolidan foydalanishi kerak
   - Yoki xavfsiz parol menejerida saqlangan umumiy autentifikatsiya ma'lumotlaridan foydalaning
   - Avtomatlashtirilgan build'lar uchun CI/CD sirlaridan foydalanishni ko'rib chiqing

### Avtomatik Yuklashni O'chirish

Autentifikatsiya ma'lumotlaringizni saqlab qolgan holda avtomatik yuklashni o'chirish uchun:

```json
"ipa_upload": {
  "enabled": false,  // ← Shunchaki false'ga o'rnating
  "apple_id": "developer@example.com",
  "app_specific_password": "abcd-efgh-ijkl-mnop"
}
```

---

## Eslatmalar

### Muhit Flaglari
* **To'liq flaglar**: `--production`, `--staging`, `--development`
* **Qisqa flaglar**: `-p`, `-prod`, `-s`, `-d`, `-dev`
* Barcha variantlar bir xil ishlaydi

### Til Qo'llab-quvvatlash
* **Qo'llab-quvvatlanadi**: `uz` (O'zbekcha), `en` (Inglizcha), `ru` (Ruscha), `tr` (Turkcha)
* **Standart**: O'zbekcha (`uz`)
* **Foydalanish**: `--language` yoki `-l` flagidan foydalaning:
  ```bash
  dartdosh build apk -p --language tr    # Turkcha
  dartdosh build apk -p -l uz            # O'zbekcha
  dartdosh build ipa -s -l en            # Inglizcha
  dartdosh build aab -d -l ru            # Ruscha
  ```
* **Yoki konfiguratsiyada o'rnating**: `dartdosh_config/settings.json`da:
  ```json
  {
    "language": "tr"
  }
  ```
* **Qo'llab-quvvatlanmaydigan til**: Ogohlantirish bilan avtomatik ravishda inglizchaga qaytadi:
  ```
  ⚠️  Ogohlantirish: "fr" tili qo'llab-quvvatlanmaydi. Inglizchaga qaytilmoqda.
     Qo'llab-quvvatlanadigan tillar: uz (O'zbekcha), en (Inglizcha), ru (Ruscha), tr (Turkcha)
  ```

### Build Xulq-atvori
* APK build'lari uchun `--split` avtomatik ravishda `--split-per-abi` qo'shadi
* Asosiy buyruqdan keyingi har qanday qo'shimcha flaglar avtomatik ravishda qo'shiladi
* Build raqami build boshlanishidan **oldin** oshiriladi
* Barcha xabarlar shaxsiylashtirilgan (O'zbekcha uchun "Xo'jayiin", Inglizcha/Ruscha uchun "Boss")
* Yo'qolgan `build_config.json` avtomatik ravishda standart sozlamalar bilan yaratiladi
* Progress bar tanlangan tilingizda real vaqt build bosqichlarini ko'rsatadi
