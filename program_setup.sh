#!/usr/bin/env sh

############################################################
#
# 			Program set up!!
#
############################################################

#-----------------------Install repositories

mkdir ~/.local/repositories
cd ~/.local/repositories/

git clone https://aur.archlinux.org/paru.git        # Feature packed AUR helper
git clone https://github.com/zplat/Arch.git         # My Arch Installation
git clone https://github.com/zplat/neovim.git      # neovim (see Chris@machine, YTube)
git clone https://github.com/zplat/qmk_firmware.git # cloned version of qmk: ferris9 layout
cd paru                                             # Install paru
makepkg -si
cd # Return to home directory

#-----------------------Install packages

if [ -s corepkglist.txt ]; then
	# The file is not-empty.
	sudo pacman -S --needed - <~/.local/repositories/corepkglist.txt
else
	# The file is empty.
	sudo pacman --needed --noconfirm -S imv mpv feh sxiv
	sudo pacman --needed --noconfirm -S nodejs python-gpgme
	sudo pacman --needed --noconfirm -S wireplumber pipewire
	sudo pacman --needed --noconfirm -S xorg-server xorg-apps alsa-utils python-pillow python-pygments
	sudo pacman --needed --noconfirm -S tmux bat fzf broot fd ripgrep tmuxp xclip gawk glow
	sudo pacman --needed --noconfirm -S graphviz zk calibre nyxt/surfraw
	sudo pacman --needed --noconfirm -S picom fcitx5-mozc xbindkeys xorg-xinit fcitx5-config-qt
	sudo pacman --needed --noconfirm -S sway swayidle swaylock foot swaybg
	sudo pacman --needed --noconfirm -S xdg-desktop-portal-wlr
	sudo pacman --needed --noconfirm -S bemenu-wayland bemenu rofi-pass
	sudo pacman --needed --noconfirm -S surfraw notmuch isync msmtp msmtp-mta neomutt
	sudo pacman --needed --noconfirm -S r tk rustup cmake
	sudo pacman --needed --noconfirm -S git python-pip libffi gnupg ninja
	sudo pacman --needed --noconfirm -S fcitx5 fcitx5-configtool fcitx5-mozc fcitx5-qt
	sudo pacman --needed --noconfirm -S ttf-nerd-fonts-symbols-common
	sudo pacman --needed --noconfirm -S ttf-nerd-fonts-symbols-1000-em ttf-nerd-fonts-symbols-1000-em-mono
	sudo pacman --needed --noconfirm -S ttf-nerd-fonts-symbols-2048-em ttf-nerd-fonts-symbols-2048-em-mono
	sudo pacman --needed --noconfirm -S adobe-source-code-pro-fonts adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fontsfi

#-----------------------Install AUR packages

if [ -s aurpkglist.txt ]; then
	# The file is not-empty.
	paru -S --needed - <~/.local/repositories/aurpkglist.txt
else
	# The file is empty.
	paru -S alacritty-git awesome-git river-git
	paru -S vieb-bin-git buku-git lynx-current newsboat-git
	paru -S rofi-lbonn-wayland-git
	paru -S dropbox qmk-git google-chrome microsoft-edge-stable-bin
	paru -S zramd wlr-randr-git zathura-pdf-mupdf-git
	paru -S ttf-envy-code-r
fi

#----------------------zramd systemd start and enable

sudo systemctl enable --now zramd.service

# nixos
curl --proto '=https' --tlsv1.2 -sSfL https://nixos.org/nix/install -o nix-install.sh
./nix-install.sh --daemon
sudo systemctl enable nix-daemon.service
usermod -a -G nix-users "$USER"
