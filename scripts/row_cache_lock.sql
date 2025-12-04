
select p1text,p1,p2text,p2,p3text,p3 from v$active_session_history where event like '%row cache lock%';

select parameter,count,gets,getmisses,modifications from v$rowcache where cache#=19;

select * from V$LATCHHOLDER


  SELECT child#, gets, misses, sleeps
    FROM v$latch_children
   WHERE name='row cache objects'
     and sleeps>0
   ORDER BY sleeps,misses,gets
  ;
  
  
select addr, latch#, child#, name, misses, gets from v$latch_children where name like '%row%cache%objec%'  order by gets , misses

select distinct s.kqrstcln latch#,r.cache#,r.parameter name,r.type,r.subordinate#
from v$rowcache r,x$kqrst s
where r.cache#=s.kqrstcid
order by 1,4,5


select parameter, gets from v$rowcache order by gets desc
