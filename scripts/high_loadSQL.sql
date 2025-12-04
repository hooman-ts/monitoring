select     sql_text
, lpad(username,9)   parsing_user
, executions
, loads
, DISK_READS
, BUFFER_GETS    
, ROWS_PROCESSED 
from v$sqlarea  a
,    dba_users  b
where a.PARSING_USER_ID = b.user_id
and   DISK_READS > &number_of_expensive_DISK_READS
and   b.username = upper('SFH')
order by DISK_READS desc
,        ROWS_PROCESSED desc
,        BUFFER_GETS desc
,        username