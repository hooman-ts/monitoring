psql 
exit
create user -s repmgr
createuser -s repmgr;
createdb repmgr -O repmgr;
ALTER USER repmgr SET search_path TO repmgr, "$user", public;
psql 
createuser --interactive joe
createuser --help
createuser -s repmgr
createdb repmgr -O repmgr
psql
ls
exit
cd /etc/repmgr/
cd 13/
/usr/pgsql-13/bin/repmgr -f /etc/repmgr/13/repmgr.conf primary register
vim repmgr.conf
/usr/pgsql-13/bin/repmgr -f /etc/repmgr/13/repmgr.conf primary register
vim repmgr.conf
/usr/pgsql-13/bin/repmgr -f /etc/repmgr/13/repmgr.conf primary register
exit
cd /etc/repmgr/13/
vim repmgr.conf
exit
psql 
cd /etc/repmgr/13/
/usr/pgsql-13/bin/repmgr -f /etc/repmgr/13/repmgr.conf primary register
/usr/pgsql-13/bin/repmgr -f /etc/repmgr/13/repmgr.conf cluster show
psql 
/usr/pgsql-13/bin/repmgr -f /etc/repmgr/13/repmgr.conf cluster show
vim repmgr.conf
grep name repmgr.conf
psql
cat repmgr.conf
exit
psql 
exit
cd /etc/repmgr/13/
vi repmgr.conf
exit
psq
psql 
exit
cd /etc/repmgr/
ls
cd 13/
cat repmgr.conf
/usr/pgsql-13/bin/repmgr  -h node2 -U repmgr -d repmgr standby follow -f  /etc/repmgr/13/repmgr.conf
/usr/pgsql-13/bin/repmgr  -h node2 -U repmgr -d repmgr standby promote -f  /etc/repmgr/13/repmgr.conf
exit
/usr/pgsql-13/bin/repmgr -f /etc/repmgr/13/repmgr.conf cluster events
/usr/pgsql-13/bin/repmgr -f /etc/repmgr/13/repmgr.conf cluster show
exit
ls
vim repmgr.conf
exit
/usr/pgsql-13/bin/repmgr -f /etc/repmgr/13/repmgr.conf cluster events
/usr/pgsql-13/bin/repmgr -f /etc/repmgr/13/repmgr.conf cluster show
cd /etc/repmgr/13/
vim repmgr.conf
/usr/pgsql-13/bin/repmgr standby follow -f /etc/repmgr/13/repmgr.conf --upstream-node-id=%n
/usr/pgsql-13/bin/repmgr standby follow -f /etc/repmgr/13/repmgr.conf --upstream-node-id=1
vim repmgr.conf
exit
sl
ls
exit
