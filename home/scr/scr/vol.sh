#!/bin/bash

update() {
    _vol_=$(pactl get-sink-volume @DEFAULT_SINK@ | head -n 1 | awk '{print $5}')
	if [ -z "$_vol_" ] ; then
		exit
	fi
    _vol_clr_="#a6e3a1"
    if pactl get-sink-mute @DEFAULT_SINK@ | grep -q 'yes'; then
        _vol_clr_="#766c64"
    fi
    sed -i "/^export _vol/d" $DWM/statusbar/temp
    echo "export _vol_='$_vol_'" >> $DWM/statusbar/temp
    echo "export _vol_clr_='$_vol_clr_'" >> $DWM/statusbar/temp
}

notify() {
    update
    _vol_=$(echo $_vol_ | sed 's/.$//')
    icon="VolumeOn"
    if [ "$_vol_clr_" = "#766c64" ]; then
        icon="NoVolume"
    elif [ "$_vol_" -eq 0 ]; then
        icon="VolumeOff"
    fi
    notify-send -r 9527 -h int:value:$_vol_ -h string:hlcolor:#4fd6be "Volume" -i ~/pic/icons/$icon.png
	# notify-send  -r 9527 "Volume" "$icon: $_vol_"
}

case "$1" in
    "") update;;
    L) notify ;;
    R)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        notify ;;
    U)
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        notify ;;
    D)
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        notify ;;
    M) pavucontrol & ;;
esac
if [ "$2" ] ; then
    bash $DWM/statusbar/statusbar.sh re
fi
