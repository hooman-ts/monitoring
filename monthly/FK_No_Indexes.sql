/* Formatted on 11/25/2019 3:02:12 PM (QP5 v5.287) */
set line 1000;
col status format a10;
col table_name format a20;
col fk_name format a30;
col fk_columns format a30;
col index_name format a20;
col index_columns format a30;
  SELECT CASE WHEN b.table_name IS NULL THEN 'unindexed' ELSE 'indexed' END
            AS status,
         a.table_name AS table_name,
         a.constraint_name AS fk_name,
         a.fk_columns AS fk_columns,
         b.index_name AS index_name,
         b.index_columns AS index_columns
    FROM (  SELECT a.table_name,
                   a.constraint_name,
                   LISTAGG (a.column_name, ',')
                      WITHIN GROUP (ORDER BY a.position)
                      fk_columns
              FROM dba_cons_columns a, dba_constraints b
             WHERE     a.constraint_name = b.constraint_name
                   AND b.constraint_type = 'R'
                   AND a.owner = '&&schema_owner'
                   AND a.owner = b.owner
          GROUP BY a.table_name, a.constraint_name) a,
         (  SELECT table_name,
                   index_name,
                   LISTAGG (c.column_name, ',')
                      WITHIN GROUP (ORDER BY c.column_position)
                      index_columns
              FROM dba_ind_columns c
             WHERE c.index_owner = '&&schema_owner'
          GROUP BY table_name, index_name) b
   WHERE     a.table_name = b.table_name(+)
         AND b.index_columns(+) LIKE a.fk_columns || '%'
ORDER BY 1 DESC, 2;