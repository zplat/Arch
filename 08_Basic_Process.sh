#!/usr/bin/env sh

#-----------------------Install repositories

cd ~/.local/repositories/

git clone https://github.com/zplat/Arch.git         # My Arch Installation
git clone https://github.com/zplat/neovim.git       # forked (ufo-fold)
git clone https://github.com/jarun/buku.git         # clone
git clone https://github.com/newsboat/newsboat.git   # clone
git clone https://github.com/zplat/qmk_firmware.git # forked (ferris9)

git clone https://github.com/kovidgoyal/kitty       # forked 

#--------------------------Install lazyvim
#git clone https://github.com/LazyVim/starter ~/.config/nvim
#rm -rf ~/.config/nvim/.git

#--------------------------zramd systemd start and enable
sudo systemctl enable --now zramd.service

#--------------------------dropbox systemd start and enable
#systemctl --user enable dropbox

#--------------------------nixos
sudo systemctl enable --now nix-daemon.service
sudo gpasswd -a "$USER"  nix-users
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --update
#Install emanote
nix-env -iA nixpkgs.emanote
