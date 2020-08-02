# sage-linux-backup

Linux file backup (tar) with logging and cleanup of old backups.  I created this to backup my Ubuntu and Raspberry Pi machines to a remote NAS.

## Features

* full tar backup to remote mount location `# backup location is <remote_mount>\$HOSTNAME`
* output log to remote mount location - including list of all files which were backed up
* exclude list of folders
* cleanup backups on remote destination
* email upon success / failure
* tested / works on various releases of Rasbian as well as Ubuntu

## Prerequisite

Install:

* ssmtp (apt-get install ssmtp)
* mailutils (apt-get install mailutils)
* dateutils (apt-get install dateutils)

Configure:

* /etc/ssmtp/ssmtp.conf
  * check out <https://www.cyberciti.biz/tips/linux-use-gmail-as-a-smarthost.html> as a guide
* /etc/ssmtp/revaliases
  * i.e. `<user>:<ssmpt email address>:<ssmpt IP>:<ssmtp port>`
* /etc/fstab
  * setup automatic mount of external location as required

## Setup

* download latest release - <https://github.com/ninjaserif/sage-linux-backup/releases/latest/>

Below is a "one-liner" to download the latest release

```bash
LOCATION=$(curl -s https://api.github.com/repos/ninjaserif/sage-linux-backup/releases/latest \
| grep "tag_name" \
| awk '{print "https://github.com/ninjaserif/sage-linux-backup/archive/" substr($2, 2, length($2)-3) ".tar.gz"}') \
; curl -L -o sage-linux-backup_latest.tar.gz $LOCATION
```

* extract release

```bash
sudo mkdir /usr/local/bin/sage-linux-backup && sudo tar -xvzf sage-linux-backup_latest.tar.gz --strip=1 -C /usr/local/bin/sage-linux-backup
```

* navigate to where you extracted sage-linux-backup - i.e. `cd /usr/local/bin/sage-linux-backup/`
* create your own config file `# this is preferred over renaming to avoid wiping if updating to new release`

```bash
cp config-sample.sh config.sh
```

* edit config.sh and set your configuration

```bash
SRCDIR=/                               # source directory
DESMNT=<remote_mount>                  # mount point
EMAIL=<email_address>                  # email address to alert
NDAYS=30                               # number of days to keep backups for
```

* create an exclude.list `# this is preferred over renaming to avoid wiping if updating to new release`

```bash
cp exclude-sample.list exclude.list
```

* (optional) update exclude.list to include any additional directories
* confirm scripts have execute permissions
  * sage-linux-backup.sh should be executable
  * config.sh should be executable
  * exclude.list should be readable
* add the following entries to cron `# set timing as desired - examples below are backup at 4am on Sunday and cleanup at 6am on Sunday`

```bash
0 4 * * SUN /usr/local/bin/sage-linux-backup/sage-linux-backup.sh -b >/dev/null 2>&1
0 6 * * SUN /usr/local/bin/sage-linux-backup/sage-linux-backup.sh -c >/dev/null 2>&1
```

## Change log

* 1.0 04-05-2017
  * first release
* 1.1 15-10-2018
  * check mount and email if mount fails
* 1.2 19-11-2018
  * update DESDIR with HOST instead of hard coded hostname
  * add cleanup post re-mount + make hostname a variable
* 1.3 22-11-2018
  * updated email to include some log output
* 1.4 22-01-2019
  * added directory output to email
* 1.0.0 27-07-2020
  * cleaned up for git - set to version 1.0.0
  * merged backup and cleanup into single script with functions
  * setup config such that only config that needs to be edited by user is in config.sh
* 1.0.1 02-08-2020
  * fix running from another directory / cron by changing directory to script_directory
  * remove test variables

## -END-
