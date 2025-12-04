select l.*, s.*
  from gv$session_longops l, gv$session s
  where l.sid=s.sid  and l.serial#=s.serial# and l.inst_id=s.inst_id 
    and time_remaining >= 0
   -- and opname not in ('Table Scan')
  order by start_time desc, time_remaining desc;
