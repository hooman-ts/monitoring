select max(undoblks/((end_time-begin_time)*3600*24))
"UNDO_BLOCK_PER_SEC"
FROM v$undostat;