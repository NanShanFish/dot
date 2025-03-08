#!/bin/bash

update() {
    _bat_=$(acpi -b | grep -v "unavailable" | awk '{print $4}' | grep -Eo "[0-9]+")
    sed -i "/^export _bat/d" $DWM/statusbar/temp
    echo "export _bat_='$_bat_'" >> $DWM/statusbar/temp
}

notify() {
    bat_txt=$(acpi -b | grep -v "unavailable"| sed -E 's/Battery [0-9]: //')
    notify-send -r 9527 "Battery" "$bat_txt" -i ~/pic/icons/smartphone-charger.png
}

case $1 in
    ""|L) update;;
    R) notify ;;
esac
