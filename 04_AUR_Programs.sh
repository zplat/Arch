#!/usr/bin/env sh

udiskie & #access additional partitions

LOCAL_RESPOSITORY="/home/$USER/.local/repositories"

xdg-user-dirs-update #Create XDG user directories

#-----------------------Install repositories

mkdir -p "$LOCAL_RESPOSITORY"
cd "$LOCAL_RESPOSITORY"

git clone https://github.com/zplat/Arch.git  # My Arch Installation

git clone https://aur.archlinux.org/paru.git # Feature packed AUR helper

#-----------------------Install paru
cd paru # Install paru
rustup default nightly
makepkg -si

cd # Return to home directory



#-----------------------Install AUR packages

## Keyboard layout and Fonts
paru -S ttf-envy-code-r qmk-git
paru -S ttf-google-fonts-git
# Web Browsers and supporting applications
paru -S lynx-current
paru -S google-chrome
#paru -S microsoft-edge-stable-bin
# pdf Readers
paru -S zathura-pdf-mupdf-git
# System tools
paru -S zramd
#Storage
paru -S dropbox
# Wayland
paru -S wlr-randr-git
# Window Managers
#paru -S awesome-git
# Tools
paru -S rofi-lbonn-wayland-git pass-tessen tessen
