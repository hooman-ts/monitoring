select owner,table_name,last_analyzed from dba_tables where owner='&1' order by 3 desc;
select owner,table_name,index_name,last_analyzed from dba_indexes where owner='&1' order by 4 desc;