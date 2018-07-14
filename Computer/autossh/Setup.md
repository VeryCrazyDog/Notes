Optionally add a system user `autossh` to run *autossh*. If privileged port is required, *autossh* will need to run under `root` account.
```sh
useradd -r -m -s /bin/false autossh
```

Login to the account which run *autossh*
```sh
# Login as autossh
su -s /bin/bash autossh

# Login as root using sudo
sudo -i
```

Generate SSH key pair if it is not generated
```sh
ssh-keygen
```

Copy SSH public key to remote host
```sh
ssh-copy-id username@hostname
```

Create SSH client configuration file at `~/.ssh/config` with the following content
```conf
Host <ssh_config_host>
	HostName <host>
	User <username>
	ServerAliveCountMax 3
	ServerAliveInterval 60
	LocalForward <local_ip>:<local_port> <remote_ip>:<remote_port>
```
for example
```conf
Host my_ssh_host
	HostName example.com
	User my_name
	ServerAliveCountMax 3
	ServerAliveInterval 60
	LocalForward 0.0.0.0:8080 127.0.0.1:80
```

Logout from the account which run *autossh*
```sh
exit
```

Manually run *autossh* using command
```sh
# Run as user autossh
/bin/su -s /bin/sh autossh -c '/usr/bin/autossh -M 0 -f -qNT <ssh_config_host>'

# Run as root user using sudo
sudo /usr/bin/autossh -M 0 -f -qNT <ssh_config_host>
```

Set up *autossh* to run automatically on reboot using `root` user *crontab*. `root` user is needed because `@reboot` syntax may not work for normal user. First, open the *crontab* configuration
```sh
sudo crontab -e
```
then include one of the following configuration line
```conf
# Run autossh as user autossh
@reboot /bin/su -s /bin/sh autossh -c '/usr/bin/autossh -M 0 -f -qNT <ssh_config_host>'

# Run autossh as root user
@reboot /usr/bin/autossh -M 0 -f -qNT <ssh_config_host>
```
