#!/bin/bash

update() {
    _per_=$(~/.local/bin/tmux-mem-cpu-load -m 1 -v)
    sed -i "/^export _per/d" $DWM/statusbar/temp
    echo "export _per_='$_per_'" >> $DWM/statusbar/temp
}

notify() {
    pid1=`ps aux | grep 'st -t statusutil' | grep -v grep | awk '{print $2}'`
    pid2=`ps aux | grep 'st -t statusutil_per' | grep -v grep | awk '{print $2}'`
    mx=`xdotool getmouselocation --shell | grep X= | sed 's/X=//'`
    my=`xdotool getmouselocation --shell | grep Y= | sed 's/Y=//'`
    kill $pid1 && kill $pid2 || st -t statusutil_per -g 82x25+$((mx - 328))+$((my + 20)) -c FG -e btop
}

case $1 in
    ""|L) update;;
    R) notify ;;
esac
