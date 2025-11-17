/* Formatted on 11/24/2019 1:49:42 PM (QP5 v5.287) */
SELECT tbl.tablespace_name,
       tbl.block_size,
       tbl.bigfile,
       tbl.status,
       fil.file_name,
       fil.bytes / 1024 / 1024 / 1024 Current_GB,
       fil.autoextensible,
	   fil.maxbytes/1024/1024/1024 MAX_GB,
       fil.increment_by*tbl.block_size/1024/1024 NEXT_MB
  FROM dba_tablespaces tbl, dba_data_files fil
 WHERE TBL.TABLESPACE_NAME = FIL.TABLESPACE_NAME;