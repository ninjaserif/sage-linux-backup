#!/bin/bash

# sage-linux-backup cleanup script

#START
NDAYS=30                              # number of days
HOST=`hostname`                       # get hostname
MOUNT=MOUNT FROM CONFIG               # mount point
DESDIR=DESDIR/*                       # destination directory
DATETIME=`date "+%Y-%m-%d %H:%M:%S"`  # get date and time

if grep -qs "$MOUNT" /proc/mounts; then
  # MOUNT mounted - proceed with backup cleanup
  find $DESDIR -mtime +$NDAYS -type f -delete
else
  mount "$MOUNT"
  if [ $? -eq 0 ]; then
    # MOUNT was mounted successfully
    find $DESDIR -mtime +$NDAYS -type f -delete
  else
    # MOUNT not mounted - send email
    echo "$MOUNT not mounted on $HOST" | mail -s "$HOST Backup cleanup failed - $DATETIME" $EMAIL
  fi
fi

#END
