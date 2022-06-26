#!/usr/bin/env sh 

############################################################
#
# 			Personal set up!!
#
############################################################

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

sudo pacman -Syy        				# Update pacman package database
rustup default nightly  				# Setup rustup

#-----------------------Setup git password automation

git config --global credential.helper "netrc -v -f $HOME/.password-store/service.gpg"

#-----------------------Install respositories

mkdir ~/.local/respositories
cd ~/.local/repositories/
git clone https://aur.archlinux.org/paru.git            # Feature packed AUR helper
git clone https://github.com/zplat/Arch.git             # My Arch Installation
git clone https://github.com/sereinity/ofi-pass.git     # Is a password promptor for pass 
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
        sudo pacman -S --needed imv mpv feh sxiv
        sudo pacman -S --needed nodejs python-gpgme 
        sudo pacman -S --needed neovim zk 
    	sudo pacman -S --needed xorg xorg-apps alsa-utils
        sudo pacman -S --needed tmux bat fzf broot fd ripgrep rofi tmuxp 		
        sudo pacman -S --needed picom fcitx-mozc xbindkeys xorg-xinit		
        sudo pacman -S --needed sway swayidle swaylock foot  			# 
        sudo pacman -S --needed xdg-desktop-portal-wlr  
        sudo pacman -S --needed bemenu-wayland bemenu 
fi

#-----------------------Install AUR packages

if [ -s aurpkglist.txt ]
then
        # The file is not-empty.
        paru  -S --needed - < ~/.local/repositories/aurpkglist.txt
else
        # The file is empty.
        paru -S alacritty-git vieb-git buku-git awesome-git lynx-git 
        paru -S buku-git 
        paru -S dropbox dropbox-cli 
    	paru -S zramd
        paru -S river-git wlr-randr-git 
        paru -S nerd-fonts-complete ttf-envy-code-r
fi

#----------------------Start Dropbox and systemd enable

dropbox 

sudo systemctl enable dropbox@$USER

#----------------------zramd systemd start and enable

sudo systemctl enable --now zramd.service
