#!/bin/bash
#Skrypt logowania w logu wykonanej pracy (version 1.25 or above)
################################################################################

[ -z "$WORKLOG" ]  && echo "WORKLOG not set!"  && exit
[ -z "$WLOGFILE" ] && echo "WLOGFILE not set!" && exit

INFO=`find_up .PROJECT.WLOG.INFO`/.PROJECT.WLOG.INFO
#echo "DEBUG: INFO from " $INFO

if [ -f "$INFO" ]; then
    source "$INFO"
else
    Project="PR_Unknown"
    Workpackage="WP_Unknown"
fi

if [ -f $WLOGFILE ]; then
   echo -e $COLOR1"Logging work into ${COLOR2}${WLOGFILE}${COLOR1} : "${NORMCO}
else
   echo -e $COLOR1"Work LOGFILE $WLOGFILE will be created:"$NORMCO
   echo -e "#worklog version $WORKLOG_VERSION file $WLOGFILE created `date`"    > $WLOGFILE
   echo -e "TIMESTAMP______\tUSER____\tHOST_______\tProj\tWPack\tCATEG\tMORE INFO" >> $WLOGFILE
   pushd ${WORKLOG}
   "$DEFGIT" add $WLOGFILE
   popd
   echo -e $COLOR1'DONE'$NORMCO
fi

#Teraz tworzymy linie do zapisania
DATE="\"`date -Is`\""
WHOWHERE="$(whoami)\t$(hostname)"
echo -e "$DATE\t$WHOWHERE\t$Project\t$Workpackage\t" $* >> $WLOGFILE 

if [ $? != 0 ] #Ale czy ten zapis może się nie powieść?
then
 echo -e ${COLOR2}"Writing to $WLOGFILE failed.${NORMCO}"\ 
         "Exit code: $COLOR1" $? ${NORMCO}
 exit 
fi

#jak się udało to podgladamy co faktycznie zapisaliśmy
tail -1  $WLOGFILE


