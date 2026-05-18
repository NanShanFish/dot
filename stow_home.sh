#!/usr/bin/env bash

SCRIPT_PATH="$0"
CURRENT_DIR="$(dirname $SCRIPT_PATH)"

user="$1"
if [ -z "$1" ]; then
    user="$USER"
fi

cd "$CURRENT_DIR/home" && stow -n --verbose=1 -t "/home/$user" --no-folding --dotfiles *
