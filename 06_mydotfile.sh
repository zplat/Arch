#!/usr/bin/env sh 

############################################################
#
# 			Personal set up!!
#
############################################################

#-------------------------- Install dotfiles
DOTFILES="https://github.com/zplat/MyDotfiles.git"

git clone --bare --recurse-submodules "$DOTFILES" "$HOME/.dotfiles"

function config {
	/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

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
