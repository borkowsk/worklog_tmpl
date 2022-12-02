# "worklog" main file.
export WORKLOG_VERSION="(1.25)" #  version (1.24) or above
################################################################################
# This file should be sourced in .profile and .bashrc
#
# Prerequisites:
#################
#
# git!!!
# sudo apt install sysstat 		#for wcpu() to work
# sudo apt install xprintidle          #for idle time monitoring
# sudo apt install linuxlogo		#for startup


# SETUP MAIN WORKLOG VARIABLES
###########################################
if [[ -z "$WORKLOG" ]]
then
        WORKLOG="${HOME}/.worklog/"
        WLOGFILE=${WORKLOG}"$(whoami)-$(hostname).log"
        WALIOUT=${HOME}/aliases.out
        export WORKLOG
        export WLOGFILE
        export WALIOUT
        
        echo -e "\n" "WORKLOG was not set" >> $WALIOUT
        echo "Now is setting into..." "$WORKLOG" >> $WALIOUT
else
        if [ -z "$WALIOUT" ]
        then
          WALIOUT=${HOME}/aliases.out
          export WALIOUT
          echo "See debug output of worklog in $WALIOUT"
        fi       
        
        if [ -z "$WLOGFILE" ]
        then
          WLOGFILE=${WORKLOG}"$(whoami)-$(hostname).log"
          export WLOGFILE
          echo "See WLOGFILE of worklog in $WLOGFILE"
        fi
        
        echo "Variable WORKLOG is already set into $WORKLOG"  >> $WALIOUT
fi

if [[ $UNDERWINDOWS = true ]]
then
  if [[ -f "/c/Program Files/Notepad++/notepad++.exe" ]]
  then
	EDIT="/c/Program Files/Notepad++/notepad++.exe"
  else
	EDIT='notepad.exe'
  fi
else
	EDIT='gedit'
fi

# LOAD COLORS
##############
source ${WORKLOG}screen.ini

#  find_up function
####################
#https://unix.stackexchange.com/questions/6463/find-searching-in-parent-directories-instead-of-subdirectories

find_up () {
  path=$(pwd)
  while [[ "$path" != "" && ! -e "$path/$1" ]]; do
    path=${path%/*}
  done
  echo "$path"
}

export -f find_up

# "worklog" specific aliases
#############################

alias edit='"$EDIT"'

alias log='${WORKLOG}wlog.sh'
alias wlog='${WORKLOG}wlog.sh'
alias lw='${WORKLOG}lworks.sh'
alias works='${WORKLOG}lworks.sh'
alias wsearch=wgrep

alias wfinish='${WORKLOG}wfinish.sh' #finishing current log file
                                     #(eg. for the end of week or month)
                                     
alias rgit='"$DEFGIT"'
alias git='${WORKLOG}wgit.sh'   
alias wgit='${WORKLOG}wgit.sh'
alias gits='"$DEFGIT" status'	      #Status of current git directory
alias gs='"$DEFGIT" status'          #remove it, if you use GhostScript !!!


# "worklog" specific functions
###############################

whelp() {
  $ECHO $COLOR1"Available functions and aliases"$NORMCO 
  declare -F | grep -v "_" | cut --delimiter=' ' --field=3
  alias | grep -v "_" | cut --delimiter=' ' --field=2- | egrep "=" --color 
}

wgrep() {
  $ECHO $COLOR1"Past log entries"
  $ECHO $COLOR2"=-=-=-=-=-=-=-=-=-="$NORMCO
  echo
  $ECHO $COLOR2"grep"$COLOR1 --no-filename $1 $2 $3 $4 $5 $6 $7 $8 $9 '<all-log-files>'$NORMCO
  echo
  grep --no-filename $1 $2 $3 $4 $5 $6 $7 $8 $9 ${WORKLOG}oldlogs/*.log ${WORKLOG}*.log
}

wps() {
  ps -aux | grep -v "grep" | grep -E "(idle.sh|dbusmonitor.sh)" 
}

wcpu() {
  $ECHO $COLOR1"Current CPU load"$NORMCO
  CPUUSE=`mpstat 1 1 | awk '$12 ~ /[0-9.]+/ { print 100 - $12"%" }' | tail -1`
  ${WORKLOG}wlog.sh "CPU\t" $CPUUSE "\t$*"
}

wsudo() {
   #logging sudo actions privately for the user, additional to /var/log/auth.log
   echo -e $COLOR1"sudo"$NORMCO $@
   sudo $@
   [ $? -eq 0 ] && ${WORKLOG}wlog.sh "SUDO\t" $@
}

widle() {
 if [[ -f "${WORKLOG}idle.out" ]]
  then
   FROM=`head -1 ${WORKLOG}idle.out | cut "--delimiter= "  --field=1`
   TO=`tail -1 ${WORKLOG}idle.out | cut "--delimiter= "  --field=1`
   threshold=`head -1 ${WORKLOG}idle.out | cut "--delimiter= "  --field=2`
   echo -e $COLOR1"IDLE TIME" $COLOR2"\nLINES:"$NORMCO `wc -l ${WORKLOG}idle.out` $COLOR2"\nTRESHOLD: <= "$NORMCO "$threshold" \
           "\nFROM:" "$FROM" "\nTO:  " "$TO" 
  else
   echo 0
  fi
}

wpwd() {
  #WE LOG IN INFORMATION ABOUT THE CURRENT DIRECTORY
  ${WORKLOG}wlog.sh "DIR\t" `pwd` $@
}

#DO SPRAWDZENIA: https://askubuntu.com/questions/16106/how-can-i-create-an-alias-for-cd-and-ls
#wcd() { #TO NIE MOŻE ZADZIAŁAĆ BO FUNKCJA MA WŁASNY KATALOG ROBOCZY!!!
  #JUMP TO THE CATALOG WITH THE POSSIBILITY OF RETURN
#  wlog "CDIR" `pushd $1` 
#  pwd
#}

#wret() { #... W ZWIĄZKU Z POWYŻSZYM TO TEŻ NIE MA SENSU
#  #RETURN TO THE STACKED DIRECTORY
#  wlog "DRETURN" `popd`
#}

wdiff() {
  #we check the changes saved in the worklog since the last commit
  pushd ${WORKLOG} > /dev/null
  "$DEFGIT" diff $WLOGFILE
  popd > /dev/null
}

wcommit() {
  #comming what was new in the log
  # mostly used automatically when closing a terminal
  pushd ${WORKLOG} > /dev/null
  "$DEFGIT" commit $WLOGFILE -m `date -Is` > .lastgit.err 2>&1
  if [ $? -eq 0 ]
  then
	echo "Changes commited to $WLOGFILE"  >> ${HOME}/aliases.out
	${WORKLOG}wlog.sh "Changes commited to $WLOGFILE"  
  else
    echo -e $COLOR2"COMMIT FAILED!"$NORMCO
  fi
  popd > /dev/null
}

wsave() {
  #sync with the git server 
  #This needs to be run sometimes :-)
  pushd ${WORKLOG} > /dev/null
  wcommit
  
  "$DEFGIT" push 
  if [ $? -eq 0 ]
  then
	echo "Changes pushed to git server!"
  else
    echo -e $COLOR2"PUSH FAILED!"$NORMCO
  fi
  popd > /dev/null
}


wupdate() {
  pushd ${WORKLOG} > /dev/null
  
  "$DEFGIT" add *.log >> ${HOME}/aliases.out
  
  wcommit
  if [ $? != 0 ]
  then
	return -1
  fi
  
  "$DEFGIT" pull
  if [ $? -eq 0 ]
  then
	echo "consider to use 'wsave' also!"
  else
    echo -e $COLOR2"PULL FAILED!"$NORMCO
  fi
  
  popd > /dev/null
}

wsync() {
  wupdate && wsave
}

wedit() {
  wcommit
  "$EDIT" $WLOGFILE &
  wait
  [ $? -eq 0 ] && log "Edited\tlog"
}


# Functions that log the use of more important commands
########################################################

mail() {
  #Logowane wejście do maila
  ${WORKLOG}wlog.sh "MAIL\t" "START" $@
  thunderbird $@ 1> ${WORKLOG}0mail.err 2>&1
  ${WORKLOG}wlog.sh "MAIL\t" "STOP\t" $?        $@
}
  
# Definiować tylko gdy jest program zainstalowany? TODO!
ssh() {
  #logowane użycie ssh
  ${WORKLOG}wlog.sh  "SSH\t" "START" $@
  /usr/bin/ssh $@
  [ $? -eq 0 ] && ${WORKLOG}wlog.sh  "SSH\t" "STOP"     $@
}

# Definiować tylko gdy jest program zainstalowany? TODO!
qt() {
  #logowane użycie qtcreatora
  ${WORKLOG}wlog.sh "QtCreator\t" "START" $@
  [ $? -eq 0 ] && qtcreator $@  1> ${WORKLOG}0qtcreator.err 2>&1
  ${WORKLOG}wlog.sh "QtCreator\t" $? "FIN OK\t"  $?       $@
  echo -e "$COLERR"
  [ -s ${WORKLOG}0qtcreator.err ] && cat ${WORKLOG}0qtcreator.err
  echo -e "$NORMCO"
}

# Definiować tylko gdy jest program zainstalowany? TODO!
cl() {
  #logowane użycie CLion IDE
  ${WORKLOG}wlog.sh "CLion\t" "START" $@
  clion $@  1> ${WORKLOG}0clion.err 2>&1
  [ $? -eq 0 ] && ${WORKLOG}wlog.sh "CLion\t" $? "FIN OK\t"  $?   $@
  echo -e "$COLERR"
  [ -s ${WORKLOG}0clion.err ] && cat ${WORKLOG}0clion.err
  echo -e "$NORMCO"
}

# Definiować tylko gdy jest program zainstalowany? TODO!
nv() {
  #logowane użycie nsight (IDE for CUDA)
  ${WORKLOG}wlog.sh "NSight\t" "START" $@
  nsight $@  1> ${WORKLOG}0nsight.err 2>&1
  [ $? -eq 0 ] && ${WORKLOG}wlog.sh "NSight\t" "FIN OK\t"  $?       $@
  echo -e "$COLERR"
  [ -s ${WORKLOG}0nsight.err ] && cat ${WORKLOG}0nsight.err
  echo -e "$NORMCO"
}

# Definiować tylko gdy jest zmienna PRIDE? TODO!
pr() {
  #logowane użycie Processing (IDE)
  ${WORKLOG}wlog.sh "Processing\t" "START\t" "$PWD\t" "$@" *.pde
  ${PRIDE} $@ *.pde 1> ${WORKLOG}0pr.err 2>&1
  # 1> ${WORKLOG}0Processing.err 2>&1
  #OCZEKIWANIE NA IDE PROCESSINGU NIE DZIAŁA. "Odkleja się" od procesu wywyłującego (?)
  #wait
  [ $? -eq 0 ] && ${WORKLOG}wlog.sh "Processing\t" "FIN OK\t" $@
  echo -e "$COLERR"
  [ -s ${WORKLOG}0pr.err ] && cat ${WORKLOG}0pr.err
  echo -e "$NORMCO"
}

# Definiować tylko gdy jest zmienna P2Cscr? TODO!
pr2c() {
  #logowana translacja projektu Processingu na C++
  ${WORKLOG}wlog.sh "Proc2C++\t" "START\t" $@ *.pde
  ${P2Cscr}/makeCPPproject.sh 1> ${WORKLOG}0pr2c.err 2>&1
  [ $? -eq 0 ] && ${WORKLOG}wlog.sh "Proc2C++\t" "FIN OK\t" $@
  echo -e "$COLERR"
  [ -s ${WORKLOG}0pr2c.err ] && cat ${WORKLOG}0pr2c.err
  echo -e "$NORMCO"
}

# Definiować tylko gdy jest program zainstalowany? TODO!
ked() { 
  #logowane użycie kwrite
  nohup kwrite "$@" 1> ${WORKLOG}0kwrite.err 2>&1  &
  [ $? -eq 0 ] && ${WORKLOG}wlog.sh "EDIT\t" "nohup kwrite" $@
}

# Definiować tylko gdy jest program zainstalowany? TODO!
ged(){ 
  #logowane użycie gedit
  nohup gedit "$@"  1> ${WORKLOG}0gedit.err 2>&1  &
  [ $? -eq 0 ] && ${WORKLOG}wlog.sh "EDIT\t" "nohup gedit" $@
}

# Definiować tylko gdy jest któryś program zainstalowany? TODO!
#alias kq='nohup konqueror ./ &>> ~/.konqueror.err &'
#alias na='nohup nautilus ./ --no-desktop &>> ~/.nautilus.err &'
fm() {
  #logowanie file menagera
  ${WORKLOG}wlog.sh "FM\t" "used" $@
  nohup nautilus $@ --no-desktop &>> ${WORKLOG}0nautilus.err &
  [ $? -eq 0 ] && ${WORKLOG}wlog.sh "DIR\t" "nohup nautilus" $@
}

# User specific aliases
##########################################

alias l='ls -CF'
alias ll='ls -alF'
alias la='ls -A'
alias lt='ls -lt'
alias cs='cd ..;ls'

alias rm='rm -i'

# IBM like
alias home='cd ~/;ls'
alias move='mv'
alias dir='ls -l'
alias del='rm'
alias copy='cp'

alias hg='history | grep'
alias quit='exit'

# Initial and final operations
####################################

if [[ "$FIRSTSET" = "yes" ]]
then
 mv ${HOME}/aliases.out ${HOME}/aliases.out.bak
 echo -e "\n" "$0" `date` "$WORKLOG_VERSION" "FIRSTSET =" $FIRSTSET             > ${HOME}/aliases.out
 
 #Nie ma pozostałości po poprzednim uruchomieniu?
 wps                                                                            >> ${HOME}/aliases.out
 
 cat ${HOME}/aliases.out && echo -e  $COLERR"\nUPS! wps should report nothing!\n"$NORMCO

 #dla pewności, gdyby zamknięcie poprzedniej sesji nie było OK
 #echo -e "\nCurrent state of the previous work registration:\n"                >> ${HOME}/aliases.out
 #wdiff ; echo $? >> ${HOME}/aliases.out
 wcommit                                                                        >> ${HOME}/aliases.out

 ${WORKLOG}wlog.sh FIRST-SHELL START `tty` "$0" at `pwd`                        >> ${HOME}/aliases.out
else
 echo -e "\n" "$0" `date` "$WORKLOG_VERSION" "FIRSTSET =" $FIRSTSET             >> ${HOME}/aliases.out
 ${WORKLOG}wlog.sh "TERM\t" "START" `tty` "$0" at `pwd`                         >> ${HOME}/aliases.out
fi


if [[ "$FIRSTSET" = "yes" ]]
then
 echo "Parent shell initial actions:"                                           >> ${HOME}/aliases.out

 echo -e "\n" `date` >> "${WORKLOG}sleep.out"
 echo `date` > "${WORKLOG}active_session.out"

 #Skrypt zliczający minuty idle-time'u. Używa xdotool, więc zainstaluj jakby co!
 # sudo apt install xprintidle TODO?
 if [[ -f "/usr/bin/xprintidle" ]]
 then
	 echo IDLE `xprintidle` 						   >> ${HOME}/aliases.out
	 "${WORKLOG}idle.sh" &
	 IDLEMONPID=$!
	 sleep 1
 fi
	 
 #Skrypt nasłuchujący dbus. Ale co jak nie ma gnome?
 "${WORKLOG}dbusmonitor.sh" &
 DBUSMONPID=$!
 sleep 1

 echo "MAIN SHELL PID:" $$ "Subprocesses PIDs:" $IDLEMONPID $DBUSMONPID         >> ${HOME}/aliases.out
 
else

 if [[ -f "/usr/bin/linuxlogo" ]]
 then
	echo -e $NORMCO	
	linuxlogo
 else	
        echo -e $COLOR3
	uname -a #-vnr
        echo -e $NORMCO
 fi
 
 echo -e $COLOR1"\nThe 'worklog' scripts, version $WORKLOG_VERSION, are present."\
         $COLOR2"\nUse 'log' or 'wlog' for log events of your work." \
         "And 'whelp' for more.\n" $NORMCO
fi

# define EXIT functions:
#########################

shell_aliasses_finish() {
  #dzialania na koniec 
  echo -e "FINISHING" `tty` "$0" "IS FIRST?" "'" $FIRSTSET "'"                  >> ${HOME}/aliases.out #DEBUG

  if [[ "$FIRSTSET" = "yes" ]]
  then
   #wlog "GŁÓWNY shell $0 jest kończony" >> ${HOME}/aliases.out #DEBUG ONLY
   ${WORKLOG}wlog.sh "Ending the main shell $0"                                 >> ${HOME}/aliases.out
   
   #rm -f "${WORKLOG}active_session.out"     #To też wyłączy idle.sh
   #sleep 11 #Daje szanse idle.sh na wykrycie braku pliku sesji i zakończenie pracy?
   kill -SIGHUP $IDLEMONPID 							   >> ${HOME}/aliases.out  #koniec pracy skryptu idle 
   kill -SIGHUP $DBUSMONPID 							   >> ${HOME}/aliases.out  #koniec pracy skryptu dbusmonitor
   sleep 1
   ${WORKLOG}wlog.sh FIRST-SHELL STOP `tty` "$0" at `pwd`                       >> ${HOME}/aliases.out
   wcommit >> ${HOME}/aliases.out #zapamiętanie zmian logu
   echo "THE END" `date`                                                        >> ${HOME}/aliases.out
   
  else
   #wlog "Podrzedny shell $0 jest kończony" >> ${HOME}/aliases.out #DEBUG ONLY
   ${WORKLOG}wlog.sh "TERM\t" "STOP" `tty` "$0" at `pwd`                        >> ${HOME}/aliases.out
   sleep 1 
   #echo "Bye from $0"; typeset -f 
  fi

  trap - EXIT
  exit
}

trap shell_aliasses_finish EXIT #TU NA PEWNO NIE MOŻE BYĆ "ERR"!!!

#source ${WORKLOG}traps_src.sh #A TO JUŻ NIEPOTRZEBNE?



