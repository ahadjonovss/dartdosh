# Cleaning Build Output Files

← [Back to docs](../README.en.md)

---

DartDosh accumulates APK, IPA, and AAB files in your output folder over time. The `dartdosh clean` command lets you remove them selectively — by target, environment, or all at once — and shows how much space was freed.

## Usage

```bash
dartdosh clean <target> [environment]
```

| Command | What it does |
|---------|--------------|
| `dartdosh clean all` | Removes everything in the output folder |
| `dartdosh clean apk` | Removes all APK files |
| `dartdosh clean ipa` | Removes all IPA files |
| `dartdosh clean aab` | Removes all AAB files |
| `dartdosh clean apk -d` | Removes only dev APK files |
| `dartdosh clean apk -p` | Removes only production APK files |
| `dartdosh clean apk -s` | Removes only staging APK files |

---

## Example Output

```
🗑️ Cleaning apk (dev)...
✅ Done! 4 file(s) deleted, 87.3 MB freed, Boss!
```

If nothing is found:
```
ℹ️ Nothing to delete, Boss!
```

---

## Notes

- Files are deleted from `output_path/project_name/{apk|ipa|aab}/` as configured in `build_config.json`
- Environment filter matches the file name prefix: `dev_`, `prod_`, `stg_`
- The command reads config from `dartdosh_config/` — run `dartdosh init` first if not set up

← [Back to docs](../README.en.md)
