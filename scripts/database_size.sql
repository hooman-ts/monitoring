select sum(bytes/1048576) from   dba_extents;


select sum(bytes)/1024/1024 from dba_data_files;

select sum(bytes)/1024/1024  from v$datafile;

select sum(bytes)/1024/1024 from v$log;
