#!/usr/bin/env sh

#-----------------------Install repositories

cd ~/.local/repositories/

git clone https://github.com/zplat/neovim.git       # forked (ufo-fold)
git clone https://github.com/jarun/buku.git         # clone
git clone https://github.com/newsboat/newsboat.git  # clone
git clone https://github.com/zplat/qmk_firmware.git # forked (ferris9)

git clone https://github.com/kovidgoyal/kitty # forked

#--------------------------Install lazyvim
#git clone https://github.com/LazyVim/starter ~/.config/nvim
#rm -rf ~/.config/nvim/.git

#--------------------------zramd systemd start and enable
sudo systemctl enable --now zramd.service

#--------------------------dropbox systemd start and enable
#systemctl --user enable dropbox

#--------------------------nixos
sudo systemctl enable --now nix-daemon.service
sudo gpasswd -a "$USER" nix-users
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --update
#Install emanote
nix-env -iA nixpkgs.emanote

#-----------------------Install Core Packages
  sudo pacman -Syu
  # Keyboard layout and Fonts
	sudo pacman --needed --noconfirm -S ttf-hack ttf-hack-nerd ttf-inconsolata ttf-inconsolata-nerd ttf-sourcecodepro-nerd 
	#sudo pacman --needed --noconfirm -S fcitx5-mozc fcitx5-qt fcitx5-mozc fcitx5-qt adobe-source-code-pro-fonts
	#sudo pacman --needed --noconfirm -S adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts
	# Web Browsers and supporting applications
	sudo pacman --needed --noconfirm -S nyxt surfraw pass fuzzel
	# Email
	sudo pacman --needed --noconfirm -S notmuch isync msmtp msmtp-mta neomutt
	# Image Viewers and Graphics
	sudo pacman --needed --noconfirm -S imv feh sxiv graphviz yt-dlp
	# Video Player
	sudo pacman --needed --noconfirm -S mpv 
	# pdf Readers
	sudo pacman --needed --noconfirm -S calibre 
	# Note takers
	sudo pacman --needed --noconfirm -S zk 
	# Audio
	sudo pacman --needed --noconfirm -S wireplumber pipewire alsa-utils 
	# X11 and Wayland
	sudo pacman --needed --noconfirm -S xbindkeys xdg-desktop-portal-wlr nix qt5-wayland xorg-xwayland
	#sudo pacman --needed --noconfirm -S xorg-server xorg-apps xorg-xinit picom 
	# Terminals
	sudo pacman --needed --noconfirm -S foot alacritty
	# Window Managers
	sudo pacman --needed --noconfirm -S sway swayidle swaylock swaybg
	# Tools
	sudo pacman --needed --noconfirm -S bemenu-wayland bemenu cmake rofi-pass tmux bat fzf broot fd ripgrep tmuxp xclip gnupg 
	# Programming
	sudo pacman --needed --noconfirm -S r tk rustup gawk 
	# Required 
	sudo pacman --needed --noconfirm -S python-pillow stfl python-pygments python-gpgme python-pip nodejs libffi ninja librsync

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
