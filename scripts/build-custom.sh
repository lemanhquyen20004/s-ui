#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UPSTREAM_VERSION="${SUI_UPSTREAM_VERSION:-v1.6.4}"
BUILD_ROOT="${SUI_BUILD_ROOT:-$(mktemp -d)}"
SRC_DIR="$BUILD_ROOT/s-ui"
OUT_DIR="$ROOT_DIR/dist"

cleanup() {
  if [[ "${SUI_KEEP_BUILD_DIR:-0}" != "1" ]]; then
    rm -rf "$BUILD_ROOT"
  fi
}
trap cleanup EXIT

echo "[1/6] Cloning S-UI $UPSTREAM_VERSION..."
git clone --depth 1 --branch "$UPSTREAM_VERSION" https://github.com/alireza0/s-ui.git "$SRC_DIR"
git -C "$SRC_DIR" submodule update --init --recursive

echo "[2/6] Applying modern UI overrides..."
cp -a "$ROOT_DIR/overrides/." "$SRC_DIR/frontend/"

MAIN_TS="$SRC_DIR/frontend/src/main.ts"
if ! grep -q "styles/modern.scss" "$MAIN_TS"; then
  sed -i "/import App from '.\/App.vue'/a import '.\/styles\/modern.scss'" "$MAIN_TS"
fi

echo "[3/6] Building frontend..."
cd "$SRC_DIR/frontend"
npm ci
npm run build

echo "[4/6] Embedding frontend into backend..."
cd "$SRC_DIR"
rm -rf web/html
mkdir -p web/html
cp -a frontend/dist/. web/html/

echo "[5/6] Building backend..."
go build -trimpath -ldflags="-s -w" -o s-ui main.go

echo "[6/6] Packaging..."
rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR/package"
cp s-ui "$OUT_DIR/package/"
cp s-ui.sh s-ui.service "$OUT_DIR/package/"
cp -a bin "$OUT_DIR/package/" 2>/dev/null || true
cp LICENSE "$OUT_DIR/package/"
tar -C "$OUT_DIR/package" -czf "$OUT_DIR/s-ui-modern-${UPSTREAM_VERSION}.tar.gz" .

echo
echo "Done: $OUT_DIR/s-ui-modern-${UPSTREAM_VERSION}.tar.gz"
