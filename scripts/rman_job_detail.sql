
select
	SESSION_KEY, INPUT_TYPE, STATUS,
	to_char(START_TIME,'mm/dd/yy hh24:mi') start_time,
	to_char(END_TIME,'mm/dd/yy hh24:mi')   end_time,
	elapsed_seconds/3600                   hrs
	from V$RMAN_BACKUP_JOB_DETAILS
	order by session_key desc
/


select * from V$RMAN_BACKUP_JOB_DETAILS 
where output_device_type='SBT_TAPE' 
and input_type='DB INCR'
and status='RUNNING'


select * from V$RMAN_BACKUP_JOB_DETAILS 
where output_device_type='SBT_TAPE' 
and input_type='DB INCR'
and status='COMPLETED'

SELECT sid, serial#, context, sofar, totalwork,
round(sofar/totalwork*100,2) "% Complete"
FROM v$session_longops
WHERE opname LIKE 'RMAN%'
AND opname NOT LIKE '%aggregate%'
AND totalwork != 0
AND sofar <> totalwork;