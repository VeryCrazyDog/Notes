Get source directory of the executing script, reference https://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within
```sh
DIR="$(dirname "$(readlink -f "$0")")"
echo $DIR
```

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
cat <<EOT
helo smtpserver.com
mail from: sender@example.com
rcpt to: recipient@example.com
data
from: sender@example.com
to: recipient@example.com
subject: Test Email $(date +"%Y%m%d%H%M%S")

This is a test email from $(hostname).
.
quit
EOT
# Sleep for 2 seconds to allow server to return response
sleep 2
) | telnet smtpserver.com 25
```
