SQL> alter system set events ‘sql_trace {process:2714|2936}’;
System altered.
SQL> alter system set events ‘sql_trace {process:2714|2936} off’;
System altered.
SQL>


SQL> connect / as sysdba
SQL> oradebug setospid <SPID>
SQL> oradebug unlimit
SQL> oradebug event 10046 trace name context forever,level 12

SQL> oradebug tracefile_name
SQL> oradebug event 10046 trace name context off



ALTER SESSION SET tracefile_identifier='MYTRACE';

ALTER SESSION SET EVENTS '10046 trace name context forever,level 12';

ALTER SESSION SET EVENTS '10046 trace name context off';



SQL> alter session set tracefile_identifier='10046'; 
SQL> alter session set timed_statistics = true; 
SQL> alter session set statistics_level=all; 
SQL> alter session set max_dump_file_size = unlimited; 
SQL> alter session set events '10046 trace name context forever,level 12'; 
--> execute the "add column here and let it running for 20 min" 
SQL> select * from dual; 
SQL> exit; 



exec DBMS_MONITOR.SERV_MOD_ACT_TRACE_ENABLE (‘SRV1’);