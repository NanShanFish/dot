#!/usr/bin/env bash

SCRIPT_PATH="$0"
CURRENT_DIR="$(dirname $SCRIPT_PATH)"

cd "$CURRENT_DIR/root" && stow --verbose=1 --no-folding -t / *
