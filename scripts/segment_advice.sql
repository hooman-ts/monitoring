DECLARE
my_task_id number;
obj_id number;
my_task_name varchar2(100);
my_task_desc varchar2(500);
BEGIN
my_task_name := 'EBRGBEK0 Advice';
my_task_desc := 'Manual Segment Advisor Run';
---------
-- Step 1
---------
dbms_advisor.create_task (
advisor_name => 'Segment Advisor',
task_id => my_task_id,
task_name => my_task_name,
task_desc => my_task_desc);
---------
-- Step 2
---------
dbms_advisor.create_object (
task_name => my_task_name,
object_type => 'TABLE',
attr1 => 'EFES',
attr2 => 'EBRGBEK0',
attr3 => NULL,
attr4 => NULL,
attr5 => NULL,
object_id => obj_id);
---------
-- Step 3
---------
dbms_advisor.set_task_parameter(
task_name => my_task_name,
parameter => 'recommend_all',
value => 'TRUE');
---------
-- Step 4
---------
dbms_advisor.execute_task(my_task_name);
END;
/

exec dbms_advisor.delete_task ('EBRGB0 Advice');


SELECT
'Segment Advice --------------------------'|| chr(10) ||
'TABLESPACE_NAME : ' || tablespace_name || chr(10) ||
'SEGMENT_OWNER : ' || segment_owner || chr(10) ||
'SEGMENT_NAME : ' || segment_name || chr(10) ||
'ALLOCATED_SPACE : ' || allocated_space || chr(10) ||
'RECLAIMABLE_SPACE: ' || reclaimable_space || chr(10) ||
'RECOMMENDATIONS : ' || recommendations || chr(10) ||
'SOLUTION 1 : ' || c1 || chr(10) ||
'SOLUTION 2 : ' || c2 || chr(10) ||
'SOLUTION 3 : ' || c3 Advice
FROM
TABLE(dbms_space.asa_recommendations('TRUE', 'TRUE', 'FALSE'));


select
'Task Name : ' || f.task_name || chr(10) ||
'Start Run Time : ' || TO_CHAR(execution_start, 'dd-mon-yy hh24:mi') || chr (10) ||
'Segment Name : ' || o.attr2 || chr(10) ||
'Segment Type : ' || o.type || chr(10) ||
'Partition Name : ' || o.attr3 || chr(10) ||
'Message : ' || f.message || chr(10) ||
'More Info : ' || f.more_info || chr(10) ||
'------------------------------------------------------' Advice
FROM dba_advisor_findings f
,dba_advisor_objects o
,dba_advisor_executions e
WHERE o.task_id = f.task_id
AND o.object_id = f.object_id
AND f.task_id = e.task_id
AND e. execution_start > sysdate - 1
AND e.advisor_name = 'Segment Advisor'
ORDER BY f.task_name;


select
segments_processed
,end_time
from dba_auto_segadv_summary
order by end_time;


DBA_ADVISOR_EXECUTIONS
DBA_ADVISOR_FINDINGS
DBA_ADVISOR_OBJECTS


select * from 
(
SELECT dt.owner, dt.table_name,
 (CASE
 WHEN NVL(ind.cnt, 0) < 1 THEN 'Y'
 ELSE 'N'
 END) AS can_shrink
 FROM dba_tables dt,
 (SELECT table_name, COUNT(*) cnt
 FROM dba_indexes di
 WHERE index_type LIKE 'FUNCTION-BASED%'
 GROUP BY table_name) ind
 WHERE dt.table_name = ind.table_name(+)
 AND dt.table_name NOT LIKE 'AQ$%'
 AND dt.table_name NOT LIKE 'BIN$%'
 AND dt.owner = 'EFES'
 ) where can_shrink='N'
 ORDER BY 1, 2;