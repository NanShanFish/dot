#!/bin/bash
tmpfile="/home/shan/dwm/statusbar/temp"

refresh_file() {
	sed -i "/^export _wifi/d" $tmpfile
	echo "export _wifi_='$_wifi_'" >> $tmpfile
	echo "export _wifi_clr_='$_wifi_clr_'" >> $tmpfile
}

update() {
	_wifi_=$(nmcli d | grep "已连接" | awk '{print $4}')
	_wifi_clr_="#d3869b"
	[ "$_wifi_" = "" ] && _wifi_clr_="#766c64"
	refresh_file
}

notify() {
	pid1=`ps aux | grep 'st -t statusutil' | grep -v grep | awk '{print $2}'`
	pid2=`ps aux | grep 'st -t statusutil_wifi' | grep -v grep | awk '{print $2}'`
	mx=`xdotool getmouselocation --shell | grep X= | sed 's/X=//'`
	my=`xdotool getmouselocation --shell | grep Y= | sed 's/Y=//'`
	kill $pid1 && kill $pid2 || st -t statusutil_wifi -g 82x25+$((mx - 328))+$((my + 20)) -c FG -e nmtui
}

toggle() {
	if [ "$(nmcli d | grep '^wlp' | awk '{print $3}')" = "已断开" ]; then
		nmcli d connect wlp0s20f3
		update
	else
		nmcli d disconnect wlp0s20f3
		_wifi_clr_="#3e4452"
		_wifi_=""
		refresh_file
	fi
}
case $1 in
	""|L) update;;
	R) notify ;;
	M) toggle ;;
esac
