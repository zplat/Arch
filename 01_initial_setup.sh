#!/usr/bin/env sh

#                           Arch install with btrfs.


BOOT_DRIVE="sd" # eg BOOT_DRIVE="sdc1".
ROOT_DRIVE="sd" # eg ROOT_DRIVE="sdc2"

#---------------------- DO NOT EDIT
BOOTDRIVE="/dev/$BOOT_DRIVE" # DO NOT EDIT
ROOTDRIVE="/dev/$ROOT_DRIVE" # DO NOT EDIT

#-----------------------------------------------------------------------------
#                                                                Update mirrors

reflector -c "United Kingdom" -a 6 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syy

#-----------------------------------------------------------------------------
#                                                                network time protocol.

timedatectl set-ntp true # Update network time protocol.

#-----------------------------------------------------------------------------
#                                                               Next script to install Arch.

SETUP_URL="https://raw.githubusercontent.com/zplat/Arch/master/02_basic_setup.sh"

#-----------------------------------------------------------------------------
#                                                               Format drives

mkfs.fat -F32 "$BOOTDRIVE" #Format Boot partition.
fatlabel "$BOOTDRIVE" BOOT # To label the boot drive.
mkfs.btrfs -f "$ROOTDRIVE" #Format Root partition. Use -f to force overwrite.

#-----------------------------------------------------------------------------
#                                                               Mount /mnt

mount "$ROOTDRIVE" /mnt # Volume
#                                                               Create subvols
btrfs subvolume create /mnt/@ # Create the subvolumes. Root.
btrfs subvolume create /mnt/@home # Create the subvolumes. Home.
#                                                               Unmount /mnt
umount /mnt # Unmount the drive to mount the subvolumes.

#-----------------------------------------------------------------------------
#                                                               Mount subvolumes

SSD_OPTIONS="noatime,ssd,compress=zstd,space_cache=v2,discard=async,subvol"

mount -o "$SSD_OPTIONS"=@ "$ROOTDRIVE" /mnt

mkdir /mnt/home

mount -o "$SSD_OPTIONS"=@home "$ROOTDRIVE" /mnt/home

mkdir -p /mnt/boot/efi

mount "$BOOTDRIVE" /mnt/boot/efi # Mount the boot partition.

#-----------------------------------------------------------------------------
#                                                               Install  initial programs

pacstrap -K /mnt base linux linux-firmware btrfs-progs vim 

#-----------------------------------------------------------------------------
#                                                               fstab

genfstab -U /mnt >>/mnt/etc/fstab

#-----------------------------------------------------------------------------
#                                                               Next install script

curl --url "$SETUP_URL" >>/mnt/shell.sh # Install script from git post chroot

#-----------------------------------------------------------------------------
#                                                               chroot

arch-chroot /mnt
