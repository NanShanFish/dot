#!/bin/bash

log() {
	level=$1
	case $1 in
		0) echo "[STEP]" $2;;
		1) echo -e "[${GREEN}INFO${NORMAL}]" $2;;
		2) echo -e "[${YELLOW}WARN${NORMAL}]" $2;;
		3) echo -e "[${RED}ERROR${NORMAL}]" $2;;
		4) echo -e "[${RED}FATAL${NORMAL}]" $2; exit 1;;
	esac
}

chtxt() {
	if [[ "$#" -ne "3" ]]; then
		log 4 "chtxt invalid argv"
	fi

	case $1 in
		1)
			if [[ -n "$DEBUG" ]]; then
				echo -e "[${MAGENTA}DEBUG${NORMAL}] echo $2 > $3"
			else
				echo $2 > $3
			fi;;
		2)
			if [[ -n "$DEBUG" ]]; then
				echo -e "[${MAGENTA}DEBUG${NORMAL}] echo -e $2 >> $3"
			else
				echo -e $2 >> $3
			fi;;
		*)
			log 4 "chtxt invaldi argv"
	esac
}

config_file(){
	echo -e "en_GB.UTF-8 UTF-8\nzh_CN.UTF-8 UTF-8" >> /etc/locale.gen
	locale-gen

	log 0 "Init hostname hosts..."
	echo "$hostname" > /etc/hostname
	echo -e "127.0.0.1 localhost\n::1   localhost\n127.0.0.1 $hostname.localdomain  $hostname" >> /etc/hosts

	log 0 "Add archlinuxcn mirror..."
	echo 'Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist
	echo -e "ILoveCandy\nColor\n[archlinuxcn]\nServer = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/\$arch" >> /etc/pacman.conf

	log 0 "Add IM enviroment"
	echo -e "GTK_IM_MODULE=fcitx\nQT_IM_MODULE=fcitx\nXMODIFIERS=@im=fcitx\nSDL_IM_MODULE=fcitx" > /etc/environment
}

necessary(){
    log 0 "Init keyring..."
    pacman-key --init
    pacmankey --populate archlinux

	log 0 "Install boot manager..."
	pacman -S grub efibootmgr os-prober intel-ucode --needed
	mkdir /boot/grub
	grub-install --target=x86_64-efi --efi-directory=/boot || log 4 "grub install target failed"
	grub-mkconfig > /boot/grub/grub.cfg || log 4 "grub failed to mkconfig"

	log 1 "Install networkmanger..."
	pacman -S networkmanager dhcpcd wpa_supplicant --needed
	systemctl enable NetworkManager -all

	log 1 "Configura pipewire..."
	pacman -S sof-firmware pipewire wireplumber pipewire-pulse pipewire-alsa pipewire-jack pavucontrol bluez bluez-utils --needed
	systemctl enable pipewire --user
	systemctl enable pipewire-pulse --user
}

create_link() {
	ln -sf /usr/bin/{nvim,v} || log 2 "create symbol-link /usr/bin/v failed"
	ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime || log 2 "create symbol-link /etc/localtime failed"
	hwclock --systohc
	
	pacman -S stow --needed || log 4 "fail to download stow"
	cd ~/dot/home
	mkdir ~/.config/vivaldi/ -p
	stow -n --verbose=1 -t ~ --dotfiles *
	cd ~/dot/root
	stow -n --verbose=1 -t / *
}

x11_pkg(){
	pacman -S feh xdotool xclip
	paru alacritty-smooth-cursor-git || log 3 "failed to download alacritty-smooth-cursor"
}

my_package(){
	cd ~/dot/extra/dwm && make clean install || log 4 "fail to compile dwm"
	cd ~/dot/extra/st/ && make clean install || log 4 "fail to compile dwm"
	log 1 "Install my package..."
	pacman -S base-devel zip unzip tar ntfs-3g paru xorg xorg-xinit fcitx5-im fcitx5-rime fcitx5-configtool acpi dunst fastfetch vivaldi npm yazi ffmpeg p7zip jq poppler fd ripgrep fzf zoxide imagemagick rofi ouch tlp btop arch-install-scripts sudo syncthing man-pages-zh_cn openssh --needed
	read -p "Do you want to install X11 pkgs?(y/n)" flag
	if [[ "$flag" == "y" ]]; then
		x11_pkg
	fi
}

init() {
	RED="\033[31m"
	GREEN="\033[32m"
	YELLOW="\033[33m"
	NORMAL="\033[0m"
	MAGENTA="\033[35m"

	if [[ -z $DEBUG && "$EUID" -ne 0 ]]; then
		log 4 "Please run this script as root."
	fi

	[[ -n $DEBUG ]] && log 1 "debug mode enabled"
	read -p "Input your name: " user
	if [ "$user" = "" ]; then
		log 4 "username can't be empty"
	elif  id "$user" > /dev/null 2>&1 ; then
		log 1 "USERNAME: ${GREEN}$user${NORMAL}"
	else
		log 4 "user ${RED}$user${NORMAL} not exit, please create first"
	fi
	read -p "Input your hostname: " hostname
	if [ "$hostname" = "" ]; then
		log 4 "hostname can't be empty"
	else
		log 1 "HOSTNAME: ${GREEN}$hostname${NORMAL}"
	fi
}

while getopts ":d" opt; do
	case ${opt} in
		d)
			DEBUG=1
			;;
	esac
done

init
config_file
create_link
necessary
my_package
