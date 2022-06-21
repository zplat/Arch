#!/usr/bin/env sh 

############################################################
# Before using be sure that the .ssh file has been set up!!
############################################################


# Create XDG user directories
xdg-user-dirs-update

# Setup rustup
rustup default nightly

# Install paru
mkdir ~/.local/respositories
cd ~/.local/repositories/
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

# Install dotfiles.
git clone --bare --recurse-submodules https://github.com/zplat/MyDotfiles.git $HOME/.dotfiles

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


sudo pacman -Syy

sudo pacman -S imv mpv feh sxiv
sudo pacman -S vieb nodejs
sudo pacman -S neovim zk 
sudo pacman -S tmux bat fzf broot fd ripgrep rofi picom fcitx-mozc xbindkeys xorg-xinit
sudo pacman -S pass 
sudo pacman -S sway swayidle swaylock foot xdg-desktop-portal-wlr bemenu-wayland bemenu 

paru -S alacritty-git buku-git awesome-git lynx-git 
paru -S dropbox dropbox-cli 
paru -S river-git wlr-randr-git 
paru -S nerd-fonts-complete ttf-envy-code-r
