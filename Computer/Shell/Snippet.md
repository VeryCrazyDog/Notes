Exit if the script is not run as root

```sh
if [ "$(id -u)" != "0" ]; then
	echo 'This script must be run as root' 1>&2
	exit 1
fi
```

A function for backup purpose

```sh
mkbak() {
	sudo cp -pv "$1" "$1.$(date +"%Y%m%d%H%M%S").bak"
}
```

Another version of the backup function above, but backup the file to another location

```sh
#!/bin/bash

# Configuration
path_backup_root_dir=$(realpath ~/Backup/$(hostname))

# Implementation

# Check arguments
if [[ $# -eq 0 ]]; then
	echo "mkbak: missing file operand"
	exit 1
fi

# Init switch
use_ori_suffix=0
path_backup_src=

# Parse arguments
while test $# != 0
do
	case "$1" in
	-o)
		use_ori_suffix=1
		;;
	--)
		shift
		break
		;;
	*)
		path_backup_src=$1
		;;
	esac
	shift
done

# Determinate path
path_backup_src=$(realpath $path_backup_src)
path_backup_dest=${path_backup_root_dir}${path_backup_src}
path_backup_dir=$(dirname $path_backup_dest)

# Determinate filename suffix
filename_suffix=.bak
if [[ $use_ori_suffix -eq 1 ]]; then
	filename_suffix=.ori$filename_suffix
fi

# Prepare directory
if [ ! -d "$path_backup_dir" ]; then
	echo "Creating directory $path_backup_dir"
	mkdir -p $path_backup_dir
fi

# Perform copy
sudo cp -pv "$path_backup_src" "$path_backup_dest.$(date +"%Y%m%d%H%M%S")$filename_suffix"
```

PS1 prompt for different environment with style, inspired by https://gitlab.com/gitlab-com/infrastructure/issues/1094

```sh
# For development
PS1='\[\e[0;1;32m\]\u@\h\[\e[0m\] \[\e[1;34m\]\w\$\[\e[0m\] '

# For UAT
PS1='\[\e[0;1;32m\]\u\[\e[0;1m\]@\[\e[1;33m\]\h\[\e[0m\] \[\e[1;34m\]\w\$\[\e[0m\] '

# For production
PS1='\[\e[0;1;32m\]\u\[\e[0;1m\]@\[\e[1;4;31m\]\h\[\e[0m\] \[\e[1;34m\]\w\$\[\e[0m\] '
```

Disable `rm` by alias, inspired by https://gitlab.com/gitlab-com/infrastructure/issues/1094

```sh
# Prevent `rm`
alias rm='echo "You are in production environment - rm is disabled, use trash or /bin/rm instead."'
# Prevent `sudo rm`
alias sudo='sudo '
```
