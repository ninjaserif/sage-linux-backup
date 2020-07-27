# sage-linux-backup
Linux file backup (tar) with logging and cleanup of old backups.  I created this to backup my Ubuntu and Raspberry Pi machines to a remote NAS.


## Features
* full tar backup to remote mount location
* output log to remote mount location - including list of all files backed up
* exclude list of folders
* cleanup backups on remote destination
* email upon success / failure
* works on various releases of Rasbian as well as Ubuntu


## Prerequisite
Install:
* ssmtp (apt-get install ssmtp)
* mailutils (apt-get install mailutils)
* dateutils (apt-get install dateutils)

Configure:
* /etc/ssmtp/ssmtp.conf
  - check out https://www.cyberciti.biz/tips/linux-use-gmail-as-a-smarthost.html as a guide
* /etc/ssmtp/revaliases
  - i.e. `<user>:<ssmpt email address>:<ssmpt IP>:<ssmtp port>`
* /etc/fstab
  - setup automatic mount of external location as required


## Setup
* download latest release.  Below is a "oneliner" to download the latest release - https://github.com/ninjaserif/sage-linux-backup/releases/latest/
```
LOCATION=$(curl -s https://api.github.com/repos/ninjaserif/sage-linux-backup/releases/latest \
| grep "tag_name" \
| awk '{print "https://github.com/ninjaserif/sage-linux-backup/archive/" substr($2, 2, length($2)-3) ".tar.gz"}') \
; curl -L -o sage-linux-backup_latest.tar.gz $LOCATION
```
* extract release
```
sudo mkdir /usr/local/bin/sage-linux-backup && sudo tar -xvzf sage-linux-backup_latest.tar.gz --strip=1 -C /usr/local/bin/sage-linux-backup
```
* navigate to where you extracted sage-linux-backup - i.e. `cd /usr/local/bin/sage-linux-backup/`
* create your own config file ### this is preferred over renaming to avoid wiping if updating to new release
```
cp config-sample.sh config.sh
```
* edit config.sh and set your configuration
```
SRCDIR=/                # likely rename unchanged
DESMNT=<remote mount>   # something like /mnt/<SERVER>/<SERVER SHARE>
EMAIL=<email_address>   # email address to send emails
NDAYS=30                # number of backups to keep
```
* create an exclude.list ### this is preferred over renaming to avoid wiping if updating to new release
```
cp exclude-sample.list exclude.list
```
* (optional) update exclude.list to include any additional directories
* confirm scripts have execute permissions
  - sage-linux=backup.sh should be executable
  - config.sh should be executable
  - exclude.list should be readable
* add the following entries to cron # set timing as desired - examples below are backup at 4am on Sunday and cleanup at 6am on Sunday
```
0 4 * * SUN /usr/local/bin/sage-linux-backup/sage-linux-backup.sh -b >/dev/null 2>&1
0 6 * * SUN /usr/local/bin/sage-linux-backup/sage-linux-backup.sh -c >/dev/null 2>&1
```


## Change log
* 1.0 04-05-2017
  - first release
* 1.1 15-10-2018
  - check mount and email if mount fails
* 1.2 19-11-2018
  - update DESDIR with HOST instead of hard coded hostname
  - add cleanup post re-mount + make hostname a variable
* 1.3 22-11-2018
  - updated email to include some log output
* 1.4 22-01-2019
  - added directory output to email
* 1.0.0 26-07-2020
  - cleaned up for git - set to version 1.0.0
  - merged backup and cleanup into single script with functions
  - setup config such that only config that needs to be edited by user is in config.sh
 
# END
