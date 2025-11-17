/* Formatted on 11/25/2019 2:34:10 PM (QP5 v5.287) */
set line 1000;
col owner format a15;
  SELECT I.OWNER,
         I.INDEX_NAME,
         I.INDEX_TYPE,
         I.BLEVEL,
         I.LAST_ANALYZED
    FROM dba_indexes i
   WHERE blevel > 3
ORDER BY 4, 5 DESC;