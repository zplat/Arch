#!/usr/bin/env bash

sudo pacman --needed --noconfirm -S gdb ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite xorg-xinput libxrender pixman wayland-protocols cairo pango seatd libxkbcommon xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info cpio

cd "$HOME/.local/repositories"

git clone --recursive https://github.com/hyprwm/Hyprland
cd Hyprland
sudo make install
