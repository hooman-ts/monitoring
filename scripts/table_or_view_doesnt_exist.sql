To turn on the event: from SQL*Plus (as 'pv_admin')
 
alter system set events '942 trace name errorstack level 3';
 
To turn off the event:
 
alter system set events '942 trace name errorstack off';