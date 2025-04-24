#!/usr/bin/env bash
KERNELS="linux linux-lts linux-zen"
kernel_running=$(uname -r | sed 's/-lts//; s/-arch1-1//; s/-zen//;')
kernel_installed=$(pacman -Q --color never $KERNELS 2> /dev/null | awk '{print $2}') # no quotes on $KERNELS

if [ -z "$(echo "$kernel_installed" | grep "$kernel_running")" ]; then
    notify-send -u critical "OUTDATE" "kernel is outdated, a reboot is required" -i ~/pic/icons/notification.png -t 30000
fi
systemctl hibernate
