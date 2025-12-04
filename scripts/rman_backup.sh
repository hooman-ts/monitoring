. ~/.bash_profile

# Specify Directories
ORACLE_HOME=/oracle/ora11g
ORACLE_SID=CRM
BCK_LOCATION=/backup_CRM
PFILE=${ORACLE_HOME}/dbs/init${ORACLE_SID}.ora
TMPDIR=/tmp

# Specify RMAN Catalog User Information
CATALOG_USER=rman
CATALOG_USER_PASSWORD=a1S4y5a3x
CATALOG_TNS_ALIAS=rmancat

# Specify Backup Type & Media
BCK_MEDIA=DISK
BCK_TYPE=level1
BCK_PARALLELISM=2
BCK_EMAIL='dba@shaparak.com'
BCK_RETENTION=7

export NLS_LANG=AMERICAN
export NLS_DATE_FORMAT='DD-MON-YYYY HH24:MI:SS'
TIMESTAMP=`date '+%d-%m-%Y_%H-%M-%S'`

BCK_LOG=${BCK_LOCATION}/${ORACLE_SID}_${BCK_TYPE}_${BCK_MEDIA}_${TIMESTAMP}.bcklog
TMPLOG=${TMPDIR}/RMANtmplog.$$
LEGATO_TAPEBACKUP=${BCK_LOCATION}/tapebackup.ready
BCK_LOCKFILE=${TMPDIR}/rman.${ORACLE_SID}.lock

echo `date` "Starting $BCK_TYPE Backup of $ORACLE_SID to $BCK_MEDIA" > ${BCK_LOG}
echo  "DatabaseName :" $ORACLE_SID >> ${BCK_LOG}
echo  "Server Name :$HOSTNAME" >>${BCK_LOG}
echo  "RMAN Backup Start Date :" ${TIMESTAMP}  >>${BCK_LOG}
echo  "RMAN Temp Log File :" $TMPLOG >>${BCK_LOG}
echo  "RMAN Log File :" $BCK_LOG >>${BCK_LOG}
echo  "RMAN Log File Content :" >>${BCK_LOG}

StartTime=$(date +%s)

if [ -f $BCK_LOCKFILE ]; then
    echo `date` "Lock file already exists. May be previous RMAN backup is still running. Check backup job!" >> ${BCK_LOG}
    mail -s "Previous RMAN ${BCK_TYPE} Backup of Database ${ORACLE_SID} is still running. Check backup job!" ${BCK_EMAIL} < ${BCK_LOG}
else
rm $LEGATO_TAPEBACKUP  >> ${BCK_LOG}
echo "Don't remove this file! It needed for RMAN backup job tracking." > $BCK_LOCKFILE
    $ORACLE_HOME/bin/rman log=$TMPLOG << EOF
        connect target /
        connect catalog ${CATALOG_USER}/${CATALOG_USER_PASSWORD}@${CATALOG_TNS_ALIAS}
        CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF ${BCK_RETENTION} DAYS;
        CONFIGURE CONTROLFILE AUTOBACKUP ON;
        CONFIGURE DEFAULT DEVICE TYPE TO ${BCK_MEDIA};
        CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE ${BCK_MEDIA} TO '${BCK_LOCATION}/cf_sp_file_%F';
        CONFIGURE CHANNEL DEVICE TYPE ${BCK_MEDIA} FORMAT '${BCK_LOCATION}/%U.bck';
        CONFIGURE DEVICE TYPE ${BCK_MEDIA} PARALLELISM ${BCK_PARALLELISM} BACKUP TYPE TO BACKUPSET;
    run
        {
                crosscheck copy of database ;
                crosscheck backup of database ;
                crosscheck backup of controlfile ;
                crosscheck archivelog all ;
				crosscheck backup of archivelog all;
                delete noprompt expired copy of database ;
                delete noprompt expired backup of database ;
                delete noprompt expired backup of controlfile ;
                delete noprompt expired archivelog all ;
				delete noprompt expired backup of archivelog all;
                recover copy of database with tag = 'incremental_update' until time 'SYSDATE-7' ;
				backup incremental level 1 for recover of copy with tag = 'incremental_update' database ;
                sql "ALTER SYSTEM SWITCH LOGFILE" ;
                backup archivelog all not backed up 1 times filesperset 8 format '${BCK_LOCATION}/%d_%s_%p_%U_ARCH' ;
                backup as copy current controlfile ;
                restore database preview ;
                delete noprompt obsolete ;
        }
    exit
EOF
    RESULT=$?
	cat $TMPLOG >> ${BCK_LOG}
    
	echo `date` "Starting ${PFILE} pfile backup" >> ${BCK_LOG}
    cp ${PFILE} ${BCK_LOCATION}/init${ORACLE_SID}_${TIMESTAMP}.ora >> ${BCK_LOG}
    echo `date` "Finished ${PFILE} pfile backup" >> ${BCK_LOG}

    EndTime=$(date +%s)
    DiffTime=$(( $EndTime - $StartTime ))

    echo "RMAN Backup End Date :" `date` >>${BCK_LOG}
    echo "RMAN Backup Duration :"  $DiffTime >> ${BCK_LOG}
	echo `date` "Don't remove this file! It needed for Bankasya LEGATO TAPE" > $LEGATO_TAPEBACKUP
	rm $BCK_LOCKFILE  >> ${BCK_LOG}
    echo `date` "Backup lock file is removed" >> ${BCK_LOG}

    if [ $RESULT -ne "0" ]; then
        mail -s "FAILED RMAN ${BCK_TYPE} Backup of Database ${ORACLE_SID}" ${BCK_EMAIL} < ${BCK_LOG}
    else
        find ${BCK_LOCATION} -name "*.bcklog" -mtime +${BCK_RETENTION} -exec \rm {} \;  >> ${BCK_LOG}
        find ${BCK_LOCATION} -name "*.ora" -mtime +${BCK_RETENTION} -exec \rm {} \;  >> ${BCK_LOG}
		rm $TMPLOG >> ${BCK_LOG}
        mail -s "SUCCESSFUL RMAN ${BCK_TYPE} Backup of Database ${ORACLE_SID}" ${BCK_EMAIL} < ${BCK_LOG}
    fi
fi