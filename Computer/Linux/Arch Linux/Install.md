# Arch Linux Installation Guide

## Installation on Virtual Box

This guide is written based on Arch Linux 2016.09.03 installing on Virtual Box 5.0.10 r104061, and referencing https://wiki.archlinux.org/index.php/installation_guide.

### Assumption

This guide assumes the following configuration will be used
* BIOS is used and UEFI mode is not enabled
* 64 bit CPU with 64 bit OS
* One single hard disk
* Using GPT partition
* One single root partition as partition scheme
* Swap file will be used instead of swap partition
* Minimal package installation
* With hostname `archlinux`
* Using Hong Kong time zone

### VM Setup

Configure VM with the following options
* System > Extended Features > Enable EFI: Not checked
* System > Extended Features > Hardware Clock in UTC Time: Checked

### Pre-installation

Connect to the Internet and verify a connection is established by using `ping`

```sh
ping archlinux.org
```

Idenify the hard disk

```sh
fdisk -l
```

Assuming the hard disk is `/dev/sdx`, partition the disk

```sh
gdisk /dev/sdx
```

At the `gdisk` prompt

1. Type `o`. This will delete all partitions and create a new GUID partition table (GPT)
2. Type `y` to confirm the previous action.
3. Type `p` to list partitions. There should be no partitions left.
4. Type `n`, press **ENTER** to accept the default partition number, press **ENTER** again to accept the default first sector, type `+1M` for the last sector, then type `ef02` for partition type *BIOS boot partition*. This creates the partition [used by GRUB boot loader](https://wiki.archlinux.org/index.php/GRUB#BIOS_systems).
5. Type `n`, press **ENTER** for 3 times to accept the default partition number, default first sector and default last sector, then type `8304` for partition type *Linux x86-64 root (/)*. This creates the root partition.
6. Type `w` and then `y` to confirm write the partition table and exit.

Format the root partition

```sh
mkfs.ext4 /dev/sdx2
```

Mount the file system

```sh
mount /dev/sdx2 /mnt
```

### Installation

Install the base packages

```sh
pacstrap /mnt base
```

### Configure the system

Generate an `fstab` file

```sh
genfstab -U /mnt >> /mnt/etc/fstab
```

Change root into new system

```sh
arch-chroot /mnt
```

Optionally install `vim` text editor

```sh
pacman -S vim
```

Install `systemd-swap` package

```sh
pacman -S systemd-swap
```

Set the line `swapfu_enabled=0` to `swapfu_enabled=1` in file `/etc/systemd/swap.conf`.

Enable swap file on boot

```sh
systemctl enable systemd-swap
```

Set the time zone

```sh
ln -s /usr/share/zoneinfo/Asia/Hong_Kong /etc/localtime
```

Generate `/etc/adjtime`

```sh
hwclock --systohc --utc
```

Uncomment `en_US.UTF-8 UTF-8` and other needed localizations in `/etc/locale.gen`

Generate locale

```sh
locale-gen
```

Set `LANG` variable

```sh
echo LANG=en_US.UTF-8 > /etc/locale.conf
```

Create hostname file

```sh
echo archlinux > /etc/hostname
```

Optionally adding a [matching entry](https://wiki.archlinux.org/index.php/Network_configuration#Local_network_hostname_resolution) to `/etc/hosts`. For a system with a permanent IP address, that permanent IP address should be used instead of `127.0.1.1`.

```
127.0.1.1 archlinux.localdomain archlinux
```

Optionally set the root password

```sh
passwd
```

Optionally install SSH client and server

```sh
pacman -S openssh
```

Optioanlly enable SSH server

```sh
systemctl enable sshd
```

[Install](https://wiki.archlinux.org/index.php/GRUB#Installation) `grub` package

```sh
pacman -S grub
```

If you have an Intel CPU, install the `intel-ucode` package

```sh
pacman -S intel-ucode
```

[Install boot loader](https://wiki.archlinux.org/index.php/GRUB#Install_to_disk) `GRUB` and additionally [enable microcode updates](https://wiki.archlinux.org/index.php/Microcode#Enabling_Intel_microcode_updates)

```sh
grub-install --target=i386-pc /dev/sdx
grub-mkconfig -o /boot/grub/grub.cfg
```

### Reboot

Exit chroot environment

```sh
exit
```

Restart the machine

```sh
reboot
```

### Checking

Check if swap file is active

```sh
free
```

## Configure Network Device using systemd-networkd

Identify the network device name

```sh
ip addr
```

Assume the network device is `ethX`, create network files for the required network devices at `/etc/systemd/network/ethX.network`. For DHCP, use the following content

```ini
[Match]
Name=ethX

[Network]
DHCP=both
```

For static IP, use the content similiar to the following

```ini
[Match]
Name=ethX

[Network]
Address=192.168.1.11/24
Gateway=192.168.1.1
DNS=8.8.8.8
DNS=8.8.4.4
```

Enable using DNS from DHCP

```sh
rm /etc/resolv.conf
ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
```

Enable required services

```sh
systemctl enable systemd-networkd
systemctl enable systemd-resolved
```

Start required services

```sh
systemctl start systemd-networkd
systemctl start systemd-resolved
```
