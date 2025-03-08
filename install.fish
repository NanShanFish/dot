#!/bin/fish

# evdev的位置 /usr/share/X11/xkb/keycodes/evdev
# 30-touchpad.conf 位置 /usr/share/X11/xorg.conf.d/30-touchpad.conf

# fdisk -l
# cfdisk
# mkfs * 3
# swapon
# vim /etc/pacman.d/mirrorlist
# mount <root zone> /mnt
# mount --mkdir <boot zone> /mnt/boot
# pacstrap /mnt base linux linux-firmware neovim git fish
# genfstab -U /mnt >> /mnt/etc/fstab
# arch-chroot /mnt

echo "==============================================================================================="
echo "==============================================================================================="
echo "===============                         INIT                                      ============="
echo "==============================================================================================="
echo "==============================================================================================="
echo "input your username: "
#set -l user (read -l)
set -l user "shan"

#echo "input your hostname: "
#set -l hostname (read -l)

set -l file_path $PWD

### 设置密码
##echo "Enter new password:"
##read -s -l password
##echo
##echo "$user:$password" | chpasswd
##if grep -q "^$user:" /etc/shadow
##   echo "Password for $user set successfully."
##else
##   echo "Failed to set password for $user."
##end



#echo "==============================================================================================="
#echo "==============================================================================================="
#echo "===============                         ETC FILE                                  ============="
#echo "==============================================================================================="
#echo "==============================================================================================="
## 符号链接创建
#ln -sf /usr/bin/nvim /usr/bin/vi
#ln -sf /usr/bin/nvim /usr/bin/v
#ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
#hwclock --systohc
#echo -e "en_US.UTF-8 UTF-8\nzh_CN.UTF-8 UTF-8" > /etc/locale.gen
#locale-gen
#
#echo "$hostname" > /etc/hostname
#echo "127.0.0.1 localhost\n::1   localhost\n127.0.0.1 $hostname.localdomain  $hostname" > /etc/hosts
#
## 配置 pacman
#echo -e "[archlinuxcn]\nServer = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/\$arch" >> /etc/pacman.conf
#pacman-key --lsign-key "farseerfc@archlinux.org"
#pacman -Sy archlinuxcn-keyring
#pacman -S paru



#echo "==============================================================================================="
#echo "==============================================================================================="
#echo "===============                         GRUB                                      ============="
#echo "==============================================================================================="
#echo "==============================================================================================="
## 安装必需的软件包
#pacman -S grub efibootmgr intel-ucode os-prober networkmanager dhcpcd wpa_supplicant ntfs-3g --needed
#mkdir /boot/grub
#grub-mkconfig > /boot/grub/grub.cfg
#grub-install --target=x86_64-efi --efi-directory=/boot



#echo "==============================================================================================="
#echo "==============================================================================================="
#echo "===============                         INSTALL PKG                               ============="
#echo "==============================================================================================="
#echo "==============================================================================================="
#pacman -S base-devel zip unzip tar
#
## Xorg
#pacman -S xorg xorg-xinit
## fcitx5 输入法
#pacman -S fcitx5-im fcitx5-rime fcitx5-configtool --needed
#echo -e "GTK_IM_MODULE=fcitx\nQT_IM_MODULE=fcitx\nXMODIFIERS=@im=fcitx\nSDL_IM_MODULE=fcitx" > /etc/environment
## sound 声卡配置
#pacman -S sof-firmware wireplumber
#pacman -S pipewire pipewire-alsa pipewire-audio pipewire-jack pipewire-pulse pavucontrol --needed
## 电源, 通知, 信息, 图片查看器 浏览器
#pacman -S acpi dunst fastfetch feh xdotool xclip vivaldi rofi obsidian --needed
## yazi
#sudo pacman -S yazi ffmpeg p7zip jq poppler fd ripgrep fzf zoxide imagemagick
## 字体
#paru -S ttf-maple-sc-nerd


#echo "==============================================================================================="
#echo "==============================================================================================="
#echo "===============                         MAKE SYNC LINK                            ============="
#echo "==============================================================================================="
#echo "==============================================================================================="
## 创建配置文件的符号链接
#for i in (ls -1 ./config/)
#    ln -sf $PWD/config/$i /home/$user/.config/$i
#    #echo "$PWD/config/$i" "/home/$user/.config/$i"
#end
#
## 创建 Rime 配置的符号链接
#mkdir -p /home/$user/.local/share/fcitx5/rime
#for i in (ls -1 ./rime/)
#    ln -sf $PWD/rime/$i /home/$user/.local/share/fcitx5/rime/
#    #echo "$PWD/rime/$i" "/home/$user/.local/share/fcitx5/rime/"
#end
#
## 读取 position 文件并创建符号链接
#while read -l line
#    set -l part (string split " " $line)
#    set -l target (string replace "~" "/home/$user" $part[2])
#    mkdir -p (dirname $target)
#    ln -sf $PWD/$part[1] $target
#    #echo "$PWD/$part[1]" "$target"
#end < position


#echo "==============================================================================================="
#echo "==============================================================================================="
#echo "===============                         ADD SUDOERS                               ============="
#echo "==============================================================================================="
#echo "==============================================================================================="
## 修改 /etc/sudoers
#echo "Adding user $user to sudoers"
#echo "$user ALL=(ALL:ALL) ALL" > /etc/sudoers.d/$user
#echo "$user ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/$user
#cd ./dwm && sudo -u $user make clean install
#cd $file_path
#cd ./st && sudo -u $user make clean install
#cd $file_path

# 启用服务
#systemctl enable NetworkManager -all
#systemctl enable pipewire -all
#systemctl enable pipewire-pulse -all
#systemctl enable NetworkManager -all
