select DBMS_SQLTUNE.REPORT_SQL_MONITOR(sql_id=>'cun62a05jhw8n', report_level=>'all') SQL_Report from dual;

variable stmt_task VARCHAR2(64);
EXEC :stmt_task := DBMS_SQLTUNE.CREATE_TUNING_TASK(sql_id => 'f51bk8grsbdzy',task_name=>'tlp_f51bk8grsbdzy');


 BEGIN
 dbms_sqltune.execute_tuning_task (task_name => 'tlp_f51bk8grsbdzy');
  end;
  /
 
SELECT status FROM USER_ADVISOR_TASKS WHERE task_name ='tlp_f51bk8grsbdzy';

SET linesize 200
 SET LONG 999999999
 SET pages 1000
 SET longchunksize 20000
 
 SELECT DBMS_SQLTUNE.REPORT_TUNING_TASK( 'tlp_f51bk8grsbdzy' )
 FROM DUAL;
 
 select * from dba_sql_profiles where name='SYS_SQLPROF_014c22d728d10001'