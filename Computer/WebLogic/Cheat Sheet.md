Obtain thread dump using WebLogic scripting tool on Linux platform

```sh
# Setup CLASSPATH
export CLASSPATH=$weblogic_home/server/lib/weblogic.jar
# Start WebLogic scripting tool
java weblogic.WLST
```

```py
# In WebLogic scripting tool interactive mode
connect("username","password","t3://weblogic_host:weblogic_port")
threadDump()
exit()
```

```sh
# Print out the saved thread dump file
cat $weblogic_home/user_projects/domains/base_domain/servers/$server_name/logs/Thread_Dump_$server_name.txt
```
