DECLARE
  X NUMBER:=111;
BEGIN
  SYS.DBMS_JOB.ISUBMIT
  ( job       => X 
   ,what      => 'declare  begin null; end;'
   ,next_date => to_date('22/03/2010 16:00:00','dd/mm/yyyy hh24:mi:ss')
   ,interval  => 'sysdate+5/1440'
   ,no_parse  => FALSE
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Job Number is: ' || to_char(x));
COMMIT;
END;
/
select * from dba_jobs where job=113 order by job asc;

select * from dba_jobs_running;

select rowid,v.* from VYG_DB_JOB v;

-- Running
exec dbms_job.run(184);commit;

--Removing
exec dbms_ijob.remove(36);commit;

--Broken
exec dbms_job.broken(124, TRUE);commit;


--Interval
exec sys.DBMS_iJOB.interval  ( job =>12,interval => 'sysdate +1/1440'); commit;
  
--Next_date
exec DBMS_JOB.next_date ( job =>1126,next_date => TO_DATE(to_char(sysdate+1,'DD/MM/YYYY')||' 02:15:00','DD/MM/YYYY HH24:MI:SS')); commit;


begin  sys.dbms_ijob.remove(205);commit;end;


    
begin 
	sys.dbms_ijob.BROKEN(370,false);
    commit;
end;