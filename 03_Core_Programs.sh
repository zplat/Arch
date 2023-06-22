#!/usr/bin/env sh

#-----------------------Install Core Packages
 sudo pacman -Syu
# Keyboard layout and Fonts
 sudo pacman --needed --noconfirm -S ttf-hack ttf-hack-nerd ttf-inconsolata ttf-inconsolata-nerd ttf-sourcecodepro-nerd 
#sudo pacman --needed --noconfirm -S fcitx5-mozc fcitx5-qt fcitx5-mozc fcitx5-qt adobe-source-code-pro-fonts
#sudo pacman --needed --noconfirm -S adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts
# Web Browsers and supporting applications
 sudo pacman --needed --noconfirm -S pass 
#sudo pacman --needed --noconfirm -S nyxt surfraw pass fuzzel
# Email
#sudo pacman --needed --noconfirm -S notmuch isync msmtp msmtp-mta neomutt
# Image Viewers and Graphics
#sudo pacman --needed --noconfirm -S imv feh sxiv graphviz yt-dlp
# Video Player
#sudo pacman --needed --noconfirm -S mpv 
# pdf Readers
#sudo pacman --needed --noconfirm -S calibre 
# Note takers
#sudo pacman --needed --noconfirm -S zk 
# Audio
#sudo pacman --needed --noconfirm -S wireplumber pipewire alsa-utils 
# X11 and Wayland
 sudo pacman --needed --noconfirm -S xbindkeys xdg-desktop-portal-wlr nix qt5-wayland xorg-xwayland
#sudo pacman --needed --noconfirm -S xorg-server xorg-apps xorg-xinit picom 
# Terminals
 sudo pacman --needed --noconfirm -S foot alacritty
# Window Managers
#sudo pacman --needed --noconfirm -S sway swayidle swaylock swaybg
# Tools
#sudo pacman --needed --noconfirm -S bemenu-wayland bemenu cmake rofi-pass tmux bat fzf broot fd ripgrep tmuxp xclip gnupg 
 sudo pacman --needed --noconfirm -S cmake gnupg 
#sudo pacman --needed --noconfirm -S bemenu-wayland bemenu cmake gnupg 
# Programming
 sudo pacman --needed --noconfirm -S rustup gawk 
# Required 
#sudo pacman --needed --noconfirm -S python-pillow stfl python-pygments python-gpgme python-pip nodejs libffi ninja librsync

 rustup default nightly
