/* Formatted on 11/25/2019 3:27:39 PM (QP5 v5.287) */
set line 1000;
--Daily Log Switch
  SELECT TRUNC (First_Time) Day, COUNT (1) COUNT
    FROM v$log_history WHERE First_Time > SYSDATE-8
GROUP BY TRUNC (First_Time)
ORDER BY 1 DESC;

--Hourly Log Switch
  SELECT TO_CHAR (First_Time, 'YYYY-MM-DD HH24') HOUR, COUNT (1) COUNT
    FROM v$log_history WHERE First_Time > SYSDATE-8
GROUP BY TO_CHAR (First_Time, 'YYYY-MM-DD HH24')
ORDER BY 1 DESC;