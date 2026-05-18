#!/usr/bin/env bash

log() {
    echo "[$(date "+%F %T")] $1"
}

XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
TRASH_DIR="$XDG_DATA_HOME/Trash"

if [ -d "$TRASH_DIR/info" ]; then
    cd "$TRASH_DIR/info" || exit 1

    fd --max-depth=1 -e trashinfo --changed-before=6months -0 | while IFS= read -r -d '' info_file; do
        base_name=$(basename "$info_file" .trashinfo)
        log "[INFO] remove $base_name"

        rm --interactive=never -r "$TRASH_DIR/files/$base_name" "$TRASH_DIR/info/$info_file"

        if [ $? -ne 0 ]; then
            log "[ERROR] when remove $base_name"
        fi
    done
fi
