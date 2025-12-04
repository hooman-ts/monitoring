/* Formatted on 28.05.2012 16:32:48 (QP5 v5.115.810.9015) */
SELECT COUNT (1) logins_by_row,
       SUM (COUNT ( * ))
          OVER (PARTITION BY TO_CHAR (s.logon_time, 'YYYYMMDD HH24:MI'))
          logins_by_minute,
       TO_CHAR (s.logon_time, 'YYYYMMDD HH24:MI') MIN,
       machine,
       username
FROM v$session s
where username = 'SHAP'
GROUP BY TO_CHAR (s.logon_time, 'YYYYMMDD HH24:MI'), machine, username
ORDER BY 3 DESC;