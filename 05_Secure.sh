#!/usr/bin/env sh

############################################################
#
# 			Personal set up!!
#
############################################################

USEREMAIL="5zero.6cool@gmail.com"
USERNAME="zplat"

git config --global user.email "$USEREMAIL"
git config --global user.name "$USERNAME"

#-----------------------Setup gnupg

DIR="/run/media/phlight/Storage2/OnHold"
DIR2="/run/media/phlight/Storage2/OnHold/.local/share"

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

#-----------------------Setup password manager

git clone git@github.com:zplat/password-store.git ~/.password-store

# Backup info for netrc set up with pass for password access.
#GIT-CREDENTIAL-NETRC='https://raw.githubusercontent.com/git/git/master/contrib/credential/netrc/git-credential-netrc.perl'
#NETRC-EXEC="$HOME/.local/bin/git-credential-netrc"
#curl -o "$NETRC-EXEC" "$GIT-CREDENTIAL-NETRC"

git config --global credential.helper "netrc -f /$HOME/.password-store/service.gpg -v -d"
