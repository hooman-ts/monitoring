/* Formatted on 11/25/2019 3:06:32 PM (QP5 v5.287) */
set line 1000;
col owner format a15;
col OBJECT_NAME format a30;
col OBJECT_TYPE format a30;

SELECT OWNER,OBJECT_NAME,OBJECT_TYPE,STATUS
  FROM dba_objects
 WHERE status = 'INVALID' order by 1;