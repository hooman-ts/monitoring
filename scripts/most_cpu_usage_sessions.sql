-- sessions with highest CPU consumption
SELECT s.sid, s.serial#, p.spid as "OS PID",s.username, s.module, s.sql_id, st.value/100 as "CPU sec"
FROM v$sesstat st, v$statname sn, v$session s, v$process p
WHERE sn.name = 'CPU used by this session' -- CPU
AND st.statistic# = sn.statistic#
AND st.sid = s.sid
AND s.paddr = p.addr
AND s.last_call_et < 1800 -- active within last 1/2 hour
AND s.logon_time > (SYSDATE - 60/1440) -- sessions logged on within 4 hours
and st.value/100>250
ORDER BY st.value desc;


d0tma4p9u9fzb
14788vmjy0wr7
2gfvch0z72gyq
aau7wztcqc5pg
b1h0vthy7gq52
frzydxqkg8m4w