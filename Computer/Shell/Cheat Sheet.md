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
(
echo "HELO smtpserver.com";
echo "mail from: you@sender.com";
echo "rcpt to: friend@recipient.com";
echo "data";
echo "subject: Test Email $(date +"%Y%m%d%H%M%S")";
echo "";
echo "This is a test email from $(hostname).";
echo ".";
echo "quit";
) | telnet smtpserver.com 25
```
