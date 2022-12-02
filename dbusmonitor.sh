#!/bin/bash
#"worklog" gnome monitoring for version (1.25) and above
################################################################################
# Skrypt monitoruje gnome i zapisuje do logu uśpienia konsoli graficznej
# teoretycznie mógłby też inne zdarzenia
# UWAGA! Parametr --line-buffered dla grep'a z przykładu bywa krytyczny. 
# Bez niego magicznie nie działało. I trochę trwało zanim zajarzyłem dlaczego :-D

[ -z "$WORKLOG" ] && echo "$0 reported, WORKLOG not set!" && exit
[ -z "$HOME" ]    && echo "$0 reported, HOME not set!"    && exit
[ -z "$WALIOUT" ] && echo "$0 reported, WALIOUT not set!" && exit

_exit_report(){
  ${WORKLOG}wlog.sh "GDBUS" "monitoring terminated" "PID" $$                    >> ${HOME}/aliases.out
  trap - EXIT ERR
  exit
}

_err_report(){
  ${WORKLOG}wlog.sh "GDBUS" "monitoring error" "PID" $$                         >> ${HOME}/aliases.out
}

trap _exit_report EXIT
trap _err_report ERR

source ${WORKLOG}traps_src.sh

for_focal() { #cloned from for_bionic
  while read x; do
    case "$x" in 
      *"true"*) ${WORKLOG}wlog.sh "SCREEN\tLOCKED";;
      *"false"*) ${WORKLOG}wlog.sh "SCREEN\tUNLOCKED";;  
    esac
    echo -e "`date`\t$x"                                                        >> ${WORKLOG}sleep.out
  done
}

for_bionic() {
  while read x; do
    case "$x" in 
      *"true"*) ${WORKLOG}wlog.sh "SCREEN\tLOCKED";;
      *"false"*) ${WORKLOG}wlog.sh "SCREEN\tUNLOCKED";;  
    esac
    echo -e "`date`\t$x"                                                        >> ${WORKLOG}sleep.out
  done
}

for_xenial() {
  while read x; do
    case "$x" in 
      *"sleep"*) ${WORKLOG}wlog.sh "SCREEN\tSLEEP EVENT";;  
      *"key"*) ${WORKLOG}wlog.sh "SCREEN\tKEY";;
    esac
    echo -e "`date`\t$x"                                                        >> "${WORKLOG}sleep.out"
  done
}

#INACZEJ DZIAŁA NA UBUNTU 18.04 niż UBUNTU 16.04, a jak na 22.04 to dopiero trzeba sprawdzic

${WORKLOG}wlog.sh "GDBUS" "monitor $$ starting" "See ${WORKLOG}sleep.out"       >> ${HOME}/aliases.out

UBUNTUNAME=`lsb_release -sc`

if [[ "$UBUNTUNAME" == "xenial" ]]
then
 ${WORKLOG}wlog.sh "GDBUS" "For XENIAL UBUNTU 16.04"                            >> ${HOME}/aliases.out
 gdbus monitor -y -d org.freedesktop.login1 | for_xenial #| grep --line-buffered 'Manager'  
elif [[ "$UBUNTUNAME" == "bionic" ]]
then
 ${WORKLOG}wlog.sh "GDBUS" "For \"$UBUNTUNAME\""                                >> ${HOME}/aliases.out
 gdbus monitor -y -d org.freedesktop.login1 | grep --line-buffered 'LockedHint' | for_bionic 
elif [[ "$UBUNTUNAME" == "focal" ]]
then
 ${WORKLOG}wlog.sh "GDBUS" "For \"$UBUNTUNAME\""                                >> ${HOME}/aliases.out
 gdbus monitor -y -d org.freedesktop.login1 | grep --line-buffered 'LockedHint' | for_focal
else
  ${WORKLOG}wlog.sh "GDBUS" "not prepared for this UBUNTU distribution" \
                    "\"$UBUNTUNAME\""                                           >> ${HOME}/aliases.out
fi

#RESOURCES:
#https://unix.stackexchange.com/questions/28181/run-script-on-screen-lock-unlock !!!
#https://superuser.com/questions/662974/logging-lock-screen-events/662988
#https://vitux.com/three-ways-to-lock-your-ubuntu-screen/
#
#What about suspend???
#https://unix.stackexchange.com/questions/11498/how-to-trap-a-suspend-a-resume-from-a-bash-script
#https://askubuntu.com/questions/577862/how-to-temporarily-disable-sleep-and-hibernate-from-the-command-line/683962
#https://www.thegeekdiary.com/5-useful-command-examples-to-monitor-user-activity-under-linux/
#https://subscription.packtpub.com/book/networking_and_servers/9781785286421/4/ch04lvl1sec35/monitoring-user-activity-using-acct
#https://www.tutorialkart.com/bash-shell-scripting/bash-else-if/
#




