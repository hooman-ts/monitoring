#!/bin/bash
BACKEND_HOSTS="127.0.0.1 192.168.1.1"
TMP_LOCATION=/tmp/NEW_MASTERDB
DST_CONF=/tmp/db
OLDMASTER_ID=1
repmgr standby promote -f /etc/repmgr/repmgr.conf --log-to-file
repmgr primary unregister --node-id $OLDMASTER_ID

NEW_DB=$(psql -d repmgr -U postgres -t -A -c "SELECT conninfo FROM repmgr.nodes WHERE active = TRUE AND type='primary'" | awk '{print $1}' | cut -d '=' -f 2)
for HOST in $BACKEND_HOSTS
do
    # Recreate the pgbouncer config file

echo "DBHOST=$NEW_DB" > /tmp/NEW_MASTERDB
echo "DBHOST=$NEW_DB"
    echo rsync $TMP_LOCATION $HOST:$DST_CONF

done
echo rm $TMP_LOCATION

echo "Reconfiguration complete"


