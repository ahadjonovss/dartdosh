# Language Support

← [Back to docs](../README.en.md)

---

DartDosh supports 4 languages for all CLI messages, progress stages, and log output.

| Code | Language | Style |
|------|----------|-------|
| `uz` | Uzbek | "Xo'jayiin" — **default** |
| `en` | English | "Boss" |
| `ru` | Russian | "Босс" |
| `tr` | Turkish | "Patron" |

---

## Set language permanently

In `dartdosh_config/settings.json`:

```json
{
  "language": "en"
}
```

---

## Set language for one build

Use the `-l` or `--language` flag:

```bash
dartdosh build apk -p -l en   # English
dartdosh build apk -p -l uz   # Uzbek
dartdosh build apk -p -l ru   # Russian
dartdosh build apk -p -l tr   # Turkish
```

The flag overrides the language in `settings.json` for that run only.

---

## Example output

**Uzbek (`uz`):**
```
📈 Yangi build number: 46 (oldingi: 45), Xo'jayiin!
[████████████░░░░░░]  60% - [apk - production] - Bundle yaratilmoqda...
✅ apk build muvaffaqiyatli yakunlandi, Xo'jayiin!
```

**English (`en`):**
```
📈 New build number: 46 (previous: 45), Boss!
[████████████░░░░░░]  60% - [apk - production] - Creating bundle...
✅ apk build completed successfully, Boss!
```

---

## Unsupported language

If an unsupported language code is set, DartDosh falls back to English and shows a warning:

```
⚠️  Warning: Language "fr" is not supported. Falling back to English.
   Supported languages: uz (Uzbek), en (English), ru (Russian), tr (Turkish)
```
