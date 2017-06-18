# Raspbian Setup Guide

## Configure static IP
This step is valid as of 2017-06-18

Open the file to edit
```sh
sudo vim /etc/dhcpcd.conf
```

Append the following content at the bottom of the file, below `nohook lookup-hostname`
```
interface eth0
static ip_address=192.168.1.141/24
static routers=192.168.1.1
static domain_name_servers=192.168.1.1 8.8.8.8
```
