#!/bin/bash
FLOATIPADDRESS=172.25.72.131
FLOATINTERFACE=ens192
IsInterfaceUP="false"
PgIsMaster="false"
ThisIsMaster="false"
PsqlIsRunning="false"
ThisIsSlave="false"

function CheckifPgIsMaster(){
         runuser -l postgres -c " psql -c 'select pg_is_in_recovery();'" | grep f && PgIsMaster="true"
}

function CheckIsInterfaceUp(){
ifconfig $FLOATINTERFACE | grep $FLOATIPADDRESS && IsInterfaceUP="true"

}

function CheckIfPsqlIsRunning(){

systemctl is-active --quiet postgresql-13 && PsqlIsRunning="true"
}


function CheckThisIsMaster(){
if [ $PsqlIsRunning == "true" ] && [ $PgIsMaster == "true" ]
then

	ThisIsMaster="true"
fi


}



function setFloatIp(){
if [ $ThisIsMaster == "true" ]
then
        if  [ $IsInterfaceUP == "false" ]
        then
                echo interface is down
		ifup ens192
        fi

fi

}

function deleteFloatIp(){
if [ $PsqlIsRunning == "false" ]
then 
	ifdown ens192
fi


}

function manageFloatingIp(){

setFloatIp
deleteFloatIp
}


#systemctl is-active --quiet postgresql-13

CheckIfPsqlIsRunning
CheckifPgIsMaster
CheckIsInterfaceUp
CheckThisIsMaster
manageFloatingIp

echo "this server is master $ThisIsMaster"

