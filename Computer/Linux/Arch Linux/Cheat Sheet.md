# Arch Linux specific Cheat Sheet

Update package list

```sh
pacman -Sy
```

Query list of upgradable packages

```sh
pacman -Qu
```

Update all packages (with confirmation)

```sh
pacman -Syu
```

Search package

```sh
pacman -Ss keyword
```

To display extensive information about a given package

```sh
pacman -Si package_name
```

Install package

```sh
pacman -S package_name
```

To remove a package and its dependencies which are not required by any other installed package

```sh
pacman -Rs package_name
```

List all packges

```sh
pacman -Q
```

List all foreign packages

```sh
pacman -Qm
```

Shows list of files installed by a package

```sh
pacman -Ql package_name
```

Query database whih package owns a command or file

```sh
pacman -Qo keyword
```

Rebuilding pacman keyring

```sh
# Install keyring, either one below
# x86
pacman -S archlinux-keyring
# arm
pacman -S archlinuxarm-keyring

# Initialize pacman keyring
pacman-key --init

# Import Arch Linux keyring to pacman keyring
# x86
pacman-key --populate archlinux
# arm
pacman-key --populate archlinuxarm
```


Show list of files to included in a package

```sh
pkgfile -l package_name
```

Locate .pacnew .pacorig .pacsave files

```sh
locate -e --regex "\.pac(new|orig|save)$"
```

Check current status of service

```sh
systemctl status service_name
```

Check if service enabled or not

```sh
systemctl is-enabled service_name
```

Enable service

```sh
systemctl enable service_name
```

Start service

```sh
systemctl start service_name
```

List boot ID in systemd journal

```sh
journalctl --list-boot
```

Check log for last boot with priority higher than error or above in systemd journal

```sh
journalctl -p 3 -xb -0
```

Check log for current boot with priority higher than error or above in systemd journal

```sh
journalctl -p 3 -xb
```

Sort mirror list by speed

```sh
# Copy the mirror list for select mirror for testing
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.selection

# Edit /etc/pacman.d/mirrorlist.selection and uncomment mirrors for testing with rankmirrors

# Rank the top 5 fastest mirrors
rankmirrors -n 5 /etc/pacman.d/mirrorlist.selection > /etc/pacman.d/mirrorlist.rank

# Update /etc/pacman.d/mirrorlist based on the ranked result in /etc/pacman.d/mirrorlist.rank

# Remove the mirror used in ranking
rm /etc/pacman.d/mirrorlist.selection /etc/pacman.d/mirrorlist.rank

# Force pacman to refresh all packages even if they are considered to be up to date to avoid possible issues due to change in mirror
pacman -Syyu
```
