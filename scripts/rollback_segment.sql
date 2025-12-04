select sum(blocks),sum(extents),segment_name from DBA_SEGMENTS where tablespace_name = 'UNDOTBS1' 
and segment_name like '%SYSSMU7$%' group by segment_name;

select 475336*8/1024 from dual;

select * from v$parameter where name like '%undo%'


select TABLESPACE_NAME, CONTENTS,
           EXTENT_MANAGEMENT, ALLOCATION_TYPE,
           SEGMENT_SPACE_MANAGEMENT
        from dba_tablespaces where contents='UNDO';