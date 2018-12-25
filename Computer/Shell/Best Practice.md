Use upper case for variables, reference https://stackoverflow.com/questions/673055/correct-bash-and-shell-script-variable-capitalization
```sh
# Upper case variable name, preferred
STUDENT_NAME="foo"
echo $STUDENT_NAME

# Lower case variable name, not preferred
student_name="foo"
echo $student_name
```

Prefer quote when using variables
```sh
FOO='yes   foo'
# Output: $FOO
echo '$FOO'
# Output: yes foo
echo $FOO
# Preferred, output: yes   foo
echo "$FOO"
# Output: $FOO   bar
echo '$FOO   bar'
# Output: yes foo bar
echo $FOO   bar
# Preferred, output: yes   foo   bar
echo "$FOO   bar"
```

Prefer curly braces around shell variables, reference https://stackoverflow.com/questions/8748831/when-do-we-need-curly-braces-around-shell-variables
```sh
# Curly braces, preferred and required in this case
echo "${FOO}bar"

# Without curly braces, good for simple use
echo "bar$FOO"
echo "$FOO"
```

Prefer dollar over backtick for command execution, reference https://askubuntu.com/questions/487554/using-backticks-or-dollar-in-shell-scripts
```sh
# Dollar, preferred
FOO=$(echo "foo's")
echo $FOO

# Backtick, not preferred and semi-deprecated
FOO=`echo "foo's"`
echo $FOO
```

Prefer single square bracket for portability, reference https://stackoverflow.com/questions/669452/is-double-square-brackets-preferable-over-single-square-brackets-in-ba
```sh
FOO='not   exist'
# Single square bracket, portable but require quote
if [ -e "$FOO" ]; then
  echo 'File exists'
else
  echo 'File not exists'
fi

# Double square bracket, safer to use but not portable
if [[ -e $FOO ]]; then
  echo 'File exists'
else
  echo 'File not exists'
fi
```
