#!/usr/bin/env sh

#-----------------------Install Core Packages
  sudo pacman -Syu
  # Keyboard layout and Fonts
	sudo pacman --needed --noconfirm -S ttf-hack ttf-hack-nerd ttf-inconsolata ttf-inconsolata-nerd ttf-sourcecodepro-nerd adobe-source-code-pro-fonts
	sudo pacman --needed --noconfirm -S fcitx5-mozc fcitx5-qt fcitx5-mozc fcitx5-qt adobe-source-code-pro-fonts
	sudo pacman --needed --noconfirm -S adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts
	# Web Browsers and supporting applications
	sudo pacman --needed --noconfirm -S nyxt surfraw pass fuzzel
	# Email
	sudo pacman --needed --noconfirm -S notmuch isync msmtp msmtp-mta neomutt
	# Image Viewers and Graphics
	sudo pacman --needed --noconfirm -S imv feh sxiv graphviz yt-dlp
	# Video Player
	sudo pacman --needed --noconfirm -S mpv 
	# pdf Readers
	sudo pacman --needed --noconfirm -S calibre 
	# Note takers
	sudo pacman --needed --noconfirm -S zk 
	# Audio
	sudo pacman --needed --noconfirm -S wireplumber pipewire alsa-utils 
	# X11 and Wayland
	sudo pacman --needed --noconfirm -S xorg-server xbindkeys xorg-apps xorg-xinit picom xdg-desktop-portal-wlr  swayidle swaylock foot swaybg nix
	# Terminals
	sudo pacman --needed --noconfirm -S foot xterm alacritty
	# Window Managers
	sudo pacman --needed --noconfirm -S sway 
	# Tools
	sudo pacman --needed --noconfirm -S bemenu-wayland bemenu rofi-pass tmux bat fzf broot fd ripgrep tmuxp xclip gnupg 
	# Programming
	sudo pacman --needed --noconfirm -S r tk rustup cmake gawk 
	# Required 
	sudo pacman --needed --noconfirm -S python-pillow stfl python-pygments python-gpgme python-pip nodejs libffi ninja librsync
  
  rustup default stable

	

