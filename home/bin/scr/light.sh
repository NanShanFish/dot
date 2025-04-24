#!/usr/bin/env bash


update() {
    _light_=$(light -G)
    sed -i "/^export _light/d" $DWM/statusbar/temp
    echo "export _light_='$_light_'" >> $DWM/statusbar/temp
}

case "$1" in
    ""|L) update;;
    U)
        light -A 5
        update;;
    D)
        light -U 5
        update;;
esac
if [ "$2" ] ; then
    bash $DWM/statusbar/statusbar.sh re
fi
