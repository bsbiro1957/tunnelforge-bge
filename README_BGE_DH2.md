# TunnelForge 0.7.4 – BGE DH2 test patch

Ez egy célzott tesztpatch a BGE L2TP/IPsec kapcsolat vizsgálatához.

## Mit módosít?

A TunnelForge 0.7.4 eredeti `ikev1.c` fájlja IKE Phase 1-ben DH Group 14 / MODP2048-at használ. A forrás ezt ténylegesen hard-code-olja, és az SA proposalban is `0x000e` (Group 14) szerepel.

Ez a patch **DH Group 2 / MODP1024** használatára állítja át a Phase 1-et:

- IKEv1 Main Mode
- PSK
- AES-128-CBC + SHA1
- 3DES-CBC + SHA1 alternatíva
- DH Group 2 / MODP1024

Fontos: ez **DH2-only teszt build**, nem végleges BGE-kompatibilitási állítás. A BGE nyilvános dokumentációja nem közli a szerver Phase-1 DH csoportját. A cél az, hogy a jelenlegi `NO_PROPOSAL_CHOSEN` hiba megszűnik-e.

## Miért ezt teszteljük?

A te TB336FU / Android 16 / TunnelForge 0.7.4 logodban a szerver IKE MM2-ben `NOTIFY type=14 (0x000e)` választ ad, ami az IKEv1 `NO_PROPOSAL_CHOSEN` értesítés. Ez a Phase 1 proposal-egyeztetésnél történik.

A 0.7.4 forrásában a DH14 valóban hard-coded: `IKE_DH_PUBKEY_BYTES=256`, `rfc3526_modp2048_p`, valamint a proposal group attribute `0x000e`.

## Fontos

Ezt a patch-et a TunnelForge 0.7.4 (`v0.7.4`) forrására készítettem. A hivatalos projekt jelenlegi fejlesztési környezete Flutter/Dart 3.11+, Android SDK/NDK és CMake; a README szerint `make build-debug` használható debug APK készítésére.

Ha az APK-t sikerül felépíteni és telepíteni a tabletre, a teszt után küldd el a TunnelForge log végét.

### Mit várunk siker esetén?

A mostani:
`IKE MM msg2 ... type=14 (0x000e)`
helyett a lognak tovább kell jutnia legalább:
`IKE MM msg4`
majd `IKE MM msg5/msg6`
felé.

Ha továbbjut, akkor a DH2 valóban elfogadható a szerver számára, és innen a következő kompatibilitási pontot vizsgáljuk.

## Forrás

TunnelForge 0.7.4:
https://github.com/evokelektrique/tunnel-forge/releases/tag/v0.7.4

A módosítás alapja:
android/app/src/main/cpp/ikev1.c
