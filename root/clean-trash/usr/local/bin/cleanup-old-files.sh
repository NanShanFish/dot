#!/usr/bin/bash

echo '' > /var/log/clean_old_files.log

log() {
    echo "[$(date "+%F %T")] $1"
}
exec 3>&1
exec 2>&1
exec 1> >(tee -a "/var/log/clean_old_files.log" >&3)
CLEANUP_DIR=("/home/shan/.local/trash")

for dir in $CLEANUP_DIR; do
    if test -d $dir; then
        dir=$(realpath $dir)
        for item in $(fd --base-directory=$dir --max-depth=1 --changed-before=6months); do
            log "rm $item..."
            rm --interactive=never -r "$dir/$item"
            if test $? -ne 0; then
                log "Error when rm $dir"
            fi
        done
    fi
done
