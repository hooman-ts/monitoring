set line 1000;
col tablespace_name format a20;
col file_name format a40;
/*col tablespace_name format a30;
col tablespace_name format a30;*/
SELECT tbl.tablespace_name,
       tbl.block_size,
       tbl.bigfile,
       tbl.status,
       TBL.RETENTION,
       fil.file_name,
       fil.bytes / 1024 / 1024 / 1024 Current_GB,
       fil.autoextensible,
       FIL.MAXBYTES/1024/1024/1024 MAX_GB,
       fil.increment_by*tbl.block_size/1024/1024 NEXT_MB
  FROM dba_tablespaces tbl, dba_data_files fil
 WHERE TBL.TABLESPACE_NAME = FIL.TABLESPACE_NAME and TBL.CONTENTS='UNDO';
 
 select name,value from v$parameter where name like '%undo%';