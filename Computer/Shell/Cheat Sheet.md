Create a file with timestamp as part of the filename

```sh
touch test_file_$(date +'%Y%m%d%H%M%S')
```

Case sensitive replace of string `foo` with `bar` in file `filename.txt`

```sh
sed -i -e 's/foo/bar/g' filename.txt
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