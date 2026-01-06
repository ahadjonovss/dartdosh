# DartDosh CLI – Kullanım Kılavuzu

**📖 Diğer dillerde okuyun:**
[🇬🇧 English](../README.md) | [🇺🇿 O'zbekcha](README.uz.md) | [🇷🇺 Русский](README.ru.md)

---

`DartDosh`, otomatik versiyon yönetimi, çoklu dil desteği ve akıllı çıktı yönetimi ile Flutter build işlemlerini basitleştiren güçlü bir CLI aracıdır.

## 🌍 Çoklu Dil Desteği

**DartDosh artık 4 dili destekliyor!**

- 🇺🇿 **Özbekçe** (uz) - "Xo'jayiin" tarzı - Varsayılan
- 🇬🇧 **İngilizce** (en) - "Boss" tarzı
- 🇷🇺 **Rusça** (ru) - "Босс" tarzı
- 🇹🇷 **Türkçe** (tr) - "Patron" tarzı - **YENİ!**

## 📺 Video Eğitimi

[![DartDosh Tutorial](https://img.youtube.com/vi/QpNVwk4SVZA/maxresdefault.jpg)](https://youtu.be/QpNVwk4SVZA?si=kV7kTtHcnZLfv1ZP)

YouTube'da tam eğitimi izleyin: [DartDosh - Flutter Build Automation](https://youtu.be/QpNVwk4SVZA?si=kV7kTtHcnZLfv1ZP)

---

```bash
dartdosh build <target> --<environment> [extra flags]
```

**Örnekler:**

```bash
# Ortam ile (flavor builds) - otomatik versiyon yönetimi
dartdosh build ipa --production --split
dartdosh build apk --development --other-flag
dartdosh build appbundle --staging

# Kısa bayraklar (kullanışlı!)
dartdosh build apk -p              # production
dartdosh build apk -prod           # production
dartdosh build apk -d              # development
dartdosh build apk -dev            # development
dartdosh build apk -s              # staging

# Ortam olmadan - sade Flutter build (versiyon yönetimi yok)
dartdosh build apk                 # flutter build apk
dartdosh build apk --release       # flutter build apk --release
dartdosh build ipa --split         # flutter build ipa --split-per-abi
```

---

## Gereksinimler

* Dart SDK ≥ 3.0
* Flutter SDK yüklü
* Terminal (Mac/Linux/Windows)

---

## Kurulum

### pub.dev'den Kurulum

```bash
dart pub global activate dartdosh
```

### PATH'e Ekleme (gerekirse)

**Mac/Linux (`.zshrc` veya `.bashrc`):**

```bash
export PATH="$PATH:$HOME/.pub-cache/bin"
source ~/.zshrc
```

**Windows PowerShell:**

```powershell
$env:PATH += ";$env:USERPROFILE\.pub-cache\bin"
```

---

## Yapılandırma

### DartDosh'u Başlatma

Flutter projenizde önce bu komutu çalıştırın:

```bash
dartdosh init
```

Bu, 2 dosya içeren `dartdosh_config` klasörünü oluşturur:

### 1. `build_config.json` (Takım Paylaşımlı - Git Takipli)

Takımınız için build komutları. Herkes aynı komutları kullanır:

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

### 2. `settings.json` (Kişisel - Git Yoksayıldı)

Kişisel ayarlarınız. Her geliştirici kendine ait ayarlara sahiptir:

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

**Neden 2 dosya?**

- `build_config.json` → Takım build komutlarını paylaşır (Git takipli)
- `settings.json` → Apple ID gibi kişisel ayarlarınız (Git yoksayıldı)
- Takımda artık kimlik bilgisi çakışmaları yok!

**Ayar Parametreleri:**

* `language`: Arayüz dili
  - `uz` (Özbekçe), `en` (İngilizce), `ru` (Rusça), `tr` (Türkçe)
  - Varsayılan: `uz`

* `project_name`: Build'leri organize etmek için proje adı
  - Varsayılan: `pubspec.yaml` dosyasından okunur

* `auto_increment_build_number`: Otomatik versiyon artırma
  - `true`: Her build öncesi build numarasını artırır
  - `false`: Mevcut versiyonu korur (varsayılan)

* `output_path`: Build'lerin kaydedileceği yer
  - Varsayılan: `~/Desktop/dartdosh-builds`
  - Mutlak veya göreceli yol

* `ipa_upload`: IPA'yı App Store'a otomatik yükleme
  - `enabled`: true/false
  - `apple_id`: Apple ID'niz
  - `app_specific_password`: appleid.apple.com'dan alın
  - Sadece macOS

* `firebase_distribution`: APK'yı Firebase App Distribution'a otomatik yükleme (ortam bazında)
  - Her ortam (production, staging, development) şunları içerir:
    - `enabled`: true/false - Bu ortam için yüklemeyi etkinleştir/devre dışı bırak
  - App ID ve test grupları `build_config.json` dosyasında yapılandırılır
  - Firebase CLI kurulu olmalıdır

**App-Specific Password Nasıl Alınır:**
1. https://appleid.apple.com adresine gidin
2. Güvenlik → Şifre Oluştur
3. "DartDosh" olarak adlandırın
4. Kopyalayıp settings.json'a yapıştırın

**Firebase App Distribution Nasıl Ayarlanır:**
1. Firebase CLI'yi kurun: `npm install -g firebase-tools`
2. Giriş yapın: `firebase login`
3. App ID'yi Firebase Console → Proje Ayarları'ndan alın
4. Test gruplarını Firebase Console → App Distribution'da ekleyin
5. `settings.json` dosyasında etkinleştirin ve yapılandırın

---

## Kullanım

```bash
dartdosh build <target> [--<environment>] [extra flags]
```

**Parametreler:**

* `<target>`: Build hedefi
  - `apk` - Android APK
  - `ipa` - iOS IPA
  - `appbundle` veya `aab` - Android App Bundle (her iki komut da desteklenir)

* `<environment>`: Build ortamı (OPSİYONEL - birden fazla bayrak varyantı desteklenir!)
  - **Production**: `--production`, `-p`, `-prod`
  - **Staging**: `--staging`, `-s`
  - **Development**: `--development`, `-d`, `-dev`
  - **Not**: Ortam belirtilmezse, versiyon yönetimi olmadan sade Flutter build çalışır

* `[extra flags]`: Ek Flutter build bayrakları
  - `--split` - APK build'leri için otomatik olarak `--split-per-abi` ekler
  - `--obfuscate` - Dart kodunu gizle
  - `--dart-define=KEY=VALUE` - Ortam değişkenlerini tanımla
  - Diğer Flutter build bayrakları

---

## 📱 iOS (IPA) Build Hızlı Kılavuz

DartDosh ile iOS uygulamaları oluşturmak basittir ve App Store Connect'e otomatik yükleme içerir.

### Ön Koşullar

1. **Xcode ile macOS** - iOS build'leri için gerekli
2. **Geçerli Apple Developer Hesabı** - Dağıtım build'leri için
3. **Kod İmzalama Kurulumu** - Xcode'da yapılandırılmış sertifikalar ve provisioning profilleri

### Temel IPA Build

```bash
# Production build
dartdosh build ipa --production
dartdosh build ipa -p

# Staging build
dartdosh build ipa --staging
dartdosh build ipa -s

# Obfuscation ile
dartdosh build ipa -p --obfuscate

# dart-define değişkenleri ile
dartdosh build ipa -p --dart-define=API_URL=https://api.production.com
```

### App Store Connect'e Otomatik Yükleme

DartDosh, başarılı bir build'den sonra IPA'nızı otomatik olarak App Store Connect'e yükleyebilir.

**1. App-Specific Password Alın**

1. [appleid.apple.com](https://appleid.apple.com) adresine gidin
2. Apple ID'nizle oturum açın
3. **Güvenlik** bölümünde → **Uygulamaya Özel Şifreler** → **Şifre Oluştur**
4. "DartDosh" olarak adlandırın ve şifreyi kopyalayın (format: `xxxx-xxxx-xxxx-xxxx`)

**2. `build_config.json` dosyasında yapılandırın**

```json
{
  "ipa_upload": {
    "enabled": true,
    "apple_id": "your-email@example.com",
    "app_specific_password": "xxxx-xxxx-xxxx-xxxx"
  }
}
```

**3. Build Yapın ve Yükleyin**

```bash
dartdosh build ipa -p
```

**Çıktı:**
```
[████████████████████████████████] 100% - [ipa - production] - Hazır!
✅ ipa build başarıyla tamamlandı, Patron!
✅ Build kaydedildi: ~/Desktop/dartdosh-builds/my_app/ipa/prod_1.0.0_100.ipa, Patron!

📤 IPA App Store Connect'e yükleniyor...
📊 Yükleme devam ediyor...
✅ IPA başarıyla App Store Connect'e yüklendi, Patron!

⏱️ Toplam süre: 180.5 saniye
```

### Çıktı Dosyaları

IPA dosyaları otomatik olarak organize edilir:

```
~/Desktop/dartdosh-builds/
└── my_app/
    └── ipa/
        ├── prod_1.0.0_100.ipa
        ├── prod_1.0.0_101.ipa
        └── stg_1.0.0_50.ipa
```

**Dosya adlandırma formatı:** `{env}_{version}_{buildNumber}.ipa`

### Önemli Notlar

- **Yükleme macOS gerektirir** - `xcrun altool` kullanır (Xcode'a dahil)
- **Yükleme opsiyoneldir** - Devre dışı bırakmak için `"enabled": false` ayarlayın
- **Güvenlik** - Kimlik bilgilerini korumak için `build_config.json` dosyasını `.gitignore`'a ekleyin
- **Uygulama App Store Connect'te var olmalıdır** - Önce uygulamanızı [appstoreconnect.apple.com](https://appstoreconnect.apple.com)'da oluşturun
- **Yükleme gönderme yapmaz** - Sadece build'i yükler; App Store Connect üzerinden göndermeniz gerekir

### Sorun Giderme

**Yükleme başarısız mı oluyor?**
- Apple ID'nizi ve app-specific password'ünüzü doğrulayın
- Uygulamanın App Store Connect'te var olduğundan emin olun
- İnternet bağlantısını kontrol edin
- Xcode komut satırı araçlarının kurulu olduğundan emin olun: `xcode-select --install`

**Build başarısız mı oluyor?**
- Xcode'da kod imzalamayı kontrol edin
- Provisioning profillerinin geçerli olduğunu doğrulayın
- iOS kurulumunu kontrol etmek için `flutter doctor` çalıştırın

---

## Özellikler

### 🌍 Çoklu Dil Desteği
DartDosh, tüm arayüz mesajları ve ilerleme göstergeleri için üç dili destekler:

* **Özbekçe (uz)** - "Xo'jayiin" (Patron) hitabı ile varsayılan dil
* **İngilizce (en)** - "Boss" (Patron) hitabı ile profesyonel İngilizce arayüz
* **Rusça (ru)** - "Босс" (Patron) hitabı ile Rusça arayüz

**Dil Ayarlama:**
```json
{
  "language": "en"  // build_config.json'da ayarlayın
}
```

**Dil Özellikleri:**
* Tüm log mesajları çevrilmiş
* İlerleme çubuğu aşamaları yerelleştirilmiş
* Seçili dilde build durum mesajları
* Kültürel mizah içeren bağış mesajları
* Desteklenmeyen diller için uyarı ile otomatik İngilizce'ye geçiş

**Örnek Özbekçe:**
```
📈 Yangi build number: 46 (oldingi: 45), Xo'jayiin!
[████████████████░░░░░░░░░░░░░░]  60% - [apk - production] - Bundle yaratilmoqda...
✅ apk build muvaffaqiyatli yakunlandi, Xo'jayiin!
```

**Örnek İngilizce:**
```
📈 New build number: 46 (previous: 45), Boss!
[████████████████░░░░░░░░░░░░░░]  60% - [apk - production] - Creating bundle...
✅ apk build completed successfully, Boss!
```

### 🤖 Otomatik Yapılandırma
Flutter projenizde `build_config.json` dosyası mevcut değilse, DartDosh:
1. **Varsayılan ayarlarla yapılandırmayı oluşturur**
2. **IDE'nizde otomatik olarak açar** incelemeniz için
3. **Çalıştırmayı durdurur** ve komutu yeniden çalıştırmanızı ister

Bu, ilk build öncesi yapılandırmayı inceleyip ayarlamanızı sağlar.

**Örnek iş akışı:**
```bash
# İlk çalıştırma (yapılandırma yok)
dartdosh build apk --production
# Çıktı: Yapılandırma oluşturuldu ve IDE'de açıldı, lütfen inceleyin ve tekrar çalıştırın

# İkinci çalıştırma (yapılandırma incelendi)
dartdosh build apk --production
# Çıktı: Normal build devam eder
```

### 🔢 Otomatik Versiyon Yönetimi (Opsiyonel)

**Ortam bayrakları kullanırken** (flavor builds) ve `auto_increment_build_number: true` ise, DartDosh otomatik olarak:
1. `pubspec.yaml` dosyasından mevcut versiyonu okur
2. Build numarasını 1 artırır
3. `pubspec.yaml` dosyasını yeni build numarasıyla günceller

**Örnek:**
```yaml
# Build öncesi (ortam bayrağı ve auto_increment etkin)
version: 1.2.3+45

# Build sonrası
version: 1.2.3+46
```

**Notlar**:
- **Varsayılan**: `false` (otomatik artırma varsayılan olarak devre dışı)
- Versiyon artırımı sadece flavor build'leri için gerçekleşir (ortam bayrağı ile)
- Yapılandırmada `auto_increment_build_number: true` ayarlayarak etkinleştirin
- Sade build'ler (`dartdosh build apk`) asla versiyon numaralarını değiştirmez

### 📦 Akıllı Dosya Adlandırma

**Flavor build'leri için** (ortam bayrakları ile), build edilen dosyalar otomatik olarak şu formatta yeniden adlandırılır:
```
{shortEnv}_{version}_{buildNumber}.{extension}
```

**Ortam kısa adları:**
- `production` → `prod`
- `development` → `dev`
- `staging` → `stg`

**Örnekler:**
* `prod_1.2.3_46.apk`
* `stg_2.0.0_12.ipa`
* `dev_1.5.0_78.aab`

Bölünmüş APK'ler için:
* `prod_1.2.3_46_arm64-v8a.apk`
* `prod_1.2.3_46_armeabi-v7a.apk`
* `prod_1.2.3_46_x86_64.apk`

**Sade build'ler için** (ortam olmadan), dosyalar şu formatta yeniden adlandırılır:
```
{target}_{version}_{buildNumber}.{extension}
```

**Örnekler:**
* `apk_1.2.3_46.apk`
* `ipa_2.0.0_12.ipa`
* `appbundle_1.5.0_78.aab`

Not: Sade build'ler versiyonu artırmaz, ancak yine de yeniden adlandırılır ve output_path'e taşınır.

### 📁 Çıktı Yolu Yönetimi

`build_config.json` dosyasında `output_path` belirtilmişse:
* Build edilen dosyalar organize yapı ile belirtilen dizine **kopyalanır**
* Dosyalar şu şekilde organize edilir: `output_path/project_name/{apk|ipa|aab}/`
* Her build tipi daha iyi organizasyon için kendi alt klasörünü alır
* Orijinal dosyalar build dizininde kalır
* Dizin yapısı otomatik olarak oluşturulur

**Örnek yapı:**
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

`output_path` olmadan:
* Dosyalar sadece build dizininde **yeniden adlandırılır**

---

## 🚀 App Store Connect'e IPA Otomatik Yükleme

DartDosh, başarılı bir build'den sonra Apple'ın resmi Transporter aracını kullanarak IPA dosyalarınızı otomatik olarak App Store Connect'e yükleyebilir.

### Ön Koşullar

1. **Xcode kurulu macOS** - `xcrun iTMSTransporter` için gerekli
2. **Geçerli Apple Developer Hesabı** - App Store Connect'te oluşturulmuş uygulama ile
3. **Geçerli Sertifikalar ve Provisioning Profilleri** - iOS Distribution sertifikası ve provisioning profili
4. **App-Specific Password** - Apple ID ayarlarından oluşturulmuş

### Adım 1: App-Specific Password Oluşturma

1. https://appleid.apple.com adresine gidin
2. Apple ID'nizle oturum açın (App Store Connect için kullanılan)
3. **Güvenlik** bölümüne gidin
4. **Uygulamaya Özel Şifreler** altında, **Şifre Oluştur**'a tıklayın
5. Bir etiket girin (örn., "DartDosh CLI Tool")
6. **Oluştur**'a tıklayın
7. **Oluşturulan şifreyi kopyalayın** (format: `xxxx-xxxx-xxxx-xxxx`)
   - ⚠️ Bu şifreyi kaydedin - tekrar görüntüleyemezsiniz!

### Adım 2: build_config.json Yapılandırması

`build_config.json` dosyanızı açın ve `ipa_upload` bölümünü ekleyin/güncelleyin:

```json
{
  "language": "uz",
  "project_name": "my_app",
  "auto_increment_build_number": false,
  "output_path": "~/Desktop/dartdosh-builds",
  "ipa_upload": {
    "enabled": true,                                    // ← true olarak ayarlayın
    "apple_id": "developer@example.com",                // ← Apple ID'niz
    "app_specific_password": "abcd-efgh-ijkl-mnop"     // ← Oluşturulan şifreyi yapıştırın
  }
}
```

### Adım 3: Build Yapın ve Yükleyin

IPA'nızı her zamanki gibi build edin:

```bash
dartdosh build ipa --production
```

**Neler olur:**
1. ✅ Flutter IPA'yı build eder
2. ✅ DartDosh dosyayı yeniden adlandırır ve taşır
3. ✅ App Store Connect'e otomatik olarak yükler
4. ✅ Yükleme ilerlemesini ve sonucunu gösterir

**Örnek çıktı:**
```
✅ ipa build başarıyla tamamlandı, Patron!
📂 Dosya kaydedildi: ~/Desktop/dartdosh-builds/my_app/ipa/prod_1.0.0_100.ipa

📤 IPA App Store Connect'e yükleniyor...
Dosya: ~/Desktop/dartdosh-builds/my_app/ipa/prod_1.0.0_100.ipa
Apple ID: developer@example.com
✅ IPA başarıyla App Store Connect'e yüklendi!
```

### Yapılandırma Seçenekleri

| Alan | Tip | Varsayılan | Açıklama |
|-------|------|---------|-------------|
| `enabled` | boolean | `false` | Otomatik yüklemeyi etkinleştir/devre dışı bırak |
| `apple_id` | string | `""` | Apple ID e-posta adresiniz |
| `app_specific_password` | string | `""` | Apple ID'den app-specific password |

### Sorun Giderme

**Hata: "IPA upload enabled but credentials not set!"**
- Yapılandırmada hem `apple_id` hem de `app_specific_password` doldurduğunuzdan emin olun

**Hata: "xcrun: error: unable to find utility"**
- Xcode kurulu değil veya komut satırı araçları yapılandırılmamış
- Mac App Store'dan Xcode kurun
- Çalıştırın: `xcode-select --install`

**Hata: "Authentication failed"**
- App-specific password yanlış veya süresi dolmuş olabilir
- Yeni bir app-specific password oluşturun ve yapılandırmayı güncelleyin
- Doğru Apple ID kullandığınızdan emin olun

**Hata: "Package upload failed"**
- Uygulamanızın App Store Connect'te var olduğunu kontrol edin
- iOS distribution sertifikasının geçerli olduğunu doğrulayın
- Provisioning profilinin build ile eşleştiğinden emin olun

**Yükleme yavaş veya takılıyor**
- Bu büyük IPA dosyaları için normaldir (birkaç dakika sürebilir)
- İnternet bağlantınızı kontrol edin
- Araç ilerlemeyi gösterecek ve tamamlanmasını bekleyecektir

### Güvenlik Notları

⚠️ **Önemli Güvenlik Hususları:**

1. **Kimlik bilgilerini git'e commit etmeyin**
   - `build_config.json` dosyasını `.gitignore`'a ekleyin
   - App-specific password içeren dosyaları asla push etmeyin

2. **App-specific password'ler daha güvenlidir**
   - Ayrı ayrı iptal edilebilirler
   - Ana Apple ID şifrenize erişim vermezler
   - Tehlikeye girerse yeniden oluşturulabilir

3. **Takım iş akışları**
   - Her geliştirici kendi Apple ID ve şifresini kullanmalıdır
   - Veya güvenli şifre yöneticisinde saklanan paylaşılan kimlik bilgileri kullanın
   - Otomatik build'ler için CI/CD secret'larını kullanmayı düşünün

### Otomatik Yüklemeyi Devre Dışı Bırakma

Kimlik bilgilerinizi koruyarak otomatik yüklemeyi devre dışı bırakmak için:

```json
"ipa_upload": {
  "enabled": false,  // ← Sadece false olarak ayarlayın
  "apple_id": "developer@example.com",
  "app_specific_password": "abcd-efgh-ijkl-mnop"
}
```

---

## Notlar

### Ortam Bayrakları
* **Tam bayraklar**: `--production`, `--staging`, `--development`
* **Kısa bayraklar**: `-p`, `-prod`, `-s`, `-d`, `-dev`
* Tüm varyantlar aynı şekilde çalışır

### Dil Desteği
* **Desteklenen**: `uz` (Özbekçe), `en` (İngilizce), `ru` (Rusça), `tr` (Türkçe)
* **Varsayılan**: Özbekçe (`uz`)
* **Kullanım**: `--language` veya `-l` bayrağını kullanın:
  ```bash
  dartdosh build apk -p --language tr    # Türkçe
  dartdosh build apk -p -l uz            # Özbekçe
  dartdosh build ipa -s -l en            # İngilizce
  dartdosh build aab -d -l ru            # Rusça
  ```
* **Veya yapılandırmada ayarlayın**: `dartdosh_config/settings.json` dosyasında:
  ```json
  {
    "language": "tr"
  }
  ```
* **Desteklenmeyen dil**: Otomatik olarak uyarı ile İngilizce'ye geçer:
  ```
  ⚠️  Uyarı: "fr" dili desteklenmiyor. İngilizce'ye geçiliyor.
     Desteklenen diller: uz (Özbekçe), en (İngilizce), ru (Rusça), tr (Türkçe)
  ```

### Build Davranışı
* APK build'leri için, `--split` otomatik olarak `--split-per-abi` ekler
* Temel komuttan sonraki ek bayraklar otomatik olarak eklenir
* Build numarası build başlamadan **önce** artırılır
* Tüm mesajlar kişiselleştirilmiştir (Özbekçe için "Xo'jayiin", İngilizce/Rusça için "Boss")
* Eksik `build_config.json` otomatik olarak varsayılan ayarlarla oluşturulur
* İlerleme çubuğu seçtiğiniz dilde gerçek zamanlı build aşamalarını gösterir
