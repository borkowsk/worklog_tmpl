#!/bin/bash
#Skrypt sprawdzania zawartosci logu wykonanej pracy (version 1.25 or above)
################################################################################

[ -z "$WORKLOG" ]  && echo "WORKLOG not set!"  && exit
[ -z "$WLOGFILE" ] && echo "WLOGFILE not set!" && exit
#WLOGFILE=${WORKLOG}"$(whoami)-$(hostname).log"

if [ -f $WLOGFILE ]; then
   echo "Last $1 lines from $WLOGFILE : "
   head -2 $WLOGFILE
   tail $1 $WLOGFILE
   pushd ${WORKLOG} > /dev/null
   git status
   popd > /dev/null
else
   echo "LOGFILE $WLOGFILE need to be created!"
fi
