#!/usr/bin/env sh

#-----------------------Install repositories

mkdir ~/.local/repositories
cd ~/.local/repositories/

git clone https://github.com/zplat/Arch.git         # My Arch Installation
git clone https://aur.archlinux.org/paru.git        # Feature packed AUR helper
git clone https://github.com/zplat/neovim.git       # forked (ufo-fold)
git clone https://github.com/jarun/buku.git         # clone
git clone https://github.com/zplat/qmk_firmware.git # forked (ferris9)
if [ -s corepkglist.txt ]; then
	# The file is not-empty.
	sudo pacman -S --needed - <~/.local/repositories/corepkglist.txt
else
	# The file is empty.
	# Keyboard layout and Fonts
	sudo pacman --needed --noconfirm ttf-hack-nerd ttf-inconsolata-nerd ttf-sourcecodepro-nerd fcitx5 fcitx5-configtool fcitx5-mozc fcitx5-qt adobe-source-code-pro-fonts adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts
	# Web Browsers and supporting applications
	sudo pacman --needed --noconfirm -S nyxt surfraw
	# Email
	sudo pacman --needed --noconfirm -S notmuch isync msmtp msmtp-mta neomutt
	# Image Viewers and Graphics
	sudo pacman --needed --noconfirm -S imv feh sxiv graphviz
	# Video Player
	sudo pacman --needed --noconfirm -S mpv 
	# pdf Readers
	sudo pacman --needed --noconfirm -S calibre 
	# Note takers
	sudo pacman --needed --noconfirm -S zk 
	# Audio
	sudo pacman --needed --noconfirm -S wireplumber pipewire alsa-utils 
	# X11 and Wayland
	sudo pacman --needed --noconfirm -S xorg-server xbindkeys xorg-apps xorg-xinit picom xdg-desktop-portal-wlr  swayidle swaylock foot swaybg
	# Terminals
	sudo pacman --needed --noconfirm -S foot xterm alacritty
	# Window Managers
	sudo pacman --needed --noconfirm -S sway 
	# Tools
	sudo pacman --needed --noconfirm -S bemenu-wayland bemenu rofi-pass tmux bat fzf broot fd ripgrep tmuxp xclip gnupg 
	# Programming
	sudo pacman --needed --noconfirm -S r tk rustup cmake gawk 
	# Required 
	sudo pacman --needed --noconfirm -S python-pillow python-pygments python-gpgme python-pip nodejs libffi ninja
	
fi

#-----------------------Install paru                                                                        # Install paru
cd paru
rustup default stable
makepkg -si
cd # Return to home directory

#-----------------------Install AUR packages

if [ -s aurpkglist.txt ]; then
	# The file is not-empty.
	paru -S --needed - <~/.local/repositories/aurpkglist.txt
else
	# The file is empty.
	## Keyboard layout and Fonts
	paru -S ttf-envy-code-r qmk-git
	# Web Browsers and supporting applications
	paru -S google-chrome microsoft-edge-stable-bin lynx-current
	# pdf Readers
	paru -S zramd wlr-randr-git zathura-pdf-mupdf-git 
	#Storage
	paru -S dropbox 
	# X11 and Wayland
	paru -S wlr-randr-git zramd 
	# Window Managers
	paru -S awesome-git river-git
	# Tools
	paru -S rofi-lbonn-wayland-git
	
fi

#--------------------------Install lazyvim
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

#--------------------------zramd systemd start and enable
sudo systemctl enable --now zramd.service

#--------------------------nixos
sudo pacman -S nix
sudo systemctl enable nix-daemon.service
sudo gpasswd -a "$USER"  nix-users

#--------------------------Install dotfiles
dot = "https://raw.githubusercontent.com/uplat/Arch/main/04_home_setup.sh" 
curl --url "$dot" >> "/home/$USER/dot.sh" 
#--------------------------


reboot
