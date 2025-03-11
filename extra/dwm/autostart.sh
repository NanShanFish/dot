#! /bin/bash
# DWM自启动脚本 仅作参考

_thisdir=$(
  cd $(dirname $0)
  pwd
)

settings() {
  [ $1 ] && sleep $1
  xset -b                    # 关闭蜂鸣器
  # syndaemon -i 1 -t -K -R -d # 设置使用键盘时触控板短暂失效
  /usr/bin/dunst &
  feh --randomize --bg-fill ~/pic/wallpaper/windows-error.jpg
}

daemons() {
  [ $1 ] && sleep $1
  $DWM/statusbar/statusbar.sh cron & # 开启状态栏定时更新
  fcitx5 & # 开启输入法
  dunst -conf ~/.config/dunst/dunst.conf & # 开启通知server
  # picom --experimental-backends --config ~/.config/picom/picom.conf >>/dev/null 2>&1 & # 开启picom
}

settings 1 & # 初始化设置项
daemons 3 &  # 后台程序项
