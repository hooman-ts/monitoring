DECLARE
v_dynam     varchar2(100);
cursor idx_cursor is
  select owner, index_name from index_details;

BEGIN
for c_row in idx_cursor loop
   v_dynam := 'analyze index '||c_row.owner||'.'||c_row.index_name||
             ' validate structure';
   execute immediate v_dynam;
   update index_details set
              (HEIGHT, BLOCKS, NAMEx, PARTITION_NAME, LF_ROWS, LF_BLKS,
               LF_ROWS_LEN, LF_BLK_LEN, BR_ROWS, BR_BLKS, BR_ROWS_LEN,
               BR_BLK_LEN, DEL_LF_ROWS, DEL_LF_ROWS_LEN, DISTINCT_KEYSx,
               MOST_REPEATED_KEY, BTREE_SPACE, USED_SPACE, PCT_USED,
               ROWS_PER_KEY, BLKS_GETS_PER_ACCESS, PRE_ROWS, PRE_ROWS_LEN,
               OPT_CMPR_COUNT, OPT_CMPR_PCTSAVE)
       = (select * from index_stats)
     where index_details.owner = c_row.owner 
       and index_details.index_name = c_row.index_name;
   if mod(idx_cursor%rowcount,50)=0 then
     commit;
   end if;
end loop;
commit;

END;
/

update 
   index_details a
set
   num_keys = 
   (select 
      count(*)
    from
      dba_ind_columns b
    where
       a.owner_name = b.table_owner
    and
       a.index_name = b.index_name
   )
;