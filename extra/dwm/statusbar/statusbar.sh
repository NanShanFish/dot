#!/bin/bash

# # bat       1m
# bat="^sbat^^c#7dc4e4^[󰂁 $(acpi -b | grep -v "unavailable" | awk '{print $4}' | grep -Eo "[0-9]+")%]"
# #
# # cpu_mem   20s     L: btop
# per="^sper^^c#a6da95^[  $(~/.local/bin/tmux-mem-cpu-load  -m 2 -v)]"
# #
# # date      20s     L: todo     R: call_todo    M: journey
# date="^sdate^^c#f5a97f^[󰃯 $(date '+%y/%m/%d-%H:%M')]"
# #
# # volume    once    L: toggle   R: pavucontrol
# vol="^svol^^c#ed8796^[ $(pactl get-sink-volume $sink | head -n 1 | awk '{print $5}')]"
# #  
# xsetroot -name "$vol $date $per $bat"

update_menu() {
	[ ! "$1" ] && refresh && return # 当指定模块为空时 结束
	bash $DWM/statusbar/packages/$1.sh
	shift 1
	update_menu $*
}

refresh() {
	source $DWM/statusbar/temp
	# if [ -z "$_vol_" ] ; then
	# 	return
	# fi
	if [ $_bat_ -lt 15 ]; then
		_bat_clr_="#f38ba8"
	elif [ $_bat_ -lt 30 ]; then
		_bat_clr_="#f9e2af"
	else
		_bat_clr_="#89b4fa"
	fi
	_bat="^sbat^^c$_bat_clr_^[󰂁 $_bat_%]"
	_date="^sdate^^c#89dceb^[󰃯 $_date_]"
	_per="^sper^^c#a6e3a1^[  $_per_]"
	_vol="^svol^^c$_vol_clr_^[ $_vol_]"
	_light="^slight^^c#fab387^[ $_light_]"
	_wifi="^swifi^^c$_wifi_clr_^[ $_wifi_]"
	# echo "$_wifi $_light $_vol $_date $_per $_bat" >> $DWM/statusbar/tmp
	xsetroot -name "$_wifi $_light $_vol $_per $_date $_bat"
}

cron() {
	let i=0
	bash $DWM/statusbar/packages/light.sh
	while [ $i -le 30 ]; do
		bash $DWM/statusbar/packages/vol.sh
		update_menu date per bat wifi
		sleep 10
		let i+=1
	done
	while true; do
		# echo "..."
		bash $DWM/statusbar/packages/date.sh
		if ((i % 2 == 0)); then
			bash $DWM/statusbar/packages/per.sh
			if ((i % 12 == 0)); then
				bash $DWM/statusbar/packages/bat.sh
				# if (( i % 36 == 0)); then
				# 	feh --randomize --bg-fill ~/pic/wallpaper/*.jpg # 每300秒更新壁纸
				# fi
			fi
		fi
		sleep 10
		refresh
		let i+=1
	done
}


click() {
	[ ! "$1" ] && return
	bash $DWM/statusbar/packages/$1.sh $2
	refresh
}

case $1 in
	cron) cron ;;
	re) refresh ;;
	updateall)
		update_menu date per bat vol wifi light
		;;
	*) click $1 $2 ;;
esac
