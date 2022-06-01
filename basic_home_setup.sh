#!/usr/bin/env sh 

############################################################
# Before using be sure that the .ssh file has been set up!!
############################################################


# Create XDG user directories
xdg-user-dirs-update

# Setup rustup
rustup default nightly

# Install paru
mkdir ~/.local/respositories
cd ~/.local/repositories/
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

sudo pacman -Syy
