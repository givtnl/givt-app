#!/usr/bin/env bash
set -euo pipefail

FLUTTER_VERSION="3.41.0"
FLUTTER_DIR="$HOME/flutter"
PATH_EXPORT='export PATH="$HOME/flutter/bin:$HOME/.pub-cache/bin:$PATH"'

if [ ! -x "$FLUTTER_DIR/bin/flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b "$FLUTTER_VERSION" --depth 1 "$FLUTTER_DIR"
fi

# Keep Flutter on PATH for interactive agent shells.
if ! grep -q 'flutter/bin' "$HOME/.bashrc" 2>/dev/null; then
  printf '\n%s\n' "$PATH_EXPORT" >>"$HOME/.bashrc"
fi

eval "$PATH_EXPORT"

dart pub global activate melos
melos install
