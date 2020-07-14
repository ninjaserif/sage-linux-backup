# sage-linux-backup
Linux file backup (tar) with logging and cleanup of old backups

# Purpose

# Features

# Prerequisite
Install:
* ssmtp (apt-get install ssmtp)
* mailutils (apt-get install mailutils)
* dateutils (apt-get install dateutils)

Configure:
* /etc/ssmtp/ssmtp.conf
- check out https://www.cyberciti.biz/tips/linux-use-gmail-as-a-smarthost.html as a guide
* /etc/ssmtp/revaliases
- i.e. <user>:<ssmpt email address>:<ssmpt IP>:<ssmtp port>

# END