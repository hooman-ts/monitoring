SELECT client_name, status FROM dba_autotask_operation;

SELECT * FROM dba_autotask_schedule;

-- If you want to disable all the automated tasks, issue the following command:

EXEC dbms_auto_task_admin.disable;

EXEC dbms_auto_task_admin.enable;

EXEC dbms_auto_task_admin.disable( 'auto optimizer stats collection',
NULL, NULL );

EXEC dbms_auto_task_admin.enable( 'auto optimizer stats collection',
NULL, NULL );