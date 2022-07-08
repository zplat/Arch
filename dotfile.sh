#!/usr/bin/env sh 

############################################################
#
# 			dotfiles!!
#
############################################################


DOTFILES="https://github.com/zplat/.bookmark.git"

git clone --bare --recurse-submodules "$DOTFILES" "$HOME/.secfiles"

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

