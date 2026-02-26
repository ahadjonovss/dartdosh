/// Embedded Python script for Google Play Store upload via Android Publisher API.
///
/// This script is written to a temp file at runtime and deleted after use.
/// It uses google-api-python-client to upload AAB files to Google Play.
///
/// Required Python packages (auto-installed if missing):
///   pip install google-api-python-client google-auth
const String playStoreUploadScript = r'''
import sys
import subprocess


def ensure_deps():
    try:
        import googleapiclient
        import google.oauth2.service_account
    except ImportError:
        print("INSTALLING_DEPS", flush=True)
        result = subprocess.run(
            [sys.executable, "-m", "pip", "install", "--user", "--quiet",
             "google-api-python-client", "google-auth"],
            capture_output=True
        )
        if result.returncode != 0:
            print("DEPS_FAILED", flush=True)
            sys.exit(1)
        print("DEPS_INSTALLED", flush=True)


def upload(package_name, service_account_json, aab_path, track):
    from google.oauth2 import service_account
    from googleapiclient.discovery import build
    from googleapiclient.http import MediaFileUpload

    creds = service_account.Credentials.from_service_account_file(
        service_account_json,
        scopes=["https://www.googleapis.com/auth/androidpublisher"],
    )
    service = build("androidpublisher", "v3", credentials=creds)

    print("UPLOAD_STARTED", flush=True)

    # Open a new edit
    edit = service.edits().insert(packageName=package_name, body={}).execute()
    edit_id = edit["id"]

    try:
        # Upload AAB
        bundle = service.edits().bundles().upload(
            packageName=package_name,
            editId=edit_id,
            media_body=MediaFileUpload(
                aab_path,
                mimetype="application/octet-stream",
                resumable=True,
            ),
        ).execute()

        print(f"BUNDLE_UPLOADED:{bundle['versionCode']}", flush=True)

        # Assign to track
        service.edits().tracks().update(
            packageName=package_name,
            editId=edit_id,
            track=track,
            body={
                "releases": [
                    {
                        "versionCodes": [str(bundle["versionCode"])],
                        "status": "completed",
                    }
                ]
            },
        ).execute()

        # Commit the edit
        service.edits().commit(
            packageName=package_name, editId=edit_id
        ).execute()

        print("UPLOAD_SUCCESS", flush=True)

    except Exception as e:
        # Discard edit on failure
        try:
            service.edits().delete(
                packageName=package_name, editId=edit_id
            ).execute()
        except Exception:
            pass
        print(f"UPLOAD_ERROR:{e}", file=sys.stderr, flush=True)
        sys.exit(1)


if __name__ == "__main__":
    if len(sys.argv) < 5:
        print(
            "Usage: script.py <package_name> <service_account_json> <aab_path> <track>",
            file=sys.stderr,
        )
        sys.exit(1)

    ensure_deps()
    upload(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
''';
