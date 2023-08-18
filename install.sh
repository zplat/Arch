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

#-----------------------Install Packages
Install_Basic ()
{
 sudo pacman --needed --noconfirm -S ttf-hack ttf-hack-nerd ttf-inconsolata ttf-inconsolata-nerd ttf-sourcecodepro-nerd 
 sudo pacman --needed --noconfirm -S pass 
 sudo pacman --needed --noconfirm -S xbindkeys xdg-desktop-portal-wlr nix qt5-wayland xorg-xwayland
 sudo pacman --needed --noconfirm -S foot alacritty
 sudo pacman --needed --noconfirm -S cmake gnupg 
 sudo pacman --needed --noconfirm -S rustup gawk 
}

#-----------------------Install Dotfiles
function config {
	/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}
Config_files ()
{
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

#-----------------------Install AUR packages
Install_AUR ()
{
## Keyboard layout and Fonts
paru -S ttf-envy-code-r 
paru -S ttf-google-fonts-git
# Web Browsers and supporting applications
paru -S lynx-current
paru -S google-chrome
# pdf Readers
paru -S zathura-pdf-mupdf-git
# System tools
paru -S qmk-git
paru -S netrc
#Storage
paru -S dropbox
# Wayland
paru -S wlr-randr-git
# Tools
paru -S rofi-lbonn-wayland-git pass-tessen tessen
}
#-----------------------Setup password manager
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
sudo pacman --needed --noconfirm -S xorg-server xorg-apps xorg-xinit picom 
# Terminals
sudo pacman --needed --noconfirm -S foot alacritty
# Window Managers
sudo pacman --needed --noconfirm -S sway swayidle swaylock swaybg
# Tools
sudo pacman --needed --noconfirm -S bemenu-wayland bemenu cmake rofi-pass tmux bat fzf broot fd ripgrep tmuxp xclip
# Programming
sudo pacman --needed --noconfirm -S r tk rustup gawk 
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

#--------------------------dropbox systemd start and enable
#systemctl --user enable dropbox


