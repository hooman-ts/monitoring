DECLARE
  X NUMBER;
BEGIN
  SYS.DBMS_JOB.SUBMIT
    ( job       => X 
     ,what      => 'BEGIN 
DBMS_STATS.GATHER_DATABASE_STATS(method_opt=>''FOR ALL COLUMNS SIZE 1'', DEGREE=>2, options=>''GATHER AUTO'', CASCADE=>TRUE); 
END;
'
     ,next_date => to_date('19.04.2008 11:16:41','dd/mm/yyyy hh24:mi:ss')
     ,interval  => 'SYSDATE+1'
     ,no_parse  => TRUE
     ,instance  => 1
     ,force     => TRUE
    );
  SYS.DBMS_OUTPUT.PUT_LINE('Job Number is: ' || to_char(x));
END;
/