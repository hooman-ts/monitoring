create or replace procedure maas_arttir(id number)
AUTHID CURRENT_USER is
begin 
update employees 
set salary=salary+salary*1/2
where employee_id=id;
commit;
end;
/


select * from employees
where employee_id=107;

exec maas_arttir(198);

grant execute on maas to ora105;


