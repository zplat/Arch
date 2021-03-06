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

#GIT-CREDENTIAL-NETRC='https://raw.githubusercontent.com/git/git/master/contrib/credential/netrc/git-credential-netrc.perl'
#NETRC-EXEC="$HOME/.local/bin/git-credential-netrc"
#curl -o "$NETRC-EXEC" "$GIT-CREDENTIAL-NETRC"

git config --global credential.helper "netrc -f /$HOME/.password-store/service.gpg -v -d"

git config --global user.email "5zero.6cool@gmail.com"
git config --global user.name "zplat"

#-------------------------- Install dotfiles
DOTFILES="https://github.com/zplat/MyDotfiles.git"

git clone --bare --recurse-submodules "$DOTFILES" "$HOME/.dotfiles"

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

#-------------------------- Install dotfiles

BACKUP_DOTFILES="https://github.com/zplat/.bookmark.git"

git clone --bare --recurse-submodules "$BACKUP_DOTFILES" "$HOME/.secfiles"

function secula {
	/usr/bin/git --git-dir=$HOME/.secfiles/ --work-tree=$HOME $@
}

mkdir -p .secula-backup
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

#--------------------------

zsh

sudo pacman -Syy        				# Update pacman package database
sudo pacman -S --needed rustup				# Install rust
rustup default nightly  				# Setup rustup

reboot
