SELECT s.inst_id,  s.sid,p.spid,w.SECONDS_IN_WAIT,s.process, s.LOGON_TIME,  s.machine, v.sql_id, v.sql_text
    FROM gv$session_wait w,  gv$session s,
        gv$sqlarea v, gv$process p
   WHERE     w.sid = s.sid
         AND p.addr = s.paddr
         AND v.hash_value(+) = s.sql_hash_value
         and w.inst_id = s.inst_id
         and v.inst_id= s.inst_id
         and p.inst_id = s.inst_id
         AND s.event like  '%buffer busy waits%'
         AND w.event NOT IN
                ('SQL*Net message to client',
                 'rdbms ipc message',
                 'jobq slave wait',
                 'pipe get',
                 'SQL*Net message from client',
                 'PL/SQL lock timer',
                 'wakeup time manager');
                 
                 
  SELECT inst_id,
         SYSDATE,
         event,
         COUNT (*)
    FROM gV$SESSION_WAIT
   WHERE event NOT IN
            ('SQL*Net message to client',
             'SQL*Net more data to client',
             'gcs remote message',
             'class slave wait',
             'rdbms ipc message',
             'jobq slave wait',
             'pipe get',
             'SQL*Net message from client',
             'PL/SQL lock timer',
             'DIAG idle wait',
             'PING',
             'pmon timer',
             'smon timer',
             'wakeup time manager',
             'VKRM Idle',
             'GCR sleep',
             'EMON slave idle wait',
             'ASM background timer',
             'VKTM Logical Idle Wait',
             'Streams AQ: qmn slave idle wait',
             'Streams AQ: waiting for time management or cleanup tasks',
             'Streams AQ: emn coordinator idle wait',
             'Space Manager: slave idle wait',
             'Streams AQ: qmn coordinator idle wait')
GROUP BY inst_id, event
ORDER BY inst_id, COUNT (*) DESC;



select * from v$session where event='latch: row cache objects'


SELECT    'alter system kill session  ''' || v$session.sid  || ',' ||   v$session.serial# || ''';'
  FROM v$session  WHERE TYPE <> 'BACKGROUND'
              AND V$session.event = 'library cache: mutex X'
              
              
              
select event,sql_id,count(*) from v$active_session_history where sample_time between to_date('16.12.2014 01:26:00','dd.mm.yyyy hh24:mi:ss') and to_date('16.12.2014 01:30:00','dd.mm.yyyy hh24:mi:ss') 
and machine like '%opcuc4%' group by  event,sql_id order by 3 desc