Exit if the script is not run as root

```sh
if [ "$(id -u)" != "0" ]; then
	echo 'This script must be run as root' 1>&2
	exit 1
fi
```

Create a file with timestamp as part of the filename

```sh
touch test_file_$(date +'%Y%m%d%H%M%S')
```

Case sensitive replace of string `foo` with `bar` in file `filename.txt`

```sh
sed -i -e 's/foo/bar/g' filename.txt
```
