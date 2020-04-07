`win7_default.bat`
```bat
@rem Reset to Windows 7 default environment variables
@set Path=%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\
@set PSModulePath=%SystemRoot%\system32\WindowsPowerShell\v1.0\Modules\
@set PATHEXT=.COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC
@set CLASSPATH=
```

`win10_default.bat`
```bat
@rem Reset to Windows 10 default environment variables
@set Path=%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\;%SYSTEMROOT%\System32\OpenSSH\
@set PSModulePath=%ProgramFiles%\WindowsPowerShell\Modules;%SystemRoot%\system32\WindowsPowerShell\v1.0\Modules
@set PATHEXT=.COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC
@set CLASSPATH=
```

`basic.bat` for Windows 10
```bat
@rem Reset to Windows 10 default environment variables
@call "E:\Programs\Scripts\set_env\win10_default.bat"

@rem Include custom batch files
@set PATH=%PATH%;E:\Programs\Scripts\cmd_bat

@rem Include Notepad2
@set PATH=%PATH%;C:\Programs\Notepad2

@rem Include Git
@set PATH=%PATH%;E:\Programs\PortableGit\bin

@rem Include 7za
@set PATH=%PATH%;E:\Programs\7-Zip Extra
```

`dev_default.bat` for Windows 10
```bat
@rem Set to basic environment
@call "E:\Programs\Scripts\set_env\basic.bat"

@rem Include Node.js
@set PATH=%PATH%;E:\Programs\Node.js\node-v8.12.0-win-x64

@rem Include Python
@set PATH=%PATH%;E:\Programs\python\python-3.7.2-amd64;E:\Programs\python\python-3.7.2-amd64\Scripts;%APPDATA%\Python\Python37\Scripts

@rem Include .NET Core
@set PATH=%PATH%;C:\Programs\netcore\3.1.200;%USERPROFILE%\.dotnet\tools

@rem Include PHP
@set PATH=%PATH%;E:\Programs\PHP\php-7.2.3-Win32-VC15-x64

@rem Set JAVA_HOME
@set JAVA_HOME=E:\Programs\JDK\jdk1.8.0_102
@rem Include Java
@set PATH=%PATH%;%JAVA_HOME%\bin

@rem Include Android tools
@set PATH=%PATH%;E:\Programs\Android\SDK\platform-tools

@rem Include MySQL
@set PATH=%PATH%;C:\Programs\mysql\mysql-5.6.34-winx64\bin
@rem Include MySQL Utilities
@set PATH=%PATH%;C:\Program Files\MySQL\MySQL Utilities 1.6

@rem Include PostgreSQL
@set PATH=%PATH%;C:\Programs\postgresql\postgresql-10.4-1-windows-x64-binaries\bin

@rem Include Docker
@set PATH=%PATH%;C:\Program Files\Docker\Docker\resources\bin
@set PATH=%PATH%;C:\ProgramData\DockerDesktop\version-bin

@rem Set ORACLE_HOME, this is to override the value in registry HKEY_LOCAL_MACHINE\SOFTWARE\ORACLE\ORACLE_HOME to allow Oracle Instant Client to work properly
@set "ORACLE_HOME= "
@rem Set NLS_LANG, this is to override the value in registry HKEY_LOCAL_MACHINE\SOFTWARE\ORACLE\NLS_LANG to allow Oracle Instant Client to work properly
@set "NLS_LANG= "
@rem Include Oracle Instant Client
@set PATH=%PATH%;C:\Programs\oracle\instantclient\instantclient-basiclite-windows.x64-12.1.0.2.0\instantclient_12_1
```
