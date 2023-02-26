#!/usr/bin/env bash

XX=60
# Temp holding folder for the download
cd "$HOME/.local/repositories/"
# download the vieb arch linux release. Works when installed.
wget "https://github.com/ankitects/anki/releases/download/2.1.60/anki-2.1.${XX}-linux-qt6.tar.zst"
# add zstd
sudo pacman -S --needed zstd
# unpack file
tar xaf "$HOME/.local/repositories/anki-2.1.${XX}-linux-qt6.tar.zst" 
# cd to new folder created by unpack 
cd "anki-2.1.${XX}-linux-qt6"
# install 
sudo ./install.sh
