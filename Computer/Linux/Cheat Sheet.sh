# List all crontab for all users
for user in $(cut -f1 -d: /etc/passwd); do echo -----$user-----; crontab -u $user -l; done

# List all users password aging information
for user in $(cut -f1 -d: /etc/passwd); do echo -----$user-----; chage -l $user; done

# Extract all IP address
egrep -o '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}' file.txt

# Recursively find and replace
find ./* -type f -exec sed -i 's/stringToReplace/Replacement/g' {} \;

# Find the start time and elapsed time of a process
ps -eo pid,stime,etime,cmd | grep httpd

# Output unique line from a text file and output to stdout
sort -u somefile

# Capture network dump
tcpdump -i ``any'' -s 0 -w tcpdump.pcap

# Change the maximum number of days between password change to 180 days and number of days of warning before password expires to 30 days
chage -M 180 -W 30 username

# To disable or lock a user account by setting the account expiry date
chage --expiredate 0 username

# To enable or unlock a user account
chage --expiredate -1 username

# Backup iptables
sudo /sbin/iptables-save > iptables.cfg

# Restore iptables
sudo /sbin/iptables-restore < iptables.cfg

# Copy files to another host
scp file_to_copy username@hostname:/dest_path

# Detect if we are running in a virtual machine
virt-what

# List hardware info
dmidecode | less

# Find power supply max power capacity
dmidecode | grep -i capacity

# Find number of physical CPU socket
cat /proc/cpuinfo | grep "^physical id" | sort | uniq | wc -l

# Find the number of cores per CPU
cat /proc/cpuinfo | grep "^cpu cores" | uniq

# Find the total number of logical processor
cat /proc/cpuinfo | grep "^processor" | wc -l

# Find RAID mode for some HP RAID card
cat /proc/driver/cciss/cciss*

# Find disk size
fdisk -l | grep Disk | grep /dev/sd

# Display user last login
last username

# List all users in a group
lid -g groupname

# List failure login count (depends on which module is used)
pam_tally2
faillock

# Set consecutive failure login count for user to zero (depends on which module is used)
pam_tally2 --user=username --reset
faillock --user username --reset

# Locate .rpmnew .rpmsave files
locate -e --regex "\.rpm(new|save)$"

# Add system account (Example)
useradd --system --no-create-home --home-dir /usr/local/bin/myapp --shell /sbin/nologin -G apps --comment "Application account for myapp" myapp

# Regenerate SSH host key at /etc/ssh
ssh-keygen -t dsa -f ssh_host_dsa_key
ssh-keygen -t ecdsa -f ssh_host_ecdsa_key
ssh-keygen -t ed25519 -f ssh_host_ed25519_key
ssh-keygen -t rsa1 -f ssh_host_key
ssh-keygen -t rsa -f ssh_host_rsa_key

# Perform yum update without MySQL repo and timeout
yum --disablerepo=mysql-connectors-community --disablerepo=mysql-tools-community --disablerepo=mysql56-community --setopt=timeout=0 update
