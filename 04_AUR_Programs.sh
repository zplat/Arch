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

udiskie &		   #access additional partitions

xdg-user-dirs-update       #Create XDG user directories


#-----------------------Install AUR packages

	## Keyboard layout and Fonts
	paru -S ttf-envy-code-r qmk-git
	# Web Browsers and supporting applications
	paru -S google-chrome microsoft-edge-stable-bin lynx-current
	# pdf Readers
	paru -S zathura-pdf-mupdf-git 
	# System tools
	paru -S zramd wlr-randr-git 
	#Storage
	paru -S dropbox 
	# X11 and Wayland
	paru -S wlr-randr-git zramd 
	# Window Managers
	paru -S awesome-git river-git
	# Tools
	paru -S rofi-lbonn-wayland-git
	

