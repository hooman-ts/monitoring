   SELECT /*+ ordered */ UNIQUE
          h1.inst_id inst_id,
          h1.username bekleten_user,
          h1.sid bekleten_sid,
          w1.username bekleyen_user,
          w1.sid bekleyen_sid,
          w.kgllktype lock_mode,
          w.kgllkhdl address,
          DECODE (h.kgllkmod,
             0, 'None',
             1, 'Null',
             2, 'Share',
             3, 'Exclusive',
             'Unknown')
             mode_held,
          DECODE (w.kgllkreq,
             0, 'None',
             1, 'Null',
             2, 'Share',
             3, 'Exclusive',
             'Unknown')
             mode_requested,
          od.to_name object_name,
          h1.osuser os_user,
          h1.machine machine,
             'alter system kill session '''
          || h1.sid
          || ','
          || h1.serial#
          || ''';'
             kill_komut
   FROM dba_kgllock w,
        dba_kgllock h,
        gv$session w1,
        gv$session h1,
        gv$object_dependency od
   WHERE ( (h.kgllkmod NOT IN (0, 1) AND h.kgllkreq IN (0, 1))
          AND (w.kgllkmod IN (0, 1) AND w.kgllkreq NOT IN (0, 1)))
         AND w.kgllktype = h.kgllktype
         AND w.kgllkhdl = h.kgllkhdl
         AND w.kgllkuse = w1.saddr
         AND h.kgllkuse = h1.saddr
         AND od.to_address(+) = w.kgllkhdl;