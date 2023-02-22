#!/usr/bin/env bash

# Temp holding folder for the download
cd "$HOME/.local/repositories/"
# download the vieb arch linux release. Works when installed.
wget https://github.com/Jelmerro/Vieb/releases/download/9.5.1/vieb-9.5.1.pacman
# install file using pacman
sudo pacman -U vieb-9.5.1.pacman
# remove file post install
rm vieb-9.5.1.pacman 
