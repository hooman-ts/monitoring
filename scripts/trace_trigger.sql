
CREATE OR REPLACE TRIGGER vyg.logintriggerNFC
 AFTER LOGON
 ON "NFC".SCHEMA
declare
v_program   varchar2(512);
v_machine   varchar2(128);

begin
execute immediate 'ALTER SESSION SET tracefile_identifier=taliptrace';
execute immediate 'alter session set sql_trace=true' ;
end ;
/


alter trigger vyg.logintriggermdm disable;

drop trigger vyg.logintriggermdm;

CREATE OR REPLACE TRIGGER vyg.logintriggermdm
AFTER LOGON ON DATABASE
WHEN (
USER IN ('MDM')
      )
BEGIN
execute immediate 'ALTER SESSION SET tracefile_identifier=taliptrace';
execute immediate 'alter session set sql_trace=true' ;
END;
/

grant alter session to vyg;


CREATE OR REPLACE TRIGGER TALIP.LOGON_AUDIT_TRIGGER_NFC
AFTER LOGON ON DATABASE
WHEN (
USER IN ('NFC')
      )
BEGIN
execute immediate 'alter session set events ''10046 trace name context forever, level 12''';
EXCEPTION
WHEN OTHERS THEN
NULL;
END;
/

exec DBMS_MONITOR.SERV_MOD_ACT_TRACE_ENABLE (‘SRV1’);