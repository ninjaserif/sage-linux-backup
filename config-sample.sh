# CONFIG
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
HOST=`hostname`                        # get hostname
DATE=`date +%Y%m%d`                    # get date
SDATETIME=`date "+%Y-%m-%d %H:%M:%S"`  # get date and time
FILENAME=$HOST-backup-$DATE.tar.gz     # set tar.gz filename
LOGFILENAME=$HOST-backup-$DATE.log     # set log filename
EXCLIST=$SCRIPTDIR/exclude.list        # exclude list
SRCDIR=/                               # set source directory
DESMNT=<remote mount>                  # mount point
DESDIR=$DESMNT/$HOST                   # set destination directory
EMAIL=<email_address>                  # set email to alert
NDAYS=30                               # number of days to keep backups for
