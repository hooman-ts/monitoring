CREATE OR REPLACE TRIGGER audit_emp_values
AFTER DELETE OR INSERT OR UPDATE ON employees
FOR EACH ROW
BEGIN
INSERT INTO audit_emp(user_name, time_stamp, 
old_first_name, new_first_name,old_last_name, new_last_name,old_salary, new_salary, id)
VALUES (USER, SYSDATE, 
:OLD.first_name, :NEW.first_name,:OLD.last_name, :NEW.last_name,:OLD.salary, :NEW.salary, :OLD.employee_id);
END;
/

CREATE TABLE AUDIT_EMP
(
  USER_NAME       VARCHAR2(10 BYTE),
  TIME_STAMP      DATE,
  ID              NUMBER(5),
  OLD_LAST_NAME   VARCHAR2(10 BYTE),
  NEW_LAST_NAME   VARCHAR2(10 BYTE),
  OLD_SALARY      NUMBER(5),
  NEW_SALARY      NUMBER(5),
  OLD_FIRST_NAME  VARCHAR2(20 BYTE),
  NEW_FIRST_NAME  VARCHAR2(20 BYTE)
);


select * from audit_emp;

select * from employees;

update employees 
set last_name='ozturk', salary=3500
where employee_id=199;


delete from employees
where employee_id=202;

