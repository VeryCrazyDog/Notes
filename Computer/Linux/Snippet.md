Minimal init.d script

```sh
#!/bin/bash

start() {
	echo 'Execute start!'
}

stop() {
	echo 'Execute stop!'
}

status() {
	echo 'Show status!'
}

restart() {
	stop
	sleep 1
	start
}

case "$1" in
	start)
		start
		;;
	stop)
		stop
		;;
	status)
		status
		;;
	restart)
		restart
		;;
	*)
		echo $"Usage: $0 {start|stop|status|restart}"
		exit 1
esac
exit $?
```
