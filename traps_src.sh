# Monitoring SIGNALS . Should be sourced into idle.sh & dbusmonitoir.sh
#######################################################################
# For "worklog" version (1.12c) and above
#
#trap shell_aliasses_signal SIGTERM SIGKILL  #https://linuxhint.com/bash_trap_command/ but $1 is empty. It can't work.

shell_interrupt_signal()
{  #ctrl-C
   ${WORKLOG}wlog.sh "SIGNAL!" "Używający 'aliases.sh' program $0:$$ otrzymał sygnał INT" >> ${HOME}/aliases.out
}

shell_stop_signal()
{  #ctrl-Z
   ${WORKLOG}wlog.sh "SIGNAL!" "Używający 'aliases.sh' program $0:$$ otrzymał sygnał STOP" >> ${HOME}/aliases.out
}


#define a trap for some others signals

shell_finishing_signal() {
   ${WORKLOG}wlog.sh "SIGNAL!!" "Używający 'aliases.sh' program $0:$$ otrzymał kończący sygnał $1" >> ${HOME}/aliases.out
   exit
}

shell_any_signal() {
   ${WORKLOG}wlog.sh "SIGNAL!!" "Używający 'aliases.sh' program $0:$$ otrzymał sygnał $1" >> ${HOME}/aliases.out
}

trap_with_arg() {
    func="$1" ; shift
    for sig ; do
        #echo "$0:$$:trap" "$func $sig" "$sig" 						>> ${HOME}/aliases.out
        trap "$func $sig" "$sig"						        >> ${HOME}/aliases.out
    done
}

trap shell_stop_signal STOP
trap shell_interrupt_signal INT
trap_with_arg shell_finishing_signal TERM KILL HUP
trap_with_arg shell_any_signal USR1 USR2
#https://stackoverflow.com/questions/2175647/is-it-possible-to-detect-which-trap-signal-in-bash
