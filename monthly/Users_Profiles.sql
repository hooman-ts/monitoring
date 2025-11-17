set line 1000;
col username format a25;
col account_status format a20;
col default_tablespace format a20;
col profile format a10;
SELECT username,
       account_status,
       lock_date,
       expiry_date,
       default_tablespace,
       created,
       profile,
       authentication_type
  FROM dba_users;
col profile format a25;
select * from dba_profiles order by 1;