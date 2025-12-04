-- cluster da bekleyen sqlid yi kullan.

select * from gv$sql s where s.sql_id='3kzca85t6pj0m'

-- bu sqlid hangi objede çalýþýyor onu bul

select count(*),event,CURRENT_OBJ# from gv$active_session_history where sql_id='3kzca85t6pj0m' and sample_time > sysdate-1/24 group by event,CURRENT_OBJ# order by 1 desc

-- bu obje üzerinde sorunlu 1 nolu instance dýþýnda kimler son 2 saat içinde çalýþmýþlar ona bak.

select count(*),sql_id from gv$active_session_history where CURRENT_OBJ# =98114 and sample_time > sysdate-2/24 and inst_id <> 1 
group by sql_id order by 1 desc


124453

98114

select * from v$sql where sql_id='2hj68rxhj8dfk'


-- Cluster da bekleyen obje id
select count(*),current_obj# from cardlive_18_08_2014 where wait_class='Cluster' group by current_obj# order by 1 desc

-- Maille gelen bilgi ile tutarlý mý kontrol et.
select object_id from dba_objects where object_name='CRD_CARD';

-- neden olan sql i bul.
select count(*),sql_id,event from  cardlive_18_08_2014 where current_obj#=98114 group by sql_id,event order by 1 desc;
