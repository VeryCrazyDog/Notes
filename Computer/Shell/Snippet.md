Exit if the script is not run as root
```sh
if [ "$(id -u)" != "0" ]; then
	echo >&2 'This script must be run as root'
	exit 1
fi
```

A simple function for backup purpose
```sh
mkbak() {
	for arg in "$@"
	do
		sudo cp -pv "${arg}" "${arg}.$(date +"%Y%m%d%H%M%S").bak"
	done
}
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

Retry function
```bash
retry() {
	declare -ir retry=$1
	declare -i attempt=0
	declare -i rc=255
	declare -i sleep_count=0
	while [ $rc -ne 0 ] && [ $attempt -le $retry ]; do
		if [ $attempt -gt 0 ]; then
			echo -n "Wait ${attempt} seconds for retry #${attempt}"
			sleep_count=0
			while  [ $sleep_count -lt $attempt ]; do
				sleep_count=$(( sleep_count + 1 ))
				sleep 1
				echo -n .
			done
			echo
		fi
		attempt=$(( attempt + 1 ))
		"${@:2}" && rc=$? || rc=$?
	done
	return $rc
}
retry 2 ls -l /non-exist-path
```
