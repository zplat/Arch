#!/usr/bin/env sh

############################################################
#
# 			Arch basic set up!!
#
############################################################

#-------------------------------------------------------------------------------
#                                                                  Key variables

HOST_NAME=''
ROOT_PASSWD=''
USER=''
USER_PASSWD=''

SETUP_URL="https://raw.githubusercontent.com/zplat/Arch/main/install.sh"
LOCAL_RESPOSITORY="/home/$USER/.local/repositories"
ARCH_RESPOSITORY="/home/$USER/.local/repositories/Arch"

#-------------------------------------------------------------------------------
#                                                                  set time

ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc

#-------------------------------------------------------------------------------
#                                                                  set language locale.

echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen
echo "ko_KR.UTF-8 UTF-8" >> /etc/locale.gen #Well over the top!

#-------------------------------------------------------------------------------
#                                                                  Update locale

locale-gen

#-------------------------------------------------------------------------------
#                                                                  Configure locale.conf.

echo "LANG=en_GB.UTF-8" >> /etc/locale.conf

#-------------------------------------------------------------------------------
#                                                                 Set terminal fonts

echo "FONT=ter-132n" >> /etc/vconsole.conf
echo "FONT_MAP=8859-1" >> /etc/vconsole.conf

#-------------------------------------------------------------------------------
#                                                                  Network

echo "$HOST_NAME" >>/etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1  ${HOST_NAME}.localdomain $HOST_NAME" >> /etc/hosts

#-------------------------------------------------------------------------------
#                                                                  set root password

echo "root:${ROOT_PASSWD}" | chpasswd

#-------------------------------------------------------------------------------
#                                                                  Update pacman repositories. multilib.

sed -i 's/^#\[multilib\]/\[multilib\]/' /etc/pacman.conf
sed -i '/^\[multilib\]/ {n;s/^#//}' /etc/pacman.conf
sed -i '/^#ParallelDownloads/ {n;s//ILoveCandy/}' /etc/pacman.conf
sed -i 's/^#ParallelDownloads/ParallelDownloads' /etc/pacman.conf
sed -i 's/^#Color/Color' /etc/pacman.conf
pacman -Syy

#-------------------------------------------------------------------------------
#                                                                  install packages

pacman --needed --noconfirm -S  grub efibootmgr reflector
pacman --needed --noconfirm -S  networkmanager network-manager-applet wpa_supplicant 
pacman --needed --noconfirm -S  base-devel linux-headers pacman-contrib
pacman --needed --noconfirm -S  xdg-user-dirs xdg-utils terminus-font
pacman --needed --noconfirm -S  zsh zsh-completions
pacman --needed --noconfirm -S  udiskie ntfs-3g openssh bluez bluez-utils git moreutils
pacman --needed --noconfirm -S  xf86-video-amdgpu amd-ucode

#-------------------------------------------------------------------------------
#                                                                  change shell bash to zsh

chsh -s /bin/zsh

#-------------------------------------------------------------------------------
#                                                                  setup mkinitcpio for amd graphics processor.

sed -i 's/MODULE.*/MODULE=\(btrfs amdgpu\)/' /etc/mkinitcpio.conf
mkinitcpio -p linux

#-------------------------------------------------------------------------------
#                                                                  Install grub

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB #--removable --recheck
grub-mkconfig -o /boot/grub/grub.cfg

#-------------------------------------------------------------------------------
#                                                                  Setup systemctl hooks

#------------------------set reflector defaults

echo "# Set the output path where the mirrorlist will be saved (--save).
--save /etc/pacman.d/mirrorlist
# Select the transfer protocol (--protocol).
--protocol https
# Select the country (--country).
# Consult the list of available countries with "reflector --list-countries" and
# select the countries nearest to you or the ones that you trust. For example:
--country FR,DE,IE,NL,GB
# Use only the  most recently synchronized mirrors (--latest).
--latest 100
# Sort the mirrors by synchronization time (--sort).
--sort score
" >/etc/xdg/reflector/reflector.conf

#------------------------Automate package cleaning with paccache

echo "[Trigger]
Operation = Remove
Operation = Install
Operation = Upgrade
Type = Package
Target = *
[Action]
Description = Keep the last cache and the currently installed.
When = PostTransaction
Exec = /usr/bin/paccache -rvk2
" >/usr/share/libalpm/hooks/paccache.hook

#------------------------list of orphan apps to remove

echo "[Trigger]
Operation = Install
Operation = Remove
Type = Package
Target = *
[Action]
When = PostTransaction
Exec = /usr/bin/bash -c \"/usr/bin/pacman -Qtd > $ARCH_RESPOSITORY/orphanpkglist.txt || /usr/bin/echo '==> no orphans found'\"
" >/usr/share/libalpm/hooks/pkgClean.hook

#------------------------list of Core programs

echo "[Trigger]
Operation = Install
Operation = Remove
Type = Package
Target = *
[Action]
When = PostTransaction
Exec = /bin/sh -c '/usr/bin/pacman -Qqent > $ARCH_RESPOSITORY/corepkglist.txt'
" >/usr/share/libalpm/hooks/pkgCore.hook

#------------------------list of AUR programs

echo "[Trigger]
Operation = Install
Operation = Remove
Type = Package
Target = *
[Action]
When = PostTransaction
Exec = /bin/sh -c '/usr/bin/pacman -Qqem > $ARCH_RESPOSITORY/aurpkglist.txt'
" >/usr/share/libalpm/hooks/pkgAUR.hook

#-------------------------------------------------------------------------------
#                                                                  cacche

pacman -S ccache
sed -i 'x;/^BUILDENV/s/!ccache/ccache/' /etc/makepkg.conf

#-------------------------------------------------------------------------------
#                                                                  MAKEFLAGS

CORES=$(nproc)
LOAD=$((CORES / 2))
JOBS=$((LOAD + 1))
sed -i "x;/^#MAKEFLAGS/s/"-j2"/-j${JOBS} -l${LOAD}/ " /etc/makepkg.conf
sed -i "x;/^#MAKEFLAGS/s/^#//" /etc/makepkg.conf

#-------------------------------------------------------------------------------
#                                                                  add user

useradd -m -g users -s /bin/zsh "$USER"
echo "${USER}:${USER_PASSWD}" | chpasswd

#-------------------------------------------------------------------------------
#                                                                  make user an administrator

#echo "$USER ALL=(ALL) ALL" >>"/etc/sudoers.d/$USER"

#-------------------------------------------------------------------------------
#                                                                  enable systemd services

systemctl enable NetworkManager.service
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable paccache.timer
systemctl enable reflector.service
systemctl enable bluetooth.service

#-------------------------------------------------------------------------------
#                                                                  Install post install script.

curl --url "$SETUP_URL" >>"/home/$USER/shell.sh"

#-------------------------------------------------------------------------------
#                                                                  all done
printf "\e[1;32mdone! type exit, umount -a and reboot.\e[0m"

#-------------------------------------------------------------------------------
shred -uvz shell.sh
