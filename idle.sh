#!/bin/bash
#"worklog" idle monitoring (for version 1.25 and above)
################################################################################
# https://stackoverflow.com/questions/222606/detecting-keyboard-mouse-activity-in-linux
# https://github.com/forsberg/kbdcounter
# sudo apt install xprintidle
# sudo apt install xdotool !!! currently not needed

[ -z "$WORKLOG" ] && echo "$0 reported, WORKLOG not set!" && exit
[ -z "$HOME" ]    && echo "$0 reported, HOME not set!"    && exit
[ -z "$WALIOUT" ] && echo "$0 reported, WALIOUT not set!" && exit

_err_report(){
  ${WORKLOG}wlog.sh "IDLE" "monitoring error" "PID" $$                          >> ${HOME}/aliases.out
}

_exit_report(){
  if [[ -f "${WORKLOG}idle.out" ]];then
   FROM=`head -1 ${WORKLOG}idle.out | cut "--delimiter= "  --field=1`           >> ${HOME}/aliases.out
   TO=`tail -1 ${WORKLOG}idle.out | cut "--delimiter= "  --field=1`             >> ${HOME}/aliases.out
   ${WORKLOG}wlog.sh "IDLE\t" "TRESHOLD" $threshold "LINES" `wc -l ${WORKLOG}idle.out`   \
                     "FROM:" "$FROM" "TO:" "$TO"                                >> ${HOME}/aliases.out
   mv -f "${WORKLOG}idle.out" "${FROM}-${TO}idle.out"                           >> ${HOME}/aliases.out
   ${WORKLOG}wlog.sh "IDLE\t" "calculated and terminated" "PID" $$              >> ${HOME}/aliases.out
  else
   ${WORKLOG}wlog.sh "IDLE\t" "monitoring terminated" "PID" $$                  >> ${HOME}/aliases.out
  fi

  trap - EXIT #ERR
  exit
}

#trap _err_report  ERR
trap _exit_report EXIT
source ${WORKLOG}traps_src.sh

${WORKLOG}wlog.sh "IDLE\t" "monitor $$ starting" "See ${WORKLOG}idle.out"       >> ${HOME}/aliases.out

while : ; do
    if [[ -f "${WORKLOG}active_session.out" ]];then
        #echo "Session active"
        idletime=$(xprintidle)						   >> ${HOME}/aliases.out
                          # 10sec = 10 * 1000 = 10000 #wymaga tez zmiany przy sleep!!!
        threshold=60000   # 1 min = 60 * 1000 = 60000
                          # 5 min = 5 * 60 * 1000 ms = 300000 #wymaga tez zmiany przy sleep!!!  
        if [[ "$idletime" -gt "$threshold" ]]; then
          #echo "idle" $idletime
          echo `date --iso-8601=s` "$idletime"          			   >> "${WORKLOG}idle.out"
          
          #Poniższe rozwiązanie uniemożliwia spontaniczne uruchamianie screen-locka
          #Trzeba zrobić inaczej - używając odejmowania (--> help LET) TODO
          #AKTUALNIE POWINNO BYC DOBRZE PRZY ROZDZIELCZOSCI 1 minuty (threshold=60000 sleep 60)
     	  #simulate activity reseting idle counter     
	  #xdotool mousemove_relative 1 1					   >> ${HOME}/aliases.out
        fi
    else
        exit #_exit_report() powinien się tu też wykonać
    fi
    sleep 60
done


