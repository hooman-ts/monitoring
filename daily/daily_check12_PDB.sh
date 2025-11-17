. /home/oracle/.bash_profile

printf "\n"
echo -e "\e[39m \e[38;5;45m       Copyright 2019 by \e[38;5;220mSHAPARAK DBA Team \e[39m"
echo -e "\e[39m \e[38;5;45m Daily Check v1.1 Buid 85 for Container Databases \e[39m"

export TWO_TASK=
printf "\n"
echo -e "\e[39m \e[38;5;154m ***** List of your Database PDBs ***** \e[39m"
sqlplus -s / as sysdba << EOF
show pdbs
exit
EOF

printf "\n"

read -p 'Please Enter PDB Name: ' PDB

printf "\n"
echo -e "\e[39m \e[38;5;154m ***** OS FILE SYSTEM STATUS ***** \e[39m"
printf "\n"

df -h

printf "\n"
read -n 1 -s -r -p "Press any key to continue ... "
printf "\n\n\n"

# OS Memory Status
echo -e "\e[39m \e[38;5;154m ***** OS RAM STATUS in MB ***** \e[39m"
free -m

printf "\n"
read -n 1 -s -r -p "Press any key to continue ... "
printf "\n\n\n"


# Backup Status
echo -e "\e[39m \e[38;5;154m ***** LATEST BACKUP STATUS ***** \e[39m"
printf "\n"

sqlplus -s / as sysdba << EOF
SET LINE 120 FEEDBACK OFF
ALTER SESSION SET CONTAINER=$PDB;
Alter Session set nls_date_format = 'YYYY/MM/DD HH24:MI:SS';
SET FEEDBACK ON
col INPUT_BYTES_DISPLAY format a20
col OUTPUT_BYTES_DISPLAY format a20
SELECT STATUS, INPUT_TYPE, START_TIME, END_TIME, INPUT_BYTES_DISPLAY, OUTPUT_BYTES_DISPLAY 
FROM V\$RMAN_BACKUP_JOB_DETAILS 
WHERE START_TIME > SYSDATE -10
ORDER BY START_TIME DESC;
EXIT
EOF


printf "\n"
read -n 1 -s -r -p "Press any key to continue ... "
printf "\n\n\n\n"

# Database Block Corruption
echo -e "\e[39m \e[38;5;154m ***** DATABASE BLOCK CORRUPTION ***** \e[39m"
printf "\n"

sqlplus -s / as sysdba << EOF
SET LINE 120
ALTER SESSION SET CONTAINER=$PDB;
SELECT * FROM V\$DATABASE_BLOCK_CORRUPTION;
EXIT
EOF

printf "\n"
read -n 1 -s -r -p "Press any key to continue ... "
printf "\n\n\n\n"


# ASM Disk Groups 
echo -e "\e[39m \e[38;5;154m ***** ASM DISK GROUPS STATUS ***** \e[39m"
printf "\n"

sqlplus -s / as sysdba << EOF
SET LINE 120
ALTER SESSION SET CONTAINER=$PDB;
SELECT NAME, STATE, TYPE, TOTAL_MB/1024 TOTAL_GB, (TOTAL_MB-FREE_MB)/1024 USED_GB, FREE_MB/1024 FREE_GB, ROUND((1- (free_mb / total_mb))*100, 1) USED_PERCENT
FROM V\$ASM_DISKGROUP;
EXIT
EOF


printf "\n"
read -n 1 -s -r -p "Press any key to continue ... "
printf "\n\n\n\n"

# Tablespace Status
echo -e "\e[39m \e[38;5;154m ***** TABLESPACE Status ***** \e[39m"
printf "\n"

sqlplus -s / as sysdba << EOF
SET LINE 130
COL TBSNAME FORMAT A20 
ALTER SESSION SET CONTAINER=$PDB;
SELECT AA.TABLESPACE_NAME TBSNAME, ROUND(AA.TOTALSPACE_USED, 2) ALLOCATEDSPACE_GB, 
ROUND(AA.FREESPACE, 2) ALLOCATEDFREESPACE_GB, ROUND(AA.TOTALSPACE, 2) TOTALSPACE_GB,  
ROUND((AA.TOTALSPACE_USED - AA.FREESPACE), 2) USEDSPACE_GB,  
ROUND(AA.TOTALSPACE - (AA.TOTALSPACE_USED - AA.FREESPACE), 2) FREESPACE_GB, 
ROUND(100/(AA.TOTALSPACE_USED),2)* ROUND((AA.TOTALSPACE_USED - AA.FREESPACE), 1) "Allocated%Used",
ROUND((AA.TOTALSPACE_USED - AA.FREESPACE) / AA.TOTALSPACE * 100, 2) "USED%MAX"  
FROM ((SELECT DF.TABLESPACE_NAME TABLESPACE_NAME, DF.TOTALSPACE_USED TOTALSPACE_USED, 
TF.FREESPACE FREESPACE, DF.TOTALSPACE TOTALSPACE  
FROM(SELECT TABLESPACE_NAME, 
SUM(DECODE(AUTOEXTENSIBLE, 'YES', MAXBYTES, BYTES)) / (1024 * 1024 * 1024) TOTALSPACE, 
SUM(BYTES) / (1024 * 1024 * 1024) TOTALSPACE_USED  
FROM DBA_DATA_FILES  
GROUP BY TABLESPACE_NAME) DF, 
(SELECT TABLESPACE_NAME, 
SUM(BYTES) / (1024 * 1024 * 1024) FREESPACE  
FROM DBA_FREE_SPACE  
GROUP BY TABLESPACE_NAME) TF  
WHERE DF.TABLESPACE_NAME = TF.TABLESPACE_NAME)  
UNION ALL  
(SELECT DF.TABLESPACE_NAME TABLESPACE_NAME,  
DF.TOTALSPACE_USED TOTALSPACE_USED,  
(DF.TOTALSPACE_USED - TF.USEDSPACE) FREESPACE, 
DF.TOTALSPACE TOTALSPACE  
FROM(SELECT TABLESPACE_NAME,  
SUM(DECODE(AUTOEXTENSIBLE, 'YES', MAXBYTES, BYTES)) / (1024 * 1024 * 1024) TOTALSPACE,  
SUM(BYTES) / (1024 * 1024 * 1024) TOTALSPACE_USED  
FROM DBA_TEMP_FILES  
GROUP BY TABLESPACE_NAME) DF, 
(SELECT TABLESPACE_NAME, 
SUM(NVL(BYTES_USED, 0)) / (1024 * 1024 * 1024) USEDSPACE  
FROM SYS.GV_\$TEMP_EXTENT_POOL  
GROUP BY TABLESPACE_NAME) TF  
WHERE DF.TABLESPACE_NAME = TF.TABLESPACE_NAME)) AA ORDER BY 7 DESC;
EXIT
EOF

printf "\n"
read -n 1 -s -r -p "Press any key to continue ... "
printf "\n\n\n"


# FRA and Archivelogs Statuses
echo -e "\e[39m \e[38;5;154m ***** FRA and Archivelogs Statuses ***** \e[39m"
printf "\n"

sqlplus -s / as sysdba << EOF
SET LINE 130 HEADING OFF
ALTER SESSION SET CONTAINER=$PDB;
COL DESTINATION FORMAT A60
COL DEST_NAME FORMAT A30
SELECT 'Archivelog Status: '||LOG_MODE  FROM V\$DATABASE;
PROMPT Valid Archivelog Dests
select dest_name, status, destination from v\$archive_dest where status = 'VALID';
SELECT 'FRA Dest: '||VALUE FROM V\$PARAMETER WHERE NAME = 'db_recovery_file_dest';
SELECT 'FRA Size: '||VALUE/1024/1024/1024||'G' FROM V\$PARAMETER WHERE NAME = 'db_recovery_file_dest_size';
SELECT 'FRA Used: '||ceil(sum(PERCENT_SPACE_USED))||'%' FROM V\$RECOVERY_AREA_USAGE;
PROMPT Latest Archive Log which not deleted yet
select sequence#, to_char(completion_time, 'yyyy/mm/dd hh24:mi:ss') from v\$archived_log where recid = (select min(recid) from v\$archived_log where DELETED <> 'YES' and STANDBY_DEST = 'NO');
EXIT
EOF

printf "\n"
read -n 1 -s -r -p "Press any key to continue ... "
printf "\n\n\n"


# Sessions
echo -e "\e[39m \e[38;5;154m ***** ALL SESSIONS ***** \e[39m"
printf "\n"

sqlplus -s / as sysdba << EOF
SET LINE 120 HEADING OFF
ALTER SESSION SET CONTAINER=$PDB;
SELECT 'Count of All Sessions is: ' || COUNT(*) FROM V\$SESSION;
SELECT 'Count of Background Sessions: ' || COUNT(*) FROM V\$SESSION WHERE TYPE='BACKGROUND';
SELECT 'Count of User Active Sessions: ' || COUNT(*) FROM V\$SESSION WHERE TYPE='USER' AND STATUS='ACTIVE';
SELECT 'Count of User Inactive Sessions: ' || COUNT(*) FROM V\$SESSION WHERE STATUS='INACTIVE';
EXIT
EOF


printf "\n"
read -n 1 -s -r -p "Press any key to continue ... "
printf "\n\n\n"


# Find Blocking Sessions 
echo -e "\e[39m \e[38;5;154m ***** BLOCKING SESSIONS ***** \e[39m"
printf "\n"

sqlplus -s / as sysdba << EOF
SET LINE 120
ALTER SESSION SET CONTAINER=$PDB;
SELECT BLOCKING_SESSION, SID, SERIAL#, WAIT_CLASS, EVENT, SECONDS_IN_WAIT
FROM V\$SESSION
WHERE BLOCKING_SESSION IS NOT NULL
ORDER BY BLOCKING_SESSION;
EXIT
EOF


printf "\n"
read -n 1 -s -r -p "Press any key to continue ... "
printf "\n\n\n"


# Scheduler Jobs Status
echo -e "\e[39m \e[38;5;154m ***** SCHEDELER JOBS STATUS WHICH NOT SUCCEEDED ***** \e[39m"
printf "\n" 

sqlplus -s / as sysdba << EOF
SET LINE 150 
ALTER SESSION SET CONTAINER=$PDB;
COL JOB_NAME FORMAT A30
COL STATUS FORMAT A15
COL LOG_DATE FORMAT A40
COL OWNER FORMAT A20
SELECT OWNER, JOB_NAME, STATUS, ERROR#, LOG_DATE FROM DBA_SCHEDULER_JOB_RUN_DETAILS
WHERE STATUS <> 'SUCCEEDED';
EXIT
EOF


printf "\n"
read -n 1 -s -r -p "Press any key to continue ... "
printf "\n\n\n"


# SGA and PGA Status
echo -e "\e[39m \e[38;5;154m ***** SGA & PGA Status for 24 hours ***** \e[39m"
printf "\n"

sqlplus -s / as sysdba << EOF
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY/MM/DD HH24:MI:SS';
ALTER SESSION SET CONTAINER=$PDB;
SET LINE 150 
SELECT SN.INSTANCE_NUMBER, SGA.ALLO "SGA%", PGA.ALLO "PGA%",(SGA.ALLO+PGA.ALLO) "TOTAL%",
TRUNC(SN.END_INTERVAL_TIME,'mi') TIME
  FROM
(SELECT SNAP_ID,INSTANCE_NUMBER,ROUND(SUM(BYTES)/1024/1024/1024,3) ALLO 
   FROM DBA_HIST_SGASTAT 
  GROUP BY SNAP_ID,INSTANCE_NUMBER) SGA
,(SELECT SNAP_ID,INSTANCE_NUMBER,ROUND(SUM(VALUE)/1024/1024/1024,3) ALLO 
    FROM DBA_HIST_PGASTAT WHERE NAME = 'total PGA allocated' 
   GROUP BY SNAP_ID,INSTANCE_NUMBER) PGA
, DBA_HIST_SNAPSHOT SN 
WHERE SN.SNAP_ID=SGA.SNAP_ID
  AND SN.INSTANCE_NUMBER=SGA.INSTANCE_NUMBER
  AND SN.SNAP_ID=PGA.SNAP_ID
  AND SN.INSTANCE_NUMBER=PGA.INSTANCE_NUMBER
  AND TRUNC(SN.END_INTERVAL_TIME,'mi') > SYSDATE-1
ORDER BY TIME DESC;
EXIT
EOF

printf "\n"
read -n 1 -s -r -p "Press any key to continue ... "
printf "\n\n\n"


# CPU Usage 
echo -e "\e[39m \e[38;5;154m ***** CPU Usage for 24 hours ***** \e[39m"
printf "\n"

sqlplus -s / as sysdba << EOF
ALTER SESSION SET CONTAINER=$PDB;
SELECT 'OS Busy Time' SERIES, TO_CHAR(SNAPTIME, 'yyyy-mm-dd hh24') SNAP_TIME, ROUND(BUSYDELTA / (BUSYDELTA + IDLEDELTA) * 100, 2) "CPU Use (%)"
FROM (
SELECT S.BEGIN_INTERVAL_TIME SNAPTIME,
OS1.VALUE - LAG(OS1.VALUE) OVER (ORDER BY S.SNAP_ID) BUSYDELTA,
OS2.VALUE - LAG(OS2.VALUE) OVER (ORDER BY S.SNAP_ID) IDLEDELTA
FROM DBA_HIST_SNAPSHOT S, DBA_HIST_OSSTAT OS1, DBA_HIST_OSSTAT OS2
WHERE
S.SNAP_ID = OS1.SNAP_ID AND S.SNAP_ID = OS2.SNAP_ID
AND S.INSTANCE_NUMBER = OS1.INSTANCE_NUMBER AND S.INSTANCE_NUMBER = OS2.INSTANCE_NUMBER
AND S.DBID = OS1.DBID AND S.DBID = OS2.DBID
AND S.INSTANCE_NUMBER = (SELECT INSTANCE_NUMBER FROM V\$INSTANCE)
AND S.DBID = (SELECT DBID FROM V\$DATABASE)
AND OS1.STAT_NAME = 'BUSY_TIME'
AND OS2.STAT_NAME = 'IDLE_TIME'
AND S.SNAP_ID BETWEEN (SELECT MAX(SNAP_ID-23) FROM DBA_HIST_SNAPSHOT) AND (SELECT MAX(SNAP_ID) FROM DBA_HIST_SNAPSHOT));
EXIT
EOF

printf "\n"
read -n 1 -s -r -p "Press any key to continue ... "
printf "\n\n\n"


# Primary and Standby Check
echo -e "\e[39m \e[38;5;154m ***** Primary & Standby Check ***** \e[39m"
printf "\n"

sqlplus -s / as sysdba << EOF
SET LINE 150
ALTER SESSION SET CONTAINER=$PDB;
set autoprint on
set line 250
var rc1 refcursor; 
var rc2 refcursor;
DECLARE
    db_type   VARCHAR2 (20);       
BEGIN
    SELECT DATABASE_ROLE into db_type FROM V\$DATABASE;
    IF db_type = 'PRIMARY' THEN
       begin		  
          open :rc2 for select PROTECTION_MODE, LOG_MODE from v\$database;
		  open :rc1 for SELECT DATABASE_ROLE FROM V\$DATABASE;
       end; 
    ELSIF db_type = 'PHYSICAL STANDBY' THEN
       begin
          DBMS_OUTPUT.PUT_LINE ('Database Role is PHYSICAL STANDBY');
		  open :rc2 for SELECT SEQUENCE#, PROCESS, STATUS FROM V\$MANAGED_STANDBY;
          open :rc1 for SELECT NAME, VALUE FROM V\$DATAGUARD_STATS;
       end;
    ELSIF db_type = 'LOGICAL STANDBY' THEN
       begin
          DBMS_OUTPUT.PUT_LINE ('Database Role is LOGICAL STANDBY');
		  open :rc2 for select sequence#,thread#,timestamp,applied from dba_logstdby_log where applied='NO';
          open :rc1 for select * from v\$logstdby_state;
       end;	   
    END IF;
END;
/
EXIT
EOF


printf "\n"
read -n 1 -s -r -p "Press any key to continue ... "
printf "\n\n\n"


# Latest Snapshot  
echo -e "\e[39m \e[38;5;154m ***** Latest Snapshot ***** \e[39m"
printf "\n"

sqlplus -s / as sysdba << EOF
SET LINE 150
ALTER SESSION SET CONTAINER=$PDB;
COL BEGIN_INTERVAL_TIME FORMAT A40
COL END_INTERVAL_TIME FORMAT A40
SELECT SNAP_ID, BEGIN_INTERVAL_TIME, END_INTERVAL_TIME, ERROR_COUNT  FROM DBA_HIST_SNAPSHOT 
WHERE SNAP_ID = (SELECT MAX(SNAP_ID) FROM DBA_HIST_SNAPSHOT);
EXIT
EOF


printf "\n"
read -n 1 -s -r -p "Press any key to continue ... "
printf "\n\n\n"


# User Accounts 
echo -e "\e[39m \e[38;5;154m ***** Database Users Status ***** \e[39m"
printf "\n"

sqlplus -s / as sysdba << EOF
SET LINESIZE 120
ALTER SESSION SET CONTAINER=$PDB;
COL USERNAME FORMAT A20
COL ACCOUNT_STATUS FORMAT A15
COL PROFILE FORMAT A20
SELECT USERNAME, ACCOUNT_STATUS, LOCK_DATE, EXPIRY_DATE, PROFILE FROM DBA_USERS WHERE USERNAME NOT IN 
('SPATIAL_WFS_ADMIN_USR','SPATIAL_CSW_ADMIN_USR','APEX_PUBLIC_USER','DIP',
 'MDDATA','XS\$NULL','ORACLE_OCM','SCOTT','OLAPSYS','SI_INFORMTN_SCHEMA',
 'OWBSYS','ORDPLUGINS','XDB','ANONYMOUS','CTXSYS','ORDDATA','OWBSYS_AUDIT',
 'APEX_030200','WMSYS','EXFSYS','ORDSYS','MDSYS','FLOWS_FILES','OUTLN','APPQOSSYS',
 'DBSFWUSER','GGSYS','GSMADMIN_INTERNAL','GSMCATUSER','SYSBACKUP','REMOTE_SCHEDULER_AGENT','GSMROOTUSER',
 'GSMUSER','SYSRAC','AUDSYS','SYSKM','SYS\$UMF','EMULATION','SYSDG','OJVMSYS','LBACSYS','DVSYS','DVF');
EXIT
EOF


printf "\n"
read -n 1 -s -r -p "Press any key to continue ... "
printf "\n\n\n"


# Active Session History (ASH)
echo -e "\e[39m \e[38;5;154m ***** Active Session History (ASH) ***** \e[39m"
printf "\n"

sqlplus -s / as sysdba << EOF
SET LINESIZE 120
ALTER SESSION SET CONTAINER=$PDB;
COL EVENT FORMAT a50
SELECT NVL(a.event, 'ON CPU') AS event,
       COUNT(*) AS total_wait_time
FROM   v\$active_session_history a
WHERE  a.sample_time > SYSDATE - 5/(24*60) -- 5 mins
GROUP BY a.event
ORDER BY total_wait_time DESC;
EXIT
EOF


printf "\n"
read -n 1 -s -r -p "Press any key to continue ... "
printf "\n\n\n"


# Database Statistics 
echo -e "\e[39m \e[38;5;154m ***** Database Statistics ***** \e[39m"
printf "\n"

sqlplus -s / as sysdba << EOF
SET LINESIZE 180
ALTER SESSION SET CONTAINER=$PDB;
col OPERATION FOR a30
col TARGET FOR a5
col START_TIME FOR a40
col END_TIME FOR a40
col STATUS format a20
SELECT * FROM (SELECT ID, OPERATION, START_TIME, END_TIME, STATUS FROM DBA_OPTSTAT_OPERATIONS 
WHERE OPERATION = 'gather_database_stats (auto)' 
ORDER BY START_TIME DESC) WHERE ROWNUM <= 5;
EXIT
EOF

printf "\n"
read -n 1 -s -r -p "Press any key to continue ... "
printf "\n\n\n"


# Alert_log

diag=$(sqlplus -s sys/oracle as sysdba << EOF
SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF
select value from  V\$DIAG_INFO where name = 'Diag Trace';
EXIT;
EOF
)

printf "\n\n\n"
echo -e "\e[39m \e[38;5;154m ***** ERRORS FROM ALERT LOG ***** \e[39m"
printf "\n\n\n"
tail -n 10000 $diag/alert_$ORACLE_SID.log|grep -i -C 3 'ora-\|checkpoint\|alter\|Deadlock\|Corruption'

printf "\n"
read -n 1 -s -r -p "Press any key to continue ... "
printf "\n\n\n"


# OS Log

echo -e "\e[39m \e[38;5;154m ***** ERRORS FROM OS Log dmesg ***** \e[39m"
printf "\n\n\n"
dmesg|grep -i -C 3 'fail\|error'

printf "\n"
read -n 1 -s -r -p "Press any key to continue ... "
printf "\n\n\n"
