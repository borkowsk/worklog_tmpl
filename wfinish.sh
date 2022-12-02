#!/bin/bash
#Skrypt kończący okres pracy (v. 1.25)
################################################################################
# Wymaga podania nazwy zamykanego okresu

[ -z "$WORKLOG" ] && echo "WORKLOG not set!" && exit
[ -z "$1" ] && echo "Name of period of time not find in parameter 1." && exit

pushd $WORKLOG

LOGF="$(whoami)-$(hostname).log"

echo -e $COLOR1"Finalising LOGF into$COLOR2 $1-$LOGF"$NORMCO

"$DEFGIT" pull && \
"$DEFGIT" mv $LOGF oldlogs/$1-$LOGF && \
"$DEFGIT" commit oldlogs/$1-$LOGF   && \
"$DEFGIT" push && \
./wlog.sh "FINALISED\t" "$1-$LOGF" && \
echo -e $COLOR1"OK"$NORMCO

popd > /dev/null
