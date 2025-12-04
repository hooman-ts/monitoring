--SYS USER ILE YAPILMALI

select * from v$parameter where name like '%commit%' ;

select 'COMMIT FORCE '''||p.local_tran_id ||''';' ,p.* from dba_2pc_pending p;


select ' execute DBMS_TRANSACTION.PURGE_LOST_DB_ENTRY('''||p.local_tran_id ||''');' ,p.* from dba_2pc_pending p;

 
SELECT * FROM DBA_2PC_NEIGHBORS ;

select addr, kaddr, sid, type, id1 from v$lock where type = 'DX';
 
select * from sys.link$ ;


COMMIT FORCE '1.13.5197';

ROLLBACK FORCE '1158.17.865029'; 

alter session set "_smu_debug_mode" = 4;
begin
sys.DBMS_TRANSACTION.PURGE_LOST_DB_ENTRY('814.4.60942');
sys.DBMS_TRANSACTION.PURGE_LOST_DB_ENTRY('2263.24.308');
sys.DBMS_TRANSACTION.PURGE_LOST_DB_ENTRY('2280.40.1812');
commit;
end;
/


-- as sys
--To find out the list of active transactions in that rollback segment, use:
SELECT KTUXEUSN, KTUXESLT, KTUXESQN, /* Transaction ID */ KTUXESTA Status,
      KTUXECFL Flags FROM x$ktuxe WHERE ktuxesta!='INACTIVE'
      AND ktuxeusn= 1;
      

delete from sys.pending_trans$ where local_tran_id = '57.15.891774';

delete from sys.pending_sessions$ where local_tran_id = '57.15.891774';

delete from sys.pending_sub_sessions$ where local_tran_id = '57.15.891774';

commit;


ALTER SYSTEM DISABLE DISTRIBUTED RECOVERY;

INSERT INTO pending_trans$
(
    local_tran_id,
    global_tran_fmt,
    global_oracle_id,
    state,
    status,
    session_vector,
    reco_vector,
    type#,
    fail_time,
    reco_time
)
VALUES (
          '57.15.891774',         /* <== Replace this with your local tran id */
                       306206,                                           /* */
                              'XXXXXXX.12345.1.2.3', /* These values can be used without any */
                                                    'prepared', 'P', /* modification. Most of the values are */
          HEXTORAW ('00000001'),                               /* constant. */
                                HEXTORAW ('00000000'
          ),                                                             /* */
            0, SYSDATE, SYSDATE
       );

INSERT INTO pending_sessions$
VALUES (
          '57.15.891774',     /* <==Replace only this with your local tran id */
                       1, HEXTORAW ('05004F003A1500000104'), 'C', 0,
          30258592, '', 146
       );

COMMIT;


COMMIR/ROLLBACK FORCE '57.15.891774';


alter system enable distributed recovery;



exec dbms_transaction.purge_lost_db_entry('57.15.891774');