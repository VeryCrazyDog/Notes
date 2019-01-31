For Windows 7
```bat
@rem Reset to Windows 7 default environment variables
@set Path=%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\
@set PSModulePath=%SystemRoot%\system32\WindowsPowerShell\v1.0\Modules
@set CLASSPATH=

@rem Include custom batch files
@set PATH=%PATH%;E:\Programs\Script\cmd_bat

@rem Include Notepad2
@set PATH=%PATH%;C:\Programs\Notepad2

@rem Include Git
@set PATH=%PATH%;E:\Programs\PortableGit\bin

@rem Include Python
@set PATH=%PATH%;E:\Programs\Python\python-3.5.2-amd64;E:\Programs\Python\python-3.5.2-amd64\Scripts;%APPDATA%\Python\Python35\Scripts
@rem Include Node.js
@set PATH=%PATH%;E:\Programs\Node.js\node-v8.12.0-win-x64
@rem Include PHP
@set PATH=%PATH%;E:\Programs\PHP\php-7.2.3-Win32-VC15-x64

@rem Set JAVA_HOME
@set JAVA_HOME=E:\Programs\JDK\jdk1.8.0_102
@rem Include Java
@set PATH=%PATH%;%JAVA_HOME%\bin
@rem Include Android tools
@set PATH=%PATH%;E:\Programs\Android\SDK\platform-tools

@rem Set ORACLE_HOME, this is to override the value in registry HKEY_LOCAL_MACHINE\SOFTWARE\ORACLE\ORACLE_HOME to allow Oracle Instant Client to work properly
@set "ORACLE_HOME= "
@rem Set NLS_LANG, this is to override the value in registry HKEY_LOCAL_MACHINE\SOFTWARE\ORACLE\NLS_LANG to allow Oracle Instant Client to work properly
@set "NLS_LANG= "
@rem Include Oracle Instant Client
@set PATH=%PATH%;C:\Programs\oracle\instantclient\instantclient-basiclite-windows.x64-12.1.0.2.0\instantclient_12_1

@rem Include MySQL
@set PATH=%PATH%;C:\Programs\mysql\mysql-5.6.34-winx64\bin
@rem Include MySQL Utilities
@set PATH=%PATH%;C:\Program Files\MySQL\MySQL Utilities 1.6
@rem Include PostgreSQL
@set PATH=%PATH%;C:\Programs\postgresql\postgresql-10.4-1-windows-x64-binaries\bin

@rem Include VirtualBox
@set PATH=%PATH%;C:\Program Files\Oracle\VirtualBox

@rem Include OptiPNG
@set PATH=%PATH%;E:\Programs\optipng
```
