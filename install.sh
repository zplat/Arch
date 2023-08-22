#!/usr/bin/env sh

############################################################
#
# 			Personal set up!!
#
############################################################

#Access additional partitions
udiskie &
Sleep 10
#Where to store my downloaded repositories
LOCAL_RESPOSITORY="/home/$USER/.local/repositories"

#Git user and email
USEREMAIL=""
USERNAME="zplat"
DOTFILES="git@github.com:zplat/MyDotfiles.git"
BACKUP_DOTFILES="git@github.com:zplat/.bookmark.git"

# external folder for additional setup
STORAGE="STORE"

#-----------------------Install Packages
Install_Basic ()
{
 sudo pacman --needed --noconfirm -S ttf-hack ttf-hack-nerd ttf-inconsolata ttf-inconsolata-nerd ttf-sourcecodepro-nerd 
 sudo pacman --needed --noconfirm -S pass 
 sudo pacman --needed --noconfirm -S xbindkeys xdg-desktop-portal-wlr nix qt5-wayland xorg-xwayland
 sudo pacman --needed --noconfirm -S foot alacritty
}

 

#-----------------------Install Dotfiles


function config {
	/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

Install_mydotfiles ()
{
git clone --bare --recurse-submodules "$DOTFILES" "$HOME/.dotfiles"
mkdir -p "$HOME/.config-backup"
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
}




Install_dotfiles ()
{
git clone --bare --recurse-submodules "$BACKUP_DOTFILES" "$HOME/.secfiles"

function secula {
	/usr/bin/git --git-dir=$HOME/.secfiles/ --work-tree=$HOME $@
}

mkdir -p "$HOME/.secula-backup"
secula checkout

if [ $? = 0 ] ; then
	echo "Checked out config.";
else 
	echo "Backing up pro-existing dot files.";
	secula checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .secula-backup/{}
fi;

secula checkout -f
secula submodule update --init --recursive
secula config status.showUntrackedFiles no
}

#-----------------------Install repositories
Install_Repositories ()
{
mkdir -p "$LOCAL_RESPOSITORY"
cd "$LOCAL_RESPOSITORY"

git clone git@github.com:zplat/Arch.git  # My Arch Installation

git clone https://aur.archlinux.org/paru.git # Feature packed AUR helper

#-----------------------Install paru
cd paru # Install paru
rustup default nightly
makepkg -si

cd # Return to home directory
}

#-----------------------Install AUR packages
Install_AUR ()
{
## Keyboard layout and Fonts
paru -S ttf-envy-code-r 
#paru -S ttf-google-fonts-git
# Web Browsers and supporting applications
paru -S lynx-current
paru -S google-chrome
# pdf Readers
paru -S zathura-pdf-mupdf-git
# System tools
#paru -S qmk-git
paru -S netrc
#Storage
paru -S dropbox
# Wayland
paru -S wlr-randr-git
# Tools
paru -S rofi-lbonn-wayland-git pass-tessen tessen
}


#-----------------------Setup ssh, gnugp, password manager
Setup_ssh () 
{
#-----------------------Setup gnupg

DIR="/run/media/phlight/$STORAGE/OnHold"
DIR2="/run/media/phlight/$STORAGE/OnHold/.local/share"

cp -pr "$DIR2/gnupg" ~/.local/share

chown -R $(whoami) "${HOME}/.local/share/gnupg/"
chmod 600 ~/.local/share/gnupg/*
chmod 700 ~/.local/share/gnupg

#-----------------------Setup .ssh

cp -pr "$DIR/.ssh" ~/

chown -R $(whoami) ~/.ssh
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*

eval $(ssh-agent) #Start agent
ssh-add "$HOME/.ssh/id_ed25519"
}

Install_Pass ()
{
git clone git@github.com:zplat/password-store.git ~/.password-store

# Backup info for netrc set up with pass for password access.
#GIT-CREDENTIAL-NETRC='https://raw.githubusercontent.com/git/git/master/contrib/credential/netrc/git-credential-netrc.perl'
#NETRC-EXEC="$HOME/.local/bin/git-credential-netrc"
#curl -o "$NETRC-EXEC" "$GIT-CREDENTIAL-NETRC"

git config --global credential.helper "netrc -f $HOME/.password-store/service.gpg -v -d"
}



#-----------------------Install More Packages
Install_Core ()
{
sudo pacman -Syu
# Web Browsers and supporting applications
sudo pacman --needed --noconfirm -S nyxt surfraw fuzzel
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
sudo pacman --needed --noconfirm -S xbindkeys xdg-desktop-portal-wlr qt5-wayland xorg-xwayland
#sudo pacman --needed --noconfirm -S xorg-server xorg-apps xorg-xinit picom 
# Terminals
sudo pacman --needed --noconfirm -S foot alacritty
# Window Managers
sudo pacman --needed --noconfirm -S sway swayidle swaylock swaybg
# Tools
sudo pacman --needed --noconfirm -S cmake rofi-pass tmux bat fzf broot fd ripgrep tmuxp xclip
#sudo pacman --needed --noconfirm -S bemenu-wayland bemenu 
# Programming
sudo pacman --needed --noconfirm -S r tk  
# Required 
sudo pacman --needed --noconfirm -S python-pillow stfl python-pygments python-gpgme python-pip nodejs libffi ninja librsync python-pyserial
}

 

#-----------------------Install repositories
Clone_Repositories ()
{
cd "$LOCAL_RESPOSITORY"

git clone https://github.com/neovim/neovim.git      # forked (ufo-fold)
git clone https://github.com/jarun/buku.git         # clone
git clone https://github.com/newsboat/newsboat.git  # clone
git clone https://github.com/qmk/qmk_firmware.git   # forked (ferris9)

git clone https://github.com/kovidgoyal/kitty       # forked
}

 

#--------------------------nixos
Setup_Nixos ()
{
sudo systemctl enable --now nix-daemon.service
sudo gpasswd -a "$USER" nix-users
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --update
#Install emanote
nix-env -iA nixpkgs.emanote
}



#--------------------------zramd systemd start and enable
Install_Swap ()
{
paru -S zramd
sudo systemctl enable --now zramd.service
}

#------------------------ Process order

#------ Install arch packages
Install_Basic
#------ Setup ssh & gnugp
Setup_ssh
#------ Install arch setup repository & setup paru
Install_Repositories
#------ AUR packages
Install_AUR
#------ Install MyDotfiles
Install_mydotfiles 
#------ Dotfiles
Install_dotfiles 
#------ Install Password Manager
Install_Pass
#------ Additional arch packages
Install_Core
#------ Download cloned Repositories
# Clone_Repositories
#------ Setup Nixos
Setup_Nixos 
#------ Install Zram Swap
Install_Swap 



