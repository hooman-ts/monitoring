#!/bin/bash


PERR_SLAVE_NODE_ID=1
THIS_NODE_SHOULD_BE_MASTER=true
REJOIN_LOCK_FILE=/etc/repmgr/MUST_REJOINED



function STOP_OLD_MASTER(){

	#2,0,0 means node 2, is up and its not slave
        if [ $PEER_MODE_STATUS == "$PERR_SLAVE_NODE_ID,0,0" ]
        then
                echo "another node is master! then stopping postgresq on this node"
                systemctl stop postgresql-13
                echo systemctl stop postgresql-13
		#This server must rejoin then create lock file 
		#touch $REJOIN_LOCK_FILE
        fi



}


function CHECK_PEER_NODE_MODE(){

	PEER_MODE_STATUS=$(runuser -l postgres -c "repmgr cluster show --csv 2>/dev/null"|grep $PERR_SLAVE_NODE_ID)
	#echo  $PEER_MODE_STATUS
}



function FENCING(){
CHECK_PEER_NODE_MODE

if [ $THIS_NODE_SHOULD_BE_MASTER == true ]
then

	STOP_OLD_MASTER

fi
}

function auto_join_old_master(){
if test -f $REJOIN_LOCK_FILE; then
        echo $REJOIN_LOCK_FILE exists.
        echo removig lock file $REJOIN_LOCK_FILE
        rm -rf $REJOIN_LOCK_FILE
        echo rejoinig
	/etc/repmgr/scripts/rejoin.sh
fi
}

echo "repmonitoring started..."
while true
do
        sleep 5     
	systemctl is-active --quiet postgresql-13 && FENCING
	/etc/repmgr/scripts/managefloat.sh
	sleep 5
	#systemctl is-active --quiet postgresql-13 || auto_join_old_master
	

done
