#!/usr/bin/env sh

LOCAL_RESPOSITORY="/home/$USER/.local/repositories"

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
