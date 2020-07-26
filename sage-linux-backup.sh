#!/bin/bash

# sage-linux-backup

#START

if [ -f "config.sh" ]; then
  . config.sh
else
  echo "config.sh missing - copy config-sample.sh and update with your own config"
  exit 1
fi

if [ ! -f "exclude.list" ]; then
  echo "exclude.list missing - copy exclude-sample.list and update with your own exclude.list"
  exit 1
fi

##### Load config
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
HOST=`hostname`                        # get hostname
DATE=`date +%Y%m%d`                    # get date
SDATETIME=`date "+%Y-%m-%d %H:%M:%S"`  # get date and time
FILENAME=$HOST-backup-$DATE.tar.gz     # set tar.gz filename
LOGFILENAME=$HOST-backup-$DATE.log     # set log filename
EXCLIST=$SCRIPTDIR/exclude.list        # exclude list
DESDIR=$DESMNT/$HOST                   # set destination directory
SLBVER="~~ sage-linux-backup version 1.5 July 2020 ~~"

##### Functions

backup()
{
  if grep -qs "$DESMNT" /proc/mounts; then
    # DESMNT mounted - proceed with backup
    LOGVAR+=$(echo -e "Backup started at $SDATETIME" | tee -a $DESDIR/$LOGFILENAME)'\n'
    LOGVAR+=$(echo -e "Backup $HOST $SRCDIR to $DESDIR" | tee -a $DESDIR/$LOGFILENAME)'\n'
    # run backup
    tar -cpzvf $DESDIR/$FILENAME --directory=$SRCDIR --exclude-from $EXCLIST . &>> $DESDIR/$LOGFILENAME
    EDATETIME=`date "+%Y-%m-%d %H:%M:%S"`             # get date and time
    DURATION=`dateutils.ddiff -f "%H hours and %M minutes and %S seconds" "$SDATETIME" "$EDATETIME"`
    DESDIRLS=`find $DESDIR/* -maxdepth 1 -printf '%CY-%Cm-%Cd - %f  \t- %s\n' | numfmt --to=iec --suffix=B --field 5 --format='%3.3f' | sed 's/.000//'`
    LOGVAR+=$(echo -e "Backup complete at $EDATETIME" | tee -a $DESDIR/$LOGFILENAME)'\n'
    LOGVAR+=$(echo -e "Backup duration: $DURATION" | tee -a $DESDIR/$LOGFILENAME)'\n'
    LOGVAR+=$(echo -e "$HOST backup completed successfully" | tee -a $DESDIR/$LOGFILENAME)'\n'
    BACKUPSIZE=$(stat -c '%s' $DESDIR/$FILENAME | numfmt --to=iec --suffix=B --format='%3.3f')
    LOGVAR+=$(echo -e "Backup size: $BACKUPSIZE")'\n\n'
    LOGVAR+=$(echo -e "$DESDIR contents:")'\n'
    LOGVAR+=$(echo -e "$DESDIRLS")'\n\n'
    LOGVAR+=$(echo -e "$SLBVER")'\n'
    echo -e "$LOGVAR" | mail -s "$HOST Backup success - $DATE" $EMAIL
  else
    # DESMNT not mounted - send email
    LOGVAR=$(echo -e "$DESMNT not mounted on $HOST")'\n\n'
    LOGVAR+=$(echo -e "$SLBVER")'\n'
    echo -e "$LOGVAR" | mail -s "$HOST Backup failed - $DATE" $EMAIL
  fi

} # end of backup

cleanup()
{
  DESDIR=DESDIR/*

  if grep -qs "$DESMNT" /proc/mounts; then
    # DESMNT mounted - proceed with backup cleanup
    find $DESDIR -mtime +$NDAYS -type f -delete
  else
    mount "$DESMNT"
    if [ $? -eq 0 ]; then
      # DESMNT was mounted successfully
      find $DESDIR -mtime +$NDAYS -type f -delete
    else
      # DESMNT not mounted - send email
      LOGVAR=$(echo -e "$DESMNT not mounted on $HOST")'\n\n'
      LOGVAR+=$(echo -e "$SLBVER")'\n'
      echo -e "$LOGVAR" | mail -s "$HOST Backup cleanup failed - $SDATETIME" $EMAIL
    fi
  fi

} # end of cleanup

usage()
{
  echo "usage: sage-linux-backup.sh [[[-b backup ] | [-c cleanup] | [-h]]"
}

##### Main

while [ "$1" != "" ]; do
    case $1 in
        -b | --backup )         backup
                                exit
                                ;;
        -c | --cleanup )        cleanup
                                exit
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

#END
