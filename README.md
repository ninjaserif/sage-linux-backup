# sage-linux-backup
Linux file backup (tar) with logging and cleanup of old backups.  I created this to backup my Ubuntu and Raspberry Pi machines to a remote NAS.

# Features
* full tar backup to remote mount location
* exclude folders
* cleanup backups on remote destination
* email upon success / failure

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
* mount / external destination

# Setup
* download release
* cp config-sample.sh config.sh # this is preferred over renaming to avoid wiping if updating to new release
* edit config.sh and set your configuration
* cp exclude-sample.list exclude.list # this is preferred over renaming to avoid wiping if updating to new release
* update exclude.list # as required, but I've set with the most common excludes
* confirm scripts have execute permissions
+ sage-linux=backup.sh should be executable
+ config.sh should be executable
+ exclude.list should be readable
* add the following entries to cron # set timing as desired

# Change log
* 1.0 04-05-2017
+ first release
* 1.1 15-10-2018
+ check mount and email if mount fails
* 1.2 19-11-2018
+ update DESDIR with HOST instead of hard coded hostname
+ add cleanup post re-mount + make hostname a variable
* 1.3 22-11-2018
+ updated email to include some log output
* 1.4 22-01-2019
+ added directory output to email
* 1.0.0 26-07-2020
+ cleaned up for git - set to version 1.0.0
+ merged backup and cleanup into single script with functions
+ setup config such that only config that needs to be edited by user is in config.sh
 
# END
