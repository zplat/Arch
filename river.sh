#!/usr/bin/env bash 

sudo pacman --needed --noconfirm -S libevdev libxkbcommon mesa pixman wayland wlroots xorg-wayland polkit scdoc wayland-protocols zig 

cd "$HOME/.local/repositories"

git clone https://github.com/riverwm/river.git

cd river
git submodule update --init
zig build -Drelease-safe -Dxwayland --prefix ~/.local install
