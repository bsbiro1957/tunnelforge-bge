#!/usr/bin/env bash
set -euo pipefail

# 1. A hivatalos TunnelForge 0.7.4 forrás letöltése klónozással a fix tag-ről
git clone --branch v0.7.4 --depth 1 https://github.com/evokelektrique/tunnel-forge.git tunnel-forge-src

# 2. A patch másolása és alkalmazása a letöltött forrásra
cp bge_dh2.patch tunnel-forge-src/
cd tunnel-forge-src

git apply bge_dh2.patch

# 3. Build folyamat futtatása
flutter pub get
cd android/gvisor
go mod download
cd ../..
make build-debug

# 4. APK másolása a fő mappába, hogy a workflow el tudja érni
mkdir -p ../build/app/outputs/flutter-apk/
cp build/app/outputs/flutter-apk/app-debug.apk ../build/app/outputs/flutter-apk/app-debug.apk || cp android/app/build/outputs/apk/debug/app-debug.apk ../build/app/outputs/flutter-apk/app-debug.apk

echo "APK elkészült!"
