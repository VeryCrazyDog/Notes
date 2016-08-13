#-------------------------------------------------------------------------------
# Basic installation
# Reference: https://about.gitlab.com/downloads/#centos7
#-------------------------------------------------------------------------------
# Install and configure the necessary dependencies
yum install curl policycoreutils openssh-server openssh-clients
systemctl enable sshd
systemctl start sshd
yum install postfix
systemctl enable postfix
systemctl start postfix

# Add the GitLab package server and install the package
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | bash
yum install gitlab-ce

# Configure and start GitLab
gitlab-ctl reconfigure

# (If appropriate) Configure firewall
firewall-cmd --permanent --add-service=http
systemctl reload firewalld

#-------------------------------------------------------------------------------
# Enable HTTPS
# Reference: http://doc.gitlab.com/omnibus/settings/nginx.html#enable-https
#-------------------------------------------------------------------------------
mkdir /etc/gitlab/ssl
chmod 700 /etc/gitlab/ssl
# The filename has to be the same as the domain in external_url
cp gitlab.example.com.key gitlab.example.com.crt /etc/gitlab/ssl/
mkbak /etc/gitlab/gitlab.rb
vim /etc/gitlab/gitlab.rb
	external_url "https://gitlab.example.com"
gitlab-ctl reconfigure

#-------------------------------------------------------------------------------
# Configure SMTP
# Reference: http://doc.gitlab.com/omnibus/settings/smtp.html
#-------------------------------------------------------------------------------
mkbak /etc/gitlab/gitlab.rb
vim /etc/gitlab/gitlab.rb
	gitlab_rails['gitlab_email_from'] = 'example@example.com'
	gitlab_rails['gitlab_email_reply_to'] = 'noreply@example.com'
	gitlab_rails['smtp_enable'] = true
	gitlab_rails['smtp_address'] = "smtp.server"
	gitlab_rails['smtp_port'] = 25
	gitlab_rails['smtp_domain'] = "example.com"
	gitlab_rails['smtp_authentication'] = false
	gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab-ctl reconfigure

#-------------------------------------------------------------------------------
# Access GitLab
#-------------------------------------------------------------------------------

# Browse to the website
# Set the root account password
# Login with root account

#-------------------------------------------------------------------------------
# Configure to keep backup for alternative period
#-------------------------------------------------------------------------------
mkbak /etc/gitlab/gitlab.rb
vim /etc/gitlab/gitlab.rb
	# By default the backup is kept for 7 days, 604800 seconds
	gitlab_rails['backup_keep_time'] = 604800
gitlab-ctl reconfigure

#-------------------------------------------------------------------------------
# Configure cron to make daily application backups
#-------------------------------------------------------------------------------
crontab -u root -e
	# Backup at 2am each day
	0 2 * * * /opt/gitlab/bin/gitlab-rake gitlab:backup:create CRON=1
