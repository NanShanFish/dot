#!/bin/bash

update() {
    _date_=$(date "+%y/%m/%d-%H:%M")
    sed -i "/^export _date/d" $DWM/statusbar/temp
    echo "export _date_='$_date_'" >> $DWM/statusbar/temp
}

notify() {
  _cal=$(cal --color=always | sed 1d | sed 's/..7m/<b><span color="#ff79c6">/;s/..0m/<\/span><\/b>/')
  _todo=$(bash /home/shan/scr/todo.sh)
  notify-send "      Calendar" "\n$_cal\n$_todo" -r 9527 -t 20000 -i /dev/null
}

call_todo() {
    pid1=`ps aux | grep 'st -t statusutil' | grep -v grep | awk '{print $2}'`
    pid2=`ps aux | grep 'st -t statusutil_todo' | grep -v grep | awk '{print $2}'`
    mx=`xdotool getmouselocation --shell | grep X= | sed 's/X=//'`
    my=`xdotool getmouselocation --shell | grep Y= | sed 's/Y=//'`
    kill $pid1 && kill $pid2 || st -t statusutil_todo -g 50x15+$((mx - 200))+$((my + 20)) -c FG -e nvim ~/doc/daily/2-daily/Todo/todo.md
}

call_journey() {
    pid1=`ps aux | grep 'st -t statusutil' | grep -v grep | awk '{print $2}'`
    pid2=`ps aux | grep 'st -t statusutil_daily' | grep -v grep | awk '{print $2}'`
    mx=`xdotool getmouselocation --shell | grep X= | sed 's/X=//'`
    my=`xdotool getmouselocation --shell | grep Y= | sed 's/Y=//'`
	kill $pid1 && kill $pid2 || st -t statusutil_daily -g 60x40+$((mx - 200))+$((my + 20)) -c float -e nvim ~/doc/daily/2-daily/$(date +"%Y-%m-%d").md
}

case $1 in
    "") update;;
    L) notify ;;
    R) call_todo ;;
    # M) call_journey ;;
esac
