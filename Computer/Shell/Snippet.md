Exit if the script is not run as root
```sh
if [ "$(id -u)" != "0" ]; then
	echo >&2 'This script must be run as root'
	exit 1
fi
```

A function for backup purpose
```sh
mkbak() {
	sudo cp -pv "$1" "${1}.$(date +"%Y%m%d%H%M%S").bak"
}
```

Another version of the backup function above, but backup the file to another location
```sh
#!/bin/bash

# Enable exit on error
set -e
# Enable exit on undefined variables
set -u

# Configuration
dest_root_dir_path=$(realpath ~/"Backup/$(hostname)")

# Constants
readonly backup_suffix='.bak'
readonly original_suffix='.ori'

# Set default options
use_ori_suffix=0
src_path=

# Parse arguments
while [ $# -gt 0 ]; do
	case "$1" in
		-*)
			case "$1" in
				-o) use_ori_suffix=1;;
				--)
					shift
					break
					;;
				*)
					echo >&2 "Unknown option '${1}'"
					exit 1
					;;
			esac
			;;
		*)
			if [ -z "$src_path" ]; then
				src_path="$1"
			fi
		 	;;
	esac
	shift
done

while [ $# -gt 0 ]; do
	case "$1" in
		*)
			if [ -z "$src_path" ]; then
				src_path="$1"
			fi
		 	;;
	esac
	shift
done

# Check arguments
if [ -z "$src_path" ]; then
	echo >&2 "${0}: missing file operand"
	exit 1
fi

# Determinate path
src_path=$(realpath -- "${src_path}")
dest_path="${dest_root_dir_path}${src_path}"
dest_dir_path=$(dirname "${dest_path}")

# Determinate filename suffix
filename_suffix="$backup_suffix"
if [ $use_ori_suffix -eq 1 ]; then
	filename_suffix="${original_suffix}${filename_suffix}"
fi

# Prepare directory
if [ ! -d "$dest_dir_path" ]; then
	echo "Creating directory '${dest_dir_path}'"
	mkdir -p "${dest_dir_path}"
fi

# Perform copy
sudo cp -pv "${src_path}" "${dest_path}.$(date +"%Y%m%d%H%M%S")${filename_suffix}"
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
# Combine with above to prevent `sudo rm`
alias sudo='sudo '
```
