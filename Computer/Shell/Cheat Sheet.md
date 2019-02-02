# Shell parameter expansion
Shell parameter expansion reference: http://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html

Replace all string by another string, not supported by all shell
```bash
input='Today is ${TODAY_DATE}'
new_value='2019-01-01'
result=${input//\$\{TODAY_DATE\}/${new_value}}
echo "$result"
```

Return another string when string is null or not set
```sh
input='my value'
echo "result: ${input:+"message=${input}"}"
echo "result: ${input:+"message=Hello World!"}"
input=''
echo "result: ${input:+"message=${input}"}"
```

# sed
Case sensitive replace of string `foo` with `bar` in file `filename.txt`
```sh
sed -i -e 's/foo/bar/g' filename.txt
```

Replace all string by another string in varible using here string
```sh
input='Today is ${TODAY_DATE}'
new_value='2019-01-01'
sed -e "s/\${TODAY_DATE}/${new_value}/g" <<< "$input"
```

# awk
Decimal comparision using `awk`, and print out `1` or `0`
```sh
number1=3
number2=4
awk "BEGIN { print ("${number1}" < "${number2}") }"
```

# Uncategorized
Get source directory of the executing script, reference https://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within
```sh
dir="$(dirname "$(readlink -f "${0}")")"
echo "$dir"
```

Create a file with timestamp as part of the filename
```sh
touch "test_file_$(date +'%Y%m%d%H%M%S')"
```

Use `eval` to split quoted delimited string and use array to pass tokens into command
```sh
print_args() {
	echo "1st argument: ${1}"
	echo "2nd argument: ${2}"
	echo "3rd argument: ${3}"
}
tags='"key1=value1" "key2=value   with   space" "key3=value3"'
tag_array=()
eval "for word in ${tags}; do tag_array+=(\"\${word}\"); done"
print_args "${tag_array[@]}"
```

Send test email using telnet and heredoc
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
