#!/usr/bin/env bash
set -euo pipefail
git checkout v0.7.4
git apply bge_dh2.patch
flutter pub get
cd android/gvisor
go mod download
cd ../..
make build-debug
echo "APK: build/app/outputs/flutter-apk/app-debug.apk"
