# Shell parameter expansion
Shell parameter expansion reference: http://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html

Replace all string by another string, not supported by all shell
```bash
INPUT='Today is ${TODAY_DATE}'
NEW_VALUE='2019-01-01'
RESULT=${INPUT//\$\{TODAY_DATE\}/${NEW_VALUE}}
echo "$RESULT"
```

Return another string when string is null or not set
```sh
INPUT='my value'
echo "RESULT: ${INPUT:+"message=${INPUT}"}"
echo "RESULT: ${INPUT:+"message=Hello World!"}"
INPUT=''
echo "RESULT: ${INPUT:+"message=${INPUT}"}"
```

# sed
Case sensitive replace of string `foo` with `bar` in file `filename.txt`
```sh
sed -i -e 's/foo/bar/g' filename.txt
```

Replace all string by another string in varible using here string
```sh
INPUT='Today is ${TODAY_DATE}'
NEW_VALUE='2019-01-01'
sed -e "s/\${TODAY_DATE}/${NEW_VALUE}/g" <<< "$INPUT"
```

# aws
Decimal comparision using `awk`, and print out `1` or `0`
```sh
NUMBER1=3
NUMBER2=4
awk "BEGIN { print ("${NUMBER1}" < "${NUMBER2}") }"
```

# Uncategorized
Get source directory of the executing script, reference https://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within
```sh
DIR="$(dirname "$(readlink -f "${0}")")"
echo "$DIR"
```

Create a file with timestamp as part of the filename
```sh
touch "test_file_$(date +'%Y%m%d%H%M%S')"
```

Use `eval` to split quoted delimited string and use array to pass tokens into command
```sh
printargs() {
	echo "1st argument: ${1}"
	echo "2nd argument: ${2}"
	echo "3rd argument: ${3}"
}
TAGS='"key1=value1" "key2=value with space" "key3=value3"'
TAG_ARRAY=()
eval 'for WORD in '$TAGS'; do TAG_ARRAY+=("$WORD"); done'
printargs "${TAG_ARRAY[@]}"
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
