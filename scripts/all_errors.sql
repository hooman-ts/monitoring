/* Formatted on 2010/05/31 16:09 (Formatter Plus v4.8.8) */
SELECT      line
         || '-'
         || POSITION
         || '=>'
         || SUBSTR (text, 1, 200)
         || CHR (13) AS err_line
    FROM SYS.all_errors
   WHERE owner = 'MARDATA'
     AND TYPE IN
            ('PACKAGE', 'PACKAGE BODY', 'PROCEDURE', 'FUNCTION', 'TRIGGER',
             'VIEW')
ORDER BY SEQUENCE