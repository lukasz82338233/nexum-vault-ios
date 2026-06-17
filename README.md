# Nexum Vault iOS

[![Nexum Vault iOS CI](https://github.com/lukasz82338233/nexum-vault-ios/actions/workflows/ci.yml/badge.svg)](https://github.com/lukasz82338233/nexum-vault-ios/actions/workflows/ci.yml)

Experimental iOS vault for QR-based Nexum challenge signing with Falcon signatures.

The app is designed for an offline/private-key flow:

1. Create or import a local vault key.
2. Scan a Nexum challenge QR code.
3. Review the challenge payload on device.
4. Sign the canonical challenge.
5. Return a response QR / callback payload.

## Status

This repository is an iOS prototype. Treat the Falcon bridge and QR signing protocol as experimental until reviewed.

The GitHub Actions workflow currently runs:

- `verify-build-ready.sh`
- `swift test` for `NexumVaultCore`

Full app builds and device testing still require Xcode on macOS.

## Requirements

- macOS 14+
- Xcode 15+
- iOS 17+ device for real biometrics, camera and keychain behavior

The simulator can be useful for UI work, but it is not a full security test target.

## First-time setup

```bash
git clone https://github.com/lukasz82338233/nexum-vault-ios.git
cd nexum-vault-ios
bash setup-falcon.sh
open NexumVault.xcodeproj
```

`setup-falcon.sh` verifies that the vendored Falcon C files are present in:

```text
NexumVault/FalconC/include/
NexumVault/FalconC/src/
```

To refresh them from another local Falcon source tree:

```bash
FALCON_VENDOR_DIR=/path/to/falcon bash setup-falcon.sh
```

## Xcode configuration

1. Open `NexumVault.xcodeproj`.
2. Select the `NexumVault` target.
3. Open `Signing & Capabilities`.
4. Set your Apple development team.
5. Change the bundle identifier if needed.
6. Connect an iOS 17+ device.
7. Build and run on the device.

## Local checks

```bash
bash verify-build-ready.sh
swift test
```

## Security notes

- Private keys must remain device-local.
- Responses must not include private key material.
- Challenge JSON must be canonicalized before signing.
- QR payloads must be treated as untrusted input.
- This prototype needs cryptographic and mobile security review before production use.

## Project structure

```text
NexumVault.xcodeproj/
Package.swift
NexumVault/
  App/
  Models/
  Services/
  Views/
  Bridging/FalconBridge.h
  FalconC/
    include/
    src/
  Resources/Info.plist
  NexumVault.entitlements
NexumVaultCore/
  Sources/
  Tests/
NexumVaultTests/
  TestVectors/
```
