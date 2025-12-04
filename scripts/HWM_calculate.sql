


--ANALYZE TABLE talip.employees ESTIMATE STATISTICS;




DECLARE
used number;
free number;
hwm number;
cursor usd is
SELECT blocks
FROM   DBA_SEGMENTS
WHERE  segment_name='EMPLOYEES';

cursor fre is
select empty_blocks from dba_tables
where table_name='EMPLOYEES';
BEGIN
open usd;
open fre;
fetch usd into used;
fetch fre into free;
hwm:=used-free;
dbms_output.PUT_LINE('Employees HWM deðeri: '|| hwm ||'='||used||'-'||free);
close fre;
close usd;

END;
/
