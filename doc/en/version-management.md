# Version Management & File Naming

← [Back to docs](../README.en.md)

---

## Auto Build Number Increment

Enable in `dartdosh_config/settings.json`:

```json
{
  "auto_increment_build_number": true
}
```

When enabled, DartDosh increments the build number in `pubspec.yaml` **before** each flavor build:

```yaml
# Before
version: 1.2.3+45

# After
version: 1.2.3+46
```

> Only applies to flavor builds (with `-p`, `-s`, `-d` flags). Plain builds never modify the version.

---

## Smart File Naming

Built files are automatically renamed using this format:

```
{env}_{version}_{buildNumber}.{ext}
```

**Environment short names:**

| Environment | Short name |
|-------------|------------|
| production | `prod` |
| staging | `stg` |
| development | `dev` |

**Examples:**
```
prod_1.2.3_46.apk
stg_2.0.0_12.ipa
dev_1.5.0_78.aab
```

**Split APKs** (`--split` flag):
```
prod_1.2.3_46_arm64-v8a.apk
prod_1.2.3_46_armeabi-v7a.apk
prod_1.2.3_46_x86_64.apk
```

> Plain builds (no environment) use format: `apk_1.2.3_46.apk`

---

## Output Folder

Configure where builds are saved in `settings.json`:

```json
{
  "output_path": "~/Desktop/dartdosh-builds"
}
```

Files are organized automatically:

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

If `output_path` is not set, files are only renamed in the Flutter build output directory.
