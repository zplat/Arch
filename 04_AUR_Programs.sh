#!/usr/bin/env sh

#-----------------------Install repositories

udiskie &		   #access additional partitions

mkdir ~/.local/repositories
cd ~/.local/repositories/

git clone https://aur.archlinux.org/paru.git        # Feature packed AUR helper

#-----------------------Install paru                                                                        # Install paru
cd paru
rustup default stable
makepkg -si
cd # Return to home directory

xdg-user-dirs-update       #Create XDG user directories


#-----------------------Install AUR packages

	## Keyboard layout and Fonts
	paru -S ttf-envy-code-r qmk-git
	paru -S ttf-google-fonts-git
	# Web Browsers and supporting applications
	paru -S lynx-current
	paru -S google-chrome
	paru -S  microsoft-edge-stable-bin
	# pdf Readers
	paru -S zathura-pdf-mupdf-git 
	# System tools
	paru -S zramd
	#Storage
	paru -S dropbox 
	# Wayland
	paru -S wlr-randr-git
	# Window Managers
	paru -S awesome-git
	# Tools
	paru -S rofi-lbonn-wayland-git pass-tessen tessen
	

