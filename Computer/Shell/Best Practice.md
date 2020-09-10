Use explicit form of redirection, reference http://wiki.bash-hackers.org/scripting/obsolete
```sh
# Explicit redirection for both stdin and stdout, preferred
echo "Hello World" > filename.txt 2>&1

# Simplified redirection syntax, not preferred
echo "Hello World" &> filename.txt
```

Enable exit on error and on undefined variables, enable exit code of a pipeline to that of the rightmost command to exit with a non-zero status, and output the error line using trap
```sh
set -euo pipefail
trap 'echo "[ERROR] ${BASH_SOURCE}:${LINENO} ${BASH_COMMAND}" >&2' ERR
```

Enable exit on error, reference http://blog.jobbole.com/111514/
```sh
set -e
# Long form, same as above
set -o errexit
```

Enable exit on undefined variables, reference http://blog.jobbole.com/111514/
```sh
set -u
# Long form, same as above
set -o nounset
```

Enable print each command before executing it, reference https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
```sh
set -x
# Long form, same as above
set -o xtrace
```

Enable command in shell function inherit ERR trap, reference https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
```sh
set -E
```

However, application writers should avoid relying on `set -e` within functions. For example, in the following script:
```sh
set -e
start() {
	some_server
	echo 'some_server started successfully'
}
start || echo >&2 'some_server failed'
```
the `-e` setting is ignored within the function body (because the function is a command in an AND-OR list other than the last). Therefore, if `some_server` fails (such as command not found), the function carries on to echo "some_server started successfully", and the exit status of the function is zero (which means "some_server failed" is not output).

To run command without exit on failure while having `-e` setting enabled, use `||`. Reference https://stackoverflow.com/questions/28899561/termporarily-disable-set-e-set-o-errexit-in-bash
```sh
# Noop
not_exist_command || :
# Alternatively execute true command
not_exist_command || true
```

Use lowercase with underscores for local variables, uppercase with underscores for environment variables and internal shell variables. Reference https://stackoverflow.com/questions/673055/correct-bash-and-shell-script-variable-capitalization
```sh
# Lowercase variable name, preferred
student_name="foo"
echo $student_name

# Uppercase variable name, not preferred
STUDENT_NAME="foo"
echo $STUDENT_NAME
```

Prefer quote when using variables
```sh
foo='yes   foo'

# Output: ${foo}
echo '${foo}'
# Output: yes foo
echo ${foo}
# Preferred, output: yes   foo
echo "${foo}"
# Output: ${foo}   bar
echo '${foo}   bar'
# Output: yes foo bar
echo ${foo}   bar
# Preferred, output: yes   foo   bar
echo "${foo}   bar"
```

Prefer curly braces around shell variables, reference https://stackoverflow.com/questions/8748831/when-do-we-need-curly-braces-around-shell-variables
```sh
# Curly braces, preferred and required in this case
echo "${foo}bar"

# Without curly braces, good for simple use
echo "bar$foo"
echo "$foo"
```

Prefer dollar over backtick for command execution, reference https://askubuntu.com/questions/487554/using-backticks-or-dollar-in-shell-scripts
```sh
# Dollar, preferred
foo=$(echo "foo's")
echo "$foo"

# Backtick, not preferred and semi-deprecated
foo=`echo "foo's"`
echo "$foo"
```

Prefer single square bracket for portability, reference https://stackoverflow.com/questions/669452/is-double-square-brackets-preferable-over-single-square-brackets-in-ba
```sh
foo='not   exist'
# Single square bracket, portable but require quote
if [ -e "$foo" ]; then
	echo 'File exists'
else
	echo 'File not exists'
fi

# Double square bracket, safer to use but not portable
if [[ -e $foo ]]; then
	echo 'File exists'
else
	echo 'File not exists'
fi
```

Use `readonly` for constant or read only variables, reference http://blog.jobbole.com/111514/
```sh
readonly passwd_file="/etc/passwd"
```
