#!/bin/bash
# setup-falcon.sh - verify or refresh Falcon C sources for the Xcode target.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEST_DIR="${SCRIPT_DIR}/NexumVault/FalconC"
VENDOR_DIR="${FALCON_VENDOR_DIR:-}"

required_headers=(
  falcon.h
  internal.h
  shake.h
  fpr-double.h
)

required_sources=(
  falcon-enc.c
  falcon-fft.c
  falcon-keygen.c
  falcon-sign.c
  falcon-vrfy.c
  frng.c
  shake.c
)

if [ -n "$VENDOR_DIR" ]; then
  if [ ! -d "$VENDOR_DIR" ]; then
    echo "ERROR: FALCON_VENDOR_DIR does not exist: $VENDOR_DIR"
    exit 1
  fi

  mkdir -p "$DEST_DIR/src" "$DEST_DIR/include"

  for f in "${required_headers[@]}"; do
    cp "$VENDOR_DIR/$f" "$DEST_DIR/include/"
  done

  for f in "${required_sources[@]}"; do
    cp "$VENDOR_DIR/$f" "$DEST_DIR/src/"
  done

  echo "Falcon C sources refreshed from $VENDOR_DIR"
fi

missing=0

for f in "${required_headers[@]}"; do
  if [ ! -f "$DEST_DIR/include/$f" ]; then
    echo "MISS $DEST_DIR/include/$f"
    missing=$((missing + 1))
  fi
done

for f in "${required_sources[@]}"; do
  if [ ! -f "$DEST_DIR/src/$f" ]; then
    echo "MISS $DEST_DIR/src/$f"
    missing=$((missing + 1))
  fi
done

if [ "$missing" -ne 0 ]; then
  echo "ERROR: $missing Falcon C file(s) missing."
  echo "Set FALCON_VENDOR_DIR=/path/to/falcon and run this script again, or restore the vendored files."
  exit 1
fi

echo "Falcon C sources are ready in $DEST_DIR"
