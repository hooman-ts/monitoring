-- high i/o

SELECT sql_text, disk_reads FROM
(SELECT sql_text, buffer_gets, disk_reads, sorts,
cpu_time/1000000 cpu, rows_processed, elapsed_time
FROM v$sqlstats
ORDER BY disk_reads DESC)
WHERE rownum <= 5;



SELECT schema, sql_text, disk_reads, round(cpu,2) FROM
(SELECT s.parsing_schema_name schema, t.sql_id, t.sql_text, t.disk_reads,
t.sorts, t.cpu_time/1000000 cpu, t.rows_processed, t.elapsed_time
FROM v$sqlstats t join v$sql s on(t.sql_id = s.sql_id)
WHERE parsing_schema_name = 'SCOTT'
ORDER BY disk_reads DESC)
WHERE rownum <= 5;


SELECT sid, buffer_gets, disk_reads, round(cpu_time/1000000,1) cpu_seconds
FROM v$sql_monitor
WHERE SID=100
AND status = 'EXECUTING';


-- cpu consuming
SELECT * FROM (
SELECT sid, buffer_gets, disk_reads, round(cpu_time/1000000,1) cpu_seconds
FROM v$sql_monitor
ORDER BY cpu_time desc)
WHERE rownum <= 5;
SID BUFFER_GETS


--historical
SELECT * FROM (
SELECT sql_id, sum(disk_reads_delta) disk_reads_delta,
sum(disk_reads_total) disk_reads_total,
sum(executions_delta) execs_delta,
sum(executions_total) execs_total
FROM dba_hist_sqlstat
GROUP BY sql_id
ORDER BY 2 desc)
WHERE rownum <= 5;


select * from ( SELECT parsing_schema_name "Owner",
         last_load_time,
         last_active_time,
         executions,
         rows_processed,
         ROUND (rows_processed / executions), 
         ROUND (cpu_time / executions) AS "Cpu_perexec",
         ROUND (buffer_gets / executions) AS "buffer_perexec",
         ROUND (disk_reads / executions) AS "reads_perexec",
         executions "# of Executions",
         (elapsed_time / executions) / 1000000 AS "TimeSpend sec.",
         DBMS_LOB.SUBSTR (SQL_FULLTEXT, 4000, 1) AS SqlFullText
    FROM v$sql
   WHERE executions > 0
     AND TRUNC (last_active_time) = TRUNC (SYSDATE)
ORDER BY 8 DESC)
where rownum <21 