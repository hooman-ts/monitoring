begin
  dbms_scheduler.create_schedule(  
      schedule_name => 'Lock_Control_Schedule'
    , start_date =>  '29.12.2009 13:00:00,000000 +02:00'
    , repeat_interval => 'FREQ=MINUTELY'
    , comments => 'Her saat basi');
END;
/
--'Yearly','Monthly','Weekly','Daily','Hourly','Minutely','Secondely' 
/*
To drop the schedule:
begin
  dbms_scheduler.drop_schedule(
     schedule_name => 'Lock_Control_Schedule'
     , force => TRUE );
end;
/

*/
-- Shell script için
begin
   dbms_scheduler.create_job
   (
      job_name      => 'Lock_Control',
      schedule_name => 'Lock_Control_Schedule',
      job_type      => 'EXECUTABLE',
      job_action    => '/oracle/vyg.sh',
      enabled       => true,
      comments      => 'Run shell-script'
   );
end;
/

-- PL/SQL block için
begin
  dbms_scheduler.create_job(
      job_name => 'EVENT_CONTROL'
     ,job_type => 'PLSQL_BLOCK'
     ,job_action => 'begin talip; end; '
     ,start_date => '29.12.2009 09:00:00,000000 +02:00'
     ,repeat_interval => 'FREQ=MINUTELY'
     ,enabled => TRUE
     ,comments => 'Event Control Deneme');
end;
/

begin
  dbms_scheduler.drop_job(
      job_name => 'EVENT_CONTROL'
     , force => TRUE );
end;
/

BEGIN
  SYS.DBMS_SCHEDULER.DISABLE
    (name => 'TALIP.EVENT_CONTROL');
END;
/

BEGIN
  SYS.DBMS_SCHEDULER.ENABLE
    (name => 'TALIP.EVENT_CONTROL');
END;
/

select log_date
,      job_name
,      status
,      req_start_date
,      actual_start_date
,      run_duration
from   dba_scheduler_job_run_details
where job_name like '%EVENT%'
order by req_start_date desc;



--To show job history:
 select log_date
 ,      job_name
 ,      status
 from dba_scheduler_job_log
 where job_name like '%EVENT%';
 
-- To show running jobs:
select job_name
,      session_id
,      running_instance
,      elapsed_time
,      cpu_used
from dba_scheduler_running_jobs
 where job_name like '%LOCK%';

EXEC dbms_scheduler.run_job('myjob');