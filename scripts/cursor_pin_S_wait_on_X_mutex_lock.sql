SELECT COMPONENT ,OPER_TYPE,FINAL_SIZE Final,to_char(start_time,'dd-mon hh24:mi:ss') Started 
FROM V$SGA_RESIZE_OPS order by started;


SELECT s.sid, t.sql_text
FROM v$session s, v$sql t
WHERE s.event LIKE '%cursor: pin S wait on X%'
AND t.sql_id = s.sql_id

select * from V$MUTEX_SLEEP_HISTORY order by sleep_timestamp desc

select sid,p2raw,to_number(substr(to_char(rawtohex(p2raw)),1,8),'XXXXXXXX') sid_holder 
     from v$session 
     where event = 'cursor: pin S wait on X';
