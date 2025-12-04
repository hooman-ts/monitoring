SELECT sql_handle,
         plan_name,
         enabled,
         accepted,
         fixed,
         reproduced,
         autopurge,
         executions,
         ROUND (
              v.buffer_gets
            / TO_NUMBER (DECODE (v.executions, 0, 1, v.executions)))
            buffer_PerExec,
         ROUND (
              v.elapsed_time
            / TO_NUMBER (DECODE (v.executions, 0, 1, v.executions))
            / 1000000,
            2)
            timeInSec_PerExec,
         ROUND (
              v.cpu_time
            / TO_NUMBER (DECODE (v.executions, 0, 1, v.executions))
            / 1000000,
            2)
            timeInSec_CpuPerExec,
         parsing_schema_name,
         optimizer_cost,
         LAST_MODIFIED,
         sql_text
    FROM dba_sql_plan_baselines v
ORDER BY last_modified DESC;


DECLARE
  l_plans_loaded  PLS_INTEGER;
BEGIN
  l_plans_loaded := DBMS_SPM.load_plans_from_cursor_cache(
    sql_id => '9uv542vtn0hc5',plan_hash_value=>118259802,fixed=>'YES');
END;
/

SELECT *
  FROM TABLE (
          DBMS_XPLAN.display_sql_plan_baseline (
             plan_name   => 'SQL_PLAN_3q32rfc81889n74986091'));
             
             
declare
   l_plans pls_integer;
begin
   l_plans := dbms_spm.alter_sql_plan_baseline (
      sql_handle         => 'SQL_6600fe4df5fa16a8',
      plan_name         => 'SQL_PLAN_6c07y9ruzn5p8dcab14db',
      attribute_name   => 'fixed',
      attribute_value  => 'YES'
   );
end;
/
  
--- Loading SQL Plans into SPM using AWR

exec dbms_sqltune.create_sqlset(sqlset_name => 'b8rc6j0krxwdc_sqlset_test',description => 'sqlset descriptions');

declare
baseline_ref_cur DBMS_SQLTUNE.SQLSET_CURSOR;
begin
open baseline_ref_cur for
select VALUE(p) from table(
DBMS_SQLTUNE.SELECT_WORKLOAD_REPOSITORY(&begin_snap_id, &end_snap_id,'sql_id='||CHR(39)||'&sql_id'||CHR(39)||'',NULL,NULL,NULL,NULL,NULL,NULL,'ALL')) p;
DBMS_SQLTUNE.LOAD_SQLSET('b8rc6j0krxwdc_sqlset_test', baseline_ref_cur);
end;
/


declare
baseline_ref_cur DBMS_SQLTUNE.SQLSET_CURSOR;
begin
open baseline_ref_cur for
select VALUE(p) from table(
DBMS_SQLTUNE.SELECT_WORKLOAD_REPOSITORY(&begin_snap_id, &end_snap_id,'sql_id='||CHR(39)||'&sql_id'||CHR(39)||' and plan_hash_value=1421641795',NULL,NULL,NULL,NULL,NULL,NULL,'ALL')) p;
DBMS_SQLTUNE.LOAD_SQLSET('b8rc6j0krxwdc_sqlset_test', baseline_ref_cur);
end;
/

select * from table(dbms_xplan.display_sqlset('b8rc6j0krxwdc_sqlset_test','&sql_id'));


set serveroutput on
declare
my_int pls_integer;
begin
my_int := dbms_spm.load_plans_from_sqlset (
sqlset_name => 'b8rc6j0krxwdc_sqlset_test',
basic_filter => 'sql_id="b8rc6j0krxwdc" and plan_hash_value =1306981985',
sqlset_owner => 'SYS',
fixed => 'NO',
enabled => 'YES');
DBMS_OUTPUT.PUT_line(my_int);
end;
/

set serveroutput on
declare
my_int pls_integer;
begin
my_int := DBMS_SPM.DROP_SQL_PLAN_BASELINE (
   sql_handle     => 'SQL_3a19fe140b9d4869',
   plan_name      =>'SQL_PLAN_3n6gy2h5tuk39915e3d1e');
DBMS_OUTPUT.PUT_line(my_int);
end;
/


 select ADDRESS, HASH_VALUE from V$SQLAREA where SQL_ID like '9zcq6333f5wbx%';

ADDRESS      HASH_VALUE
---------------- ----------
000000085FD77CF0  808321886

SQL> exec DBMS_SHARED_POOL.PURGE ('0000000E44694000, 3336761725', 'C');