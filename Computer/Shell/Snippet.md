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

A function for backup backup purpose

```sh
mkbak() {
	sudo cp -pv "$1" "$1.$(date +"%Y%m%d%H%M%S").bak"
}
```

Send test email using telnet

```sh
cat <<EOT > mail.txt
HELO smtpserver.com
mail from: you@sender.com
rcpt to: friend@recipient.com
data
subject: Test Email $(date +"%Y%m%d%H%M%S")

This is a test email from $(hostname).
.
quit
EOT
cat mail.txt | telnet smtpserver.com 25
rm mail.txt
```
