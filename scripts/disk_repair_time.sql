SELECT group_number, name, value FROM v$asm_attribute ORDER BY group_number, name;

ALTER DISKGROUP DATAC1 SET ATTRIBUTE 'disk_repair_time' = '4.5h';

select * from v$asm_diskgroup