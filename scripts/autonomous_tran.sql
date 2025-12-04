DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  FOR i IN 3 .. 10 LOOP
    INSERT INTO dept
    VALUES (i, 'Dept ' || i);
     
  END LOOP;

   COMMIT;

END;
/

INSERT INTO dept
    VALUES (1, 'Dept ' || 1);
    

INSERT INTO dept
    VALUES (2, 'Dept ' || 2);
    --COMMIT;
    
    
select * from dept;

truncate table dept;

/*
Autonomous transactions can be used for logging in the database independent of the rollback/commit of the parent transaction. 
The autonomous transaction must commit or roll back before the autonomous transaction is ended and the parent transaction continues. 
*/