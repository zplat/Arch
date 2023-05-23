#!/usr/bin/env bash

#Assign current release version 
RELEASE=""
# Temp holding folder for the download
cd "$HOME/.local/repositories/"
#Install supporting programs
sudo pacman --needed --noconfirm -S npm nodejs
# download the vieb arch linux release. Works when installed.
wget https://github.com/Jelmerro/Vieb/releases/download/$RELEASE/vieb-${RELEASE}.pacman
# install file using pacman
sudo pacman -U vieb-${RELEASE}.pacman
# remove file post install
rm vieb-${RELEASE}.pacman 
