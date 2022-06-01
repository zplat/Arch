#!/usr/bin/env sh
#Arch install with btrfs.

# Identify which drives are to be used.
# eg BOOTDRIVE="/dev/sdc1".
BOOTDRIVE="/dev/sd"
ROOTDRIVE="/dev/sd"

# Update mirrors for faster updates.
pacman -Syy
pacman - reflector
reflector -c "United Kingdom" -a 6 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syy

# Update network time protocol. 
timedatectl set-ntp true 

# This is the next script to be used to install Arch. 
# Sets up a basic install.
SETUP_URL="https://raw.githubusercontent.com/zplat/ArchInstall/master/arch_basic.sh"

# Format drives

mkfs.fat -F32 "$BOOTDRIVE"
fatlabel "$BOOTDRIVE" BOOT 
# To labil the boot drive.
mkfs.btrfs -f "$ROOTDRIVE" 
#Use -f to force overwrite

# Mount drives

mount "$ROOTDRIVE" /mnt

# Create the subvolumes.
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@var
btrfs subvolume create /mnt/@srv
btrfs subvolume create /mnt/@opt
btrfs subvolume create /mnt/@tmp
btrfs subvolume create /mnt/@swap

# Unmount the drive to mount the subvolumes.
umount /mnt

# Mount subvolumes
mount -o noatime,compress=zstd,space_cache=v2,discard=async,subvol=@ "$ROOTDRIVE" /mnt

mkdir /mnt/{home,boot,var,srv,opt,tmp,swap}

mount -o noatime,compress=zstd,space_cache=v2,discard=async,subvol=@home "$ROOTDRIVE" /mnt/home
mount -o noatime,compress=zstd,space_cache=v2,discard=async,subvol=@srv "$ROOTDRIVE" /mnt/srv
mount -o noatime,compress=zstd,space_cache=v2,discard=async,subvol=@opt "$ROOTDRIVE" /mnt/opt
mount -o noatime,compress=zstd,space_cache=v2,discard=async,subvol=@tmp "$ROOTDRIVE" /mnt/tmp
mount -o noatime,compress=zstd,space_cache=v2,discard=async,subvol=@var "$ROOTDRIVE" /mnt/var
mount -o ssd,discard,subvol=@swap "$ROOTDRIVE" /mnt/swap

# Mount the boot partition.
mount "$BOOTDRIVE" /mnt/boot

# Install  initial programs (very basic)
pacstrap /mnt base linux linux-firmware neovim git btrfs-progs

# fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Install script from git post chroot
curl --url "$SETUP_URL" >> /mnt/shell.sh

# chroot
arch-chroot /mnt
