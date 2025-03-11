#!/bin/bash

# 打印菜单
call_menu() {
	echo -e 'pwd\njourney\nbluetooth\nsleep\nhibernate\npoweroff\nreboot\nsh'
	# [ "$(sudo docker ps | grep v2raya)" ] && echo ' close v2raya' || echo ' open v2raya'
	[ "$(ps aux | grep picom | grep -v 'grep\|rofi\|nvim')" ] && echo 'close picom' || echo 'open picom'
}

# 执行菜单
execute_menu() {
	case $1 in
		'pwd')
			rofi -p 'passwd' -dmenu| python -c "$(sudo cat $HOME/scr/pwd)" |xargs xdotool type
			;;
		'journey')
            doc_path="$(realpath ~/doc)"
            d_file="$doc_path/daily/2-daily/$(date "+%Y/%m/%Y-%m-%d").md"
            test -e "$d_file" || cp "$doc_path/daily/template/Journey.md" "$d_file"
            cd ~/doc/daily && alacritty -e nvim "$d_file"
			;;
		'bluetooth')
			~/scr/bluetooth.sh &
			;;
		'sleep')
			systemctl suspend &
			;;
		'hibernate')
			systemctl hibernate &
			;;
		'poweroff')
			shutdown now
			;;
		'reboot')
			reboot
			;;
		'open picom')
			coproc (picom > /dev/null 2>&1)
			;;
		'close picom')
			killall picom
			;;
		'sh')
			notify-send "$(rofi -p 'shell' -dmenu | fish)"
			;;
	esac
}

execute_menu "$(call_menu | rofi -dmenu -matching prefix -p "shotcut")"
