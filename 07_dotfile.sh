#!/usr/bin/env sh 

############################################################
#
# 			Personal set up!!
#
############################################################

#-------------------------- Install dotfiles

BACKUP_DOTFILES="https://github.com/zplat/.bookmark.git"

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
sudo pacman -Syy        				# Update pacman package database
