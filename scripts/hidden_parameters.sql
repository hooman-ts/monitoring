select a.ksppinm name,
b.ksppstvl value,
b.ksppstdf deflt,
decode
(a.ksppity, 1,
'boolean', 2,
'string', 3,
'number', 4,
'file', a.ksppity) type,
a.ksppdesc description
from
sys.x$ksppi a,
sys.x$ksppcv b
where
a.indx = b.indx
and
a.ksppinm like '%predicate%'
order by
name


    execute immediate 'alter session set "optimizer_index_cost_adj"=1';
      execute immediate 'alter session set "_push_join_union_view"=false';
      execute immediate 'alter session set "_complex_view_merging"=false';