/* Formatted on 11/24/2019 2:24:06 PM (QP5 v5.287) */
set line 1000;
col name format a30;
  SELECT name,
         FLOOR (space_limit / 1024 / 1024) "Size MB",
         CEIL (space_used / 1024 / 1024) "Used MB",
         NUMBER_OF_FILES
    FROM v$recovery_file_dest
ORDER BY name;

