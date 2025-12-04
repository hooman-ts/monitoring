/* Formatted on 2007/04/20 14:05 (Formatter Plus v4.8.8) */
--The hot blocks due to latch contetion. 
--If the contatntion of the latches are from 'cache buffers chains'
--the following code will determine the blocks that cause tat contention 

--0 FREE no valid block image 
--1 XCUR a current mode block, exclusive to this instance 
--2 SCUR a current mode block, shared with other instances 
--3 CR  a consistent read (stale) block image 
--4 READ buffer is reserved for a block being read from disk 
--5 MREC a block in media recovery mode 
--6 IREC a block in instance (crash) recovery mode 

--The meaning of tch: tch is the touch count. 
--A high touch count indicates that the buffer is used often

SELECT object_name,
       file#, 
       dbablk,
       tch, 
       DECODE (GREATEST (CLASS, 10),
               10, DECODE (CLASS,
                           1, 'Data',
                           2, 'Sort',
                           4, 'Header',
                           TO_CHAR (CLASS)
                          ),
               'Rollback'
              ) CLASS,
       DECODE (state,
               0, 'free',
               1, 'xcur',
               2, 'scur',
               3, 'cr',
               4, 'read',
               5, 'mrec',
               6, 'irec',
               7, 'write',
               8, 'pi'
              ) state
  FROM (SELECT   *
            FROM x$bh x, dba_objects d
           WHERE hladdr IN (
                    SELECT addr
                      FROM v$latch_children
                     WHERE child# IN (
                              SELECT child#
                                FROM (SELECT   child#
                                          FROM v$latch_children
                                         WHERE NAME = 'cache buffers chains'
                                      ORDER BY misses DESC)
                               WHERE ROWNUM < 10))
             AND d.data_object_id = x.obj
        ORDER BY tch DESC);
