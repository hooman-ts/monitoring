/* Formatted on 11/25/2019 2:59:46 PM (QP5 v5.287) */
set line 1000;
col owner format a10;
col table_name format a20;

SELECT owner,
       table_name,
       status,
       pct_free,
       num_rows,
       avg_row_len,
       chain_cnt
  FROM dba_tables
 WHERE chain_cnt > 0;