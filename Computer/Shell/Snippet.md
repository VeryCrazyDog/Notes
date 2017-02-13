Exit if the script is not run as root

```sh
if [ "$(id -u)" != "0" ]; then
	echo 'This script must be run as root' 1>&2
	exit 1
fi
```

A function for backup backup purpose

```sh
mkbak() {
	sudo cp -pv "$1" "$1.$(date +"%Y%m%d%H%M%S").bak"
}
```

PS1 prompt for different environment with style

```sh
# For development
PS1='\[\e[0;1;32m\]\u@\h\[\e[0m\] \[\e[1;34m\]\w\$\[\e[0m\] '

# For UAT
PS1='\[\e[0;1;32m\]\u\[\e[0;1m\]@\[\e[1;33m\]\h\[\e[0m\] \[\e[1;34m\]\w\$\[\e[0m\] '

# For production
PS1='\[\e[0;1;32m\]\u\[\e[0;1m\]@\[\e[1;4;31m\]\h\[\e[0m\] \[\e[1;34m\]\w\$\[\e[0m\] '
```

Disable `rm` by alias

```sh
# Prevent `rm`
alias rm='echo "You are in production environment - rm is disabled, use trash or /bin/rm instead."'
# Prevent `sudo rm`
alias sudo='sudo '
```
