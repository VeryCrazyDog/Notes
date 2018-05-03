To redirect the stderr to NUL

```bat
dir file.xxx 2> nul
```

To redirect the stdout and stderr to different files

```bat
dir file.xxx > output.msg 2> output.err
```

To redirect both stdout and stderr to the same file

```bat
dir file.xxx > output.msg 2>&1

dir file.xxx 1> output.msg 2>&1
```

To redirect both stdout and stderr to append to the same file

```bat
dir file.xxx >> output.msg 2>&1

dir file.xxx 1>> output.msg 2>&1
```
