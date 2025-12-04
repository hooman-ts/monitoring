SELECT   s.SID, username, osuser, s.status, event, row_wait_obj#,
         row_wait_file#, row_wait_block#, row_wait_row#, object_type, p3 Reasoncode, owner,
         object_name, data_object_id,
         CASE object_type
            WHEN 'TABLE'
               THEN    'select * from '
                    || owner
                    || '.'
                    || object_name
                    || ' where rowid = DBMS_ROWID.ROWID_CREATE(1,'
                    || data_object_id
                    || ','
                    || row_wait_file#
                    || ','
                    || row_wait_block#
                    || ','
                    || row_wait_row#
                    || ');'
            ELSE ''
         END "Query to find waited row"
    FROM  v$session s, dba_objects o
   WHERE object_id = row_wait_obj# AND s.event = 'enq: TX - row lock contention'

SELECT   s.Session_id, event, current_obj#,
         current_file#, current_block#, current_row#, object_type, p3 Reasoncode, owner,
         object_name, data_object_id,
         CASE object_type
            WHEN 'TABLE'
               THEN    'select * from '
                    || owner
                    || '.'
                    || object_name
                    || ' where rowid = DBMS_ROWID.ROWID_CREATE(1,'
                    || data_object_id
                    || ','
                    || current_file#
                    || ','
                    || current_block#
                    || ','
                    || current_row#
                    || ');'
            ELSE ''
         END "Query to find waited row"
    FROM  v$active_session_history s, dba_objects o
   WHERE object_id = current_obj# AND s.event = 'enq: TX - row lock contention'


SELECT * FROM DBA_LOCKS;


SELECT l.sess,
          s.inst_id || '_'
          || TRIM(   NVL (s.client_info, s.username)
                  || '_'
                  || s.action
                  || '_'
                  || s.module
                  || '_'
                  || s.username
                  || '_'
                  || l.TYPE
                  || '_'
                  || l.lmode
                  || '_'
                  || l.request
                  || '_'
                  || s.sql_hash_value)
             "USER",
          o.object_name,
          s.status,
          s.inst_id,
          s.sid,
          s.serial#,
          w.event,
          ROUND (w.seconds_in_wait / 60, 2) minutes_in_wait,
          CASE
             WHEN l.block > 0 AND s.event NOT IN ('enqueue')
             THEN
                'kill -9 ' || p.spid
             ELSE
                '#kill -9 ' || p.spid
          END
             kill_os,
          CASE
             WHEN l.block > 0 AND s.event NOT IN ('enqueue')
             THEN
                   'ALTER SYSTEM KILL SESSION '''
                || s.sid
                || ','
                || s.serial#
                || ''';'
             ELSE
                   '--ALTER SYSTEM KILL SESSION '''
                || s.sid
                || ','
                || s.serial#
                || ''';'
          END
             kill_sid,
          s.osuser,
          s.process,
          s.machine,
          s.last_call_et
   FROM             (   SELECT DECODE (l.request, 0, 'Holder: ', '      Waiter: ') sess,
          l."INST_ID",
          l."ADDR",
          l."KADDR",
          l."SID",
          l."TYPE",
          l."ID1",
          l."ID2",
          l."LMODE",
          l."REQUEST",
          l."CTIME",
          l."BLOCK"
   FROM gv$lock l
   WHERE (l.id1, l.id2, l.TYPE) IN (SELECT id1, id2, TYPE
                                    FROM gv$lock
                                    WHERE request > 0)) l
                 JOIN
                    gv$session s
                 ON l.sid = s.sid AND s.inst_id = l.inst_id
              LEFT OUTER JOIN
                 dba_objects o
              ON o.object_id = l.id1
           LEFT OUTER JOIN
              gv$session_wait w
           ON w.sid = s.sid AND w.inst_id = s.inst_id
        LEFT OUTER JOIN
           gv$process p
        ON p.addr = s.paddr AND p.inst_id = s.inst_id;
        


SELECT /*+ rule */ DECODE (l.request, 0, 'Holder: ', '      Waiter: ') sess,
l."SID",
S.SERIAL#,
l."CTIME",
l."BLOCK",
 s.inst_id || '_'
          || TRIM(   NVL (s.client_info, s.username)
                  || '_'
                  || s.action
                  || '_'
                  || s.module
                  || '_'
                  || s.username
                  || '_'
                  || l.TYPE
                  || '_'
                  || l.lmode
                  || '_'
                  || l.request
                  || '_'
                  || s.sql_hash_value)
             "USER",
S.EVENT,s.status,
'ALTER SYSTEM KILL SESSION '
          || ''''
          || s.sid
          || ','
          || s.serial#
          || ','
          || '@'
          || s.inst_id
          || ''' IMMEDIATE; ' "KILL_KOMUT"
FROM gv$lock l JOIN gv$session s
ON l.sid = s.sid AND s.inst_id = l.inst_id
  WHERE (l.id1, l.id2, l.TYPE) IN (SELECT id1, id2, TYPE
                                    FROM gv$lock
                                    WHERE request > 0);
                                    

select /*+ rule */
         'ALTER SYSTEM KILL SESSION '
          || ''''
          || a.sid
          || ','
          || a.serial#
          || ','
          || '@'
          || a.inst_id
          || ''' immediate; ' ,a.action,a.program  from gv$session a where sid in (select /*+ rule */ session_id from dba_dml_locks where name = 'EXCLD')  and sid not in (13923) and status <> 'KILLED'


select 'ALTER SYSTEM KILL SESSION '
          || ''''
          || s.sid
          || ','
          || s.serial#
          || ','
          || '@'
          || s.inst_id
          || ''' IMMEDIATE; '  from gv$session s where username='DBSNMP'
          
          
select * from DBA_TAB_MODIFICATIONS where truncated='YES'

--In 11g parameter enable_ddl_logging can be set to TRUE to print DDL statements in the alert log and identify what DDL's are run that may potentially cause this error.