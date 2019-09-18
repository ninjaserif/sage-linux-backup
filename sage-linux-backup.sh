#!/bin/bash

# sage-linux-backup

#START
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
HOST=`hostname`                                     # get hostname
DATE=`date +%Y%m%d`                                 # get date
SDATETIME=`date "+%Y-%m-%d %H:%M:%S"`               # get date and time
FILENAME=$HOST-backup-$DATE.tar.gz                  # set tar.gz filename
LOGFILENAME=$HOST-backup-$DATE.log                  # set log filename
EXCLIST=$SCRIPTDIR/sage-linux-backup-exclude.list   # exclude list
SRCDIR=/                                            # set source directory
DESMNT=MOUNT FROM CONFIG                            # mount point
DESDIR=$DESMNT/$HOST                                # set destination directory
EMAIL=EMAIL FROM CONFIG                             # set email to alert

if grep -qs "$MOUNT" /proc/mounts; then
  # MOUNT mounted - proceed with backup
  LOGVAR+=$(echo -e "Backup started at $SDATETIME" | tee -a $DESDIR/$LOGFILENAME)'\n'
  LOGVAR+=$(echo -e "Backup $HOST $SRCDIR to $DESDIR" | tee -a $DESDIR/$LOGFILENAME)'\n'
  # run backup
  tar -cpzvf $DESDIR/$FILENAME --directory=$SRCDIR --exclude-from $EXCLIST . &>> $DESDIR/$LOGFILENAME
  EDATETIME=`date "+%Y-%m-%d %H:%M:%S"`             # get date and time
  DURATION=`datediff -f "%H hours and %M minutes and %S seconds" "$SDATETIME" "$EDATETIME"`
  DESDIRLS=`find $DESDIR/* -maxdepth 1 -printf '%CY-%Cm-%Cd - %f  \t- %s\n' | numfmt --to=iec --suffix=B --field 5 --format='%3.3f' | sed 's/.000//'`
  LOGVAR+=$(echo -e "Backup complete at $EDATETIME" | tee -a $DESDIR/$LOGFILENAME)'\n'
  LOGVAR+=$(echo -e "Backup duration: $DURATION" | tee -a $DESDIR/$LOGFILENAME)'\n'
  LOGVAR+=$(echo -e "$HOST backup completed successfully" | tee -a $DESDIR/$LOGFILENAME)'\n'
  BACKUPSIZE=$(stat -c '%s' $DESDIR/$FILENAME | numfmt --to=iec --suffix=B --format='%3.3f')
  LOGVAR+=$(echo -e "Backup size: $BACKUPSIZE")'\n\n'
  LOGVAR+=$(echo -e "$DESDIR contents:")'\n'
  LOGVAR+=$(echo -e "$DESDIRLS")'\n'
  echo -e "$LOGVAR" | mail -s "$HOST Backup success - $DATE" $EMAIL
else
  # MOUNT not mounted - send email
  echo "$MOUNT not mounted on $HOST" | mail -s "$HOST Backup failed - $DATE" $EMAIL
fi

#END