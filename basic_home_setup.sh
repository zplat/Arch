#!/usr/bin/env sh 

############################################################
#
# 			Personal set up!!
#
############################################################

udiskie &		   #access additional partitions

xdg-user-dirs-update       #Create XDG user directories

#-----------------------Setup password manager

sudo pacman -S --needed pass 

DIR="/run/media/phlight/Partition1/configure"

cp -pr "$DIR/gnupg" ~/.local/share

chown -R $(whoami) ~/.local/share/gnupg/
chmod 600 ~/.local/share/gnupg/*
chmod 700 ~/.local/share/gnupg


cp -pr "$DIR/.ssh" ~/

chown -R $(whoami) ~/.ssh
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*

eval `ssh-agent` #Start agent

git clone git@github.com:zplat/password-store.git ~/.password-store

#-------------------------- Install dotfiles

MYDOTFILES="https://github.com/zplat/MyDotfiles.git"

git clone --bare --recurse-submodules "$MYDOTFILES" "$HOME/.dotfiles"

function config {
	/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

mkdir -p .config-backup
config checkout

if [ $? = 0 ] ; then
	echo "Checked out config.";
else 
	echo "Backing up pro-existing dot files.";
	config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi;

config checkout -f
config submodule update --init --recursive
config config status.showUntrackedFiles no

#--------------------------

zsh

sudo pacman -Syy        				# Update pacman package database
sudo pacman -S --needed rustup				# Install rust
rustup default nightly  				# Setup rustup

#-----------------------Install repositories

mkdir ~/.local/repositories
cd ~/.local/repositories/
git clone https://aur.archlinux.org/paru.git            # Feature packed AUR helper
git clone https://github.com/zplat/Arch.git             # My Arch Installation
git clone https://github.com/neovim/neovim.git		# neovim (see Chris@machine, YTube)
#git clone https://github.com/sereinity/ofi-pass.git     # Is a password promptor for pass 
cd paru
makepkg -si
cd

#-----------------------Install packages

if [ -s corepkglist.txt ]
then
        # The file is not-empty.
        sudo pacman -S --needed - < ~/.local/repositories/corepkglist.txt
else
        # The file is empty.
        sudo pacman -S --noconfirm --needed imv mpv feh sxiv
        sudo pacman -S --noconfirm --needed nodejs python-gpgme 
        sudo pacman -S --noconfirm --needed zk wireplumber pipewire
    	sudo pacman -S --noconfirm --needed xorg-server xorg-apps alsa-utils python-pillow python-pygments
        sudo pacman -S --noconfirm --needed tmux bat fzf broot fd ripgrep tmuxp 		
        sudo pacman -S --noconfirm --needed picom fcitx5-mozc xbindkeys xorg-xinit		
        sudo pacman -S --noconfirm --needed sway swayidle swaylock foot swaybg  			# 
        sudo pacman -S --noconfirm --needed xdg-desktop-portal-wlr  
        sudo pacman -S --noconfirm --needed bemenu-wayland bemenu 
        sudo pacman -S --noconfirm --needed surfraw neomutt notmuch isync
fi

#-----------------------Install AUR packages

if [ -s aurpkglist.txt ]
then
        # The file is not-empty.
        paru  -S --needed - < ~/.local/repositories/aurpkglist.txt
else
        # The file is empty.
        paru -S alacritty-git awesome-git river-git
        paru -S vieb-git buku-git lynx-git
	paru -S rofi-lbonn-wayland-git
        paru -S dropbox dropbox-cli 
    	paru -S zramd wlr-randr-git 
        paru -S nerd-fonts-complete ttf-envy-code-r
fi

#----------------------zramd systemd start and enable

sudo systemctl enable --now zramd.service
