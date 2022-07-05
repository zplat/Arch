#!/usr/bin/env sh

#                           Arch install with btrfs.

#-----------------------------------------------------------------------------
#                                                                Which partitions 

BOOTDRIVE="/dev/sd" # eg BOOTDRIVE="/dev/sdc1".
ROOTDRIVE="/dev/sd" # eg BOOTDRIVE="/dev/sdc2".
HOMEDRIVE="/dev/sd" # eg BOOTDRIVE="/dev/sdc3". Can be same as ROOTDRIVE.

#-----------------------------------------------------------------------------
#                                                                Update mirrors

reflector -c "United Kingdom" -a 6 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syy

#-----------------------------------------------------------------------------
#                                                                network time protocol. 

timedatectl set-ntp true  # Update network time protocol. 

#-----------------------------------------------------------------------------
#                                                               Next script to install Arch. 

SETUP_URL="https://raw.githubusercontent.com/zplat/Arch/master/arch_basic.sh"

#-----------------------------------------------------------------------------
#                                                               Format drives

mkfs.fat -F32 "$BOOTDRIVE" #Format Boot partition.
fatlabel "$BOOTDRIVE" BOOT # To label the boot drive.  
mkfs.btrfs -f "$ROOTDRIVE"  #Format Root partition. Use -f to force overwrite. 
mkfs.btrfs -f "$HOMEDRIVE"  #Format Home partition. Don't if already setup.

#-----------------------------------------------------------------------------
#                                                               Mount drives

mount "$ROOTDRIVE" /mnt             # Volume

btrfs subvolume create /mnt/@       # Create the subvolumes.
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@var
btrfs subvolume create /mnt/@srv
btrfs subvolume create /mnt/@opt
btrfs subvolume create /mnt/@tmp

umount /mnt                         # Unmount the drive to mount the subvolumes.

#-----------------------------------------------------------------------------
#                                                               Mount subvolumes

SSD_OPTIONS="noatime,compress=zstd,space_cache=v2,discard=async,subvol"

mount -o "$SSD_OPTIONS"=@ "$ROOTDRIVE" /mnt

mkdir /mnt/{home,boot,var,srv,opt,tmp}

mount -o "$SSD_OPTIONS"=@home "$HOMEDRIVE" /mnt/home
mount -o "$SSD_OPTIONS"=@srv "$ROOTDRIVE" /mnt/srv
mount -o "$SSD_OPTIONS"=@opt "$ROOTDRIVE" /mnt/opt
mount -o "$SSD_OPTIONS"=@tmp "$ROOTDRIVE" /mnt/tmp
mount -o "$SSD_OPTIONS"=@var "$ROOTDRIVE" /mnt/var

mount "$BOOTDRIVE" /mnt/boot                            # Mount the boot partition.

#-----------------------------------------------------------------------------
#                                                               Install  initial programs

pacstrap /mnt base linux linux-firmware neovim git btrfs-progs 

#-----------------------------------------------------------------------------
#                                                               fstab

genfstab -U /mnt >> /mnt/etc/fstab

#-----------------------------------------------------------------------------
#                                                               Next install script

curl --url "$SETUP_URL" >> /mnt/shell.sh  # Install script from git post chroot

#-----------------------------------------------------------------------------
#                                                               chroot

arch-chroot /mnt
