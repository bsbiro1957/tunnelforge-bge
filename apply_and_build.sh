#!/usr/bin/env bash
set -euo pipefail

# Patch alkalmazása
git apply bge_dh2.patch

# Függőségek letöltése és build
flutter pub get
cd android/gvisor
go mod download
cd ../..
make build-debug

echo "APK: build/app/outputs/flutter-apk/app-debug.apk"
