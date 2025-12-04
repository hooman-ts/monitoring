
SELECT child# "cCHILD",
       addr "sADDR",
       gets "sGETS",
       misses "sMISSES",
       sleeps "sSLEEPS"
FROM v$latch_children
WHERE name = 'cache buffers chains'
ORDER BY 5 DESC, 1, 2, 3;

SELECT                                                             /*+ RULE */
      e.owner || '.' || e.segment_name segment_name,
       e.extent_id extent#,
       x.dbablk - e.block_id + 1 block#,
       x.tch,
       l.child#
FROM sys.v$latch_children l, sys.x$bh x, sys.dba_extents e
WHERE     e.file_id = x.file#
      AND x.hladdr = l.addr
      AND x.hladdr = '0000040B4211BC08'
      AND x.dbablk BETWEEN e.block_id AND e.block_id + e.blocks - 1
ORDER BY x.tch DESC;




-- to find latches that are the results from the 
-- "cache buffers chains" you can change that part 
select * from ( 
select addr, sleeps from v$latch_children 
where name = 'cache buffers chains' 
order by sleeps desc 
) 
 where rownum > 0 
; 


-- which latch belong to what object 
select D.OBJECT_NAME, D.OWNER, X.ts#, X.file#, X.dbarfil, X.dbablk, X.obj, X.class, X.state, X.tch 
from x$bh X ,dba_objects D
    where hladdr = '596F9048'                  -- ADDR is given from the above query 
      and  D.data_object_id = X.obj  
        order by tch desc;


