# Talip Hakan Ozturk - 2016
# Declare your environment variables
export ORACLE_SID=$1
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/db_1
export PATH=PATH=$PATH:$ORACLE_HOME/bin

# Specify Directories
TMPDIR=/u01/app/oracle/admin/scripts/logs/

# Specify variables
BCK_EMAIL='it.iodb.tr@vodafone.com'
logtokeep=50

export NLS_LANG=AMERICAN
export NLS_DATE_FORMAT='DD-MON-YYYY HH24:MI:SS'
TIMESTAMP=`date '+%d-%m-%Y_%H-%M-%S'`

BCK_LOG=${TMPDIR}/${ORACLE_SID}_Archive_Deletion_${TIMESTAMP}.bcklog
TMPLOG=${TMPDIR}/ARCHIVEtmplog.$$

echo `date` "Starting ${ORACLE_SID} Archive Deletion " > ${BCK_LOG}
echo  "DatabaseName :" $ORACLE_SID >> ${BCK_LOG}
echo  "Server Name :`hostname`" >>${BCK_LOG}
echo  "Archive Deletion Start Date :" ${TIMESTAMP}  >>${BCK_LOG}
echo  "Archive Deletion Temp Log File :" $TMPLOG >>${BCK_LOG}
echo  "Archive Deletion Log File :" $BCK_LOG >>${BCK_LOG}
echo  "Archive Deletion Log File Content :" >>${BCK_LOG}

AppliedLogNoThread1=`sqlplus -silent /nolog  <<EOSQL
connect / as sysdba
whenever sqlerror exit sql.sqlcode
set pagesize 0 feedback off verify off heading off echo off
select max(sequence#) from v\\$archived_log where applied = 'YES' and REGISTRAR='RFS' and thread#=1;
exit;
EOSQL`


ArchToDelThread1=$(($AppliedLogNoThread1-$logtokeep))

echo "Oracle Last Applied Thread1 LogNo is $AppliedLogNoThread1" >>${BCK_LOG}

StartTime=$(date +%S)

$ORACLE_HOME/bin/rman  <<EOF>> ${TMPLOG}
connect target ;
CONFIGURE DEVICE TYPE DISK PARALLELISM 2 BACKUP TYPE TO BACKUPSET;
delete noprompt archivelog until sequence = $ArchToDelThread1 thread=1;
crosscheck archivelog all;
delete noprompt expired archivelog all;
exit
EOF

    RESULT=$?
    cat $TMPLOG >> ${BCK_LOG}

   EndTime=$(date +%S)
   DiffTime=$(( $EndTime - $StartTime ))

    echo "${ORACLE_SID} Archive Deletion End Date :" `date` >>${BCK_LOG}
    echo "Archive Deletion Duration :"  $DiffTime >> ${BCK_LOG}

    if [ $RESULT -ne "0" ]; then
        mailx -s "FAILED DR Archive Deletion of Database ${ORACLE_SID}" ${BCK_EMAIL} < ${BCK_LOG}
    else
        rm $TMPLOG >> ${BCK_LOG}
		find ${BCK_LOG} -name "*.bcklog" -mtime +15 -exec \rm {} \;
        mailx -s "SUCCESSFUL DR Archive Deletion of DB ${ORACLE_SID} until sequence thread1 $ArchToDelThread1" ${BCK_EMAIL} < ${BCK_LOG}
    fi
