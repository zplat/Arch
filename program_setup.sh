#!/usr/bin/env sh 

############################################################
#
# 			Program set up!!
#
############################################################

#-----------------------Install repositories

mkdir ~/.local/repositories
cd ~/.local/repositories/

git clone https://aur.archlinux.org/paru.git            # Feature packed AUR helper
git clone https://github.com/zplat/Arch.git             # My Arch Installation
git clone https://github.com/neovim/neovim.git		    # neovim (see Chris@machine, YTube)
#git clone https://github.com/sereinity/ofi-pass.git     # Is a password promptor for pass 
cd paru                                                 # Install paru
makepkg -si
cd                                                      # Return to home directory

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
        sudo pacman -S --noconfirm --needed tmux bat fzf broot fd ripgrep tmuxp xclip	
        sudo pacman -S --noconfirm --needed picom fcitx5-mozc xbindkeys xorg-xinit fcitx5-config-qt  		
        sudo pacman -S --noconfirm --needed sway swayidle swaylock foot swaybg  			
        sudo pacman -S --noconfirm --needed xdg-desktop-portal-wlr  
        sudo pacman -S --noconfirm --needed bemenu-wayland bemenu rofi-pass
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
        paru -S vieb-bin-git buku-git lynx-git
	    paru -S rofi-lbonn-wayland-git
        paru -S dropbox dropbox-cli 
    	paru -S zramd wlr-randr-git 
        paru -S nerd-fonts-complete ttf-envy-code-r
fi

#----------------------zramd systemd start and enable

sudo systemctl enable --now zramd.service
