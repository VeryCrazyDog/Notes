For Windows 7
```bat
@rem Do not use "echo off" to not affect any child calls

@rem Set environment variables local to this batch file
@setlocal

@rem Reset to Windows 7 default environment variables
@set Path=%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\
@set PSModulePath=%SystemRoot%\system32\WindowsPowerShell\v1.0\Modules
@set CLASSPATH=

@rem Configure additional environment variables, if any
@set PATH=%PATH%

@rem Switch to start location
@if not exist "%HOME%" @set HOME=%HOMEDRIVE%%HOMEPATH%
@if not exist "%HOME%" @set HOME=%USERPROFILE%
@cd /d "%HOME%"
@set HOME=

@rem Launch
@start "%COMSPEC%"
```

For Windows 10
```bat
@rem Do not use "echo off" to not affect any child calls

@rem Set environment variables local to this batch file
@setlocal

@rem Reset to Windows 10 default environment variables
@set Path=%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\;%SYSTEMROOT%\System32\OpenSSH\
@set PSModulePath=%ProgramFiles%\WindowsPowerShell\Modules;%SystemRoot%\system32\WindowsPowerShell\v1.0\Modules
@set CLASSPATH=

@rem Configure additional environment variables, if any
@set PATH=%PATH%

@rem Switch to start location
@if not exist "%HOME%" @set HOME=%HOMEDRIVE%%HOMEPATH%
@if not exist "%HOME%" @set HOME=%USERPROFILE%
@cd /d "%HOME%"
@set HOME=

@rem Launch
@start "%COMSPEC%"
```
