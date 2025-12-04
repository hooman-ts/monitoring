declare
v_tarih date := sysdate ;
v_count number :=0;
begin
for sfk in (select * from dba_constraints c where constraint_type='R' and c.table_name like 'BH%' )
loop
  for spk in (select * from dba_constraints cpk where cpk.constraint_name=sfk.r_constraint_name and cpk.owner=sfk.r_owner and cpk.constraint_type='P')
  loop
    for sindex in (select * from dba_ind_columns i where i.index_name=spk.constraint_name and i.table_name=spk.table_name)
    loop
      select count(*) into v_count from dba_ind_columns i where i.table_name=sfk.table_name and i.column_name=sindex.column_name and i.column_position= sindex.column_position ;
      if v_count=0 
      then      
        insert into vyg_fk_chk_log values(v_tarih,sfk.table_name,spk.table_name,sfk.constraint_name,spk.constraint_name,sindex.column_name) ;
        commit;
        exit;
      end if;   
    end loop ;
  end loop;
end loop ;
end; 
/

select * from dba_objects where object_name like 'DBA%CON%COL%' 

select * from DBA_CONS_COLUMNS where constraint_name='BH_HACIZ_BLK_HESAP_NO_FK'


CREATE TABLE talip.VYG_FK_CHK_LOG
(
  TARIH              DATE,
  CHILD_TABLE        VARCHAR2(250 BYTE),
  PARENT_TABLE       VARCHAR2(250 BYTE),
  FK_NAME            VARCHAR2(250 BYTE),
  PK_NAME            VARCHAR2(250 BYTE),
  INDEX_COLUMN_NAME  VARCHAR2(250 BYTE)
)
TABLESPACE NOLOG_TS