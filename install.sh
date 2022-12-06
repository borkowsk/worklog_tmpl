#!/bin/bash
#"worklog"  monitoring (version 1.25b and above)
################################################################################
# Instalacja skryptów logowania pracy

if [ -z "$WORKLOG" ]
then
 echo "WORKLOG is not set"
 echo "Now is setting into..."
 WORKLOG="${HOME}/.worklog/"
 export WORKLOG
 source "$WORKLOG"screen.ini
 echo "..." "$WORKLOG"
else
 source "$WORKLOG"screen.ini
 $ECHO $COLOR1 "\nVariable WORKLOG is already set into $WORKLOG" $NORMCO
fi



$ECHO $COLOR1 "\nChecking for operating system..." $NORMCO
if [ -z "$WINDIR" ]
then
	UNDERWINDOWS=false
	echo "Not MS Windows, hopefully UBUNTU"
else
	UNDERWINDOWS=true
	echo "Windows?" $UNDERWINDOWS $OS $WINDIR 
fi

$ECHO $COLOR1  "\nChecking for GIT..."  $NORMCO
if [ $UNDERWINDOWS == true ]
then
	DEFGIT='/c/Program Files/Git/bin/git.exe'
else
	DEFGIT='/usr/bin/git'
fi

if [[ -f "$1" ]] 
then
	DEFGIT="$1"
fi

if [[ -f "$DEFGIT" ]]
then
	echo "GIT found in $DEFGIT"
else	
	echo "Git not found in $DEFGIT !!!"
	echo "This program is necessary for the installed utility to work."
	echo "If git is located somewhere other than the default,"
	echo "provide the path as a script parameter."
	exit -1 
fi

#exit #DEBUG

$ECHO $COLOR1  "\n\nChanging directory into:"  $NORMCO
pushd $WORKLOG
[ $? != 0  ] && echo -e "WORKLOG directory set wrongly?\n" \ 
                        "Should be hidden by initial dot! (.worklog) " && exit

#echo -e "\n\nUpdating from using git:"
#git pull 
#[ $? != 0  ] && echo "Not a git directory?" && exit

$ECHO $COLOR1  "\nmkdir oldlog" $NORMCO
mkdir -p oldlog

$ECHO $COLOR1  "\nModifications in .git/info/exclude" $NORMCO #rozszerzenia nieistotnych plików
grep "*~" .git/info/exclude 
[ $? != 0  ] && echo -e "\n*~" >> .git/info/exclude
grep "*.err" .git/info/exclude 
[ $? != 0  ] && echo -e "\n*.err" >> .git/info/exclude
grep "*.out" .git/info/exclude 
[ $? != 0  ] && echo -e "\n*.out" >> .git/info/exclude


if [ $UNDERWINDOWS == true ]
then #FOR WINDOWS git/bash
    $ECHO $COLOR1  "\n\nSpecific for Windows"  $NORMCO
    $ECHO $COLOR2"=================================="  $NORMCO
	echo 
	echo -e "\nModifications in $HOME/.bash_profile" #za'source'owanie aliases.sh
	echo -e "\n#'worklog tools' installation:" `date` >> "$HOME/.bash_profile"
        grep "UNDERWINDOWS" $HOME/.bash_profile
	[ $? != 0  ] && echo -e "\nUNDERWINDOWS=true\nexport UNDERWINDOWS"      >> "$HOME/.bash_profile"
	grep "$DEFGIT" $HOME/.bash_profile
	[ $? != 0  ] && echo -e "\nDEFGIT='$DEFGIT'\nexport DEFGIT"             >> "$HOME/.bash_profile"
	grep "aliases.sh" $HOME/.bash_profile
	[ $? != 0  ] && echo -e "\nsource ${WORKLOG}aliases.sh"                 >> "$HOME/.bash_profile"
	echo -e "\nCheck configuration below!\n"
	tail ".git/info/exclude" "$HOME/.bash_profile"      
	notepad ".git/info/exclude" &
	notepad "$HOME/.bash_profile" &
else #OTHER UNIX SYSTEMS WITH bash
    $ECHO $COLOR1 "\n\nUnder linux/unix like system"
    $ECHO $COLOR2"=================================="  $NORMCO
	#To WORKLOG mogłoby być rozwijane dopiero przy wykonaniu .profile, 
	# ale trzeba by to przetestować (TODO)
    $ECHO $COLOR1 "\nModifications in user .bashrc"  $NORMCO #za'source'owanie aliases.sh
	grep "aliases.sh" $HOME/.bashrc
	[ $? != 0  ] && echo -e "\nsource ${WORKLOG}aliases.sh\n"               >> $HOME/.bashrc
	
    $ECHO $COLOR1 "\nModifications in user .profile" $NORMCO #za'source'owanie aliases.sh
        echo -e "\n#'worklog tools' installation:" `date` >> "$HOME/.profile"
	grep "FIRSTSET=" $HOME/.profile
	[ $? != 0  ] && echo -e "\nFIRSTSET=\"yes\"" >> $HOME/.profile
	grep "UNDERWINDOWS" $HOME/.profile
	[ $? != 0  ] && echo -e "\nUNDERWINDOWS=false\nexport UNDERWINDOWS"     >> $HOME/.profile
	grep "DEFGIT" $HOME/.profile
	[ $? != 0  ] && echo -e "\nDEFGIT='$DEFGIT'\nexport DEFGIT"             >> $HOME/.profile
	grep "aliases.sh" $HOME/.profile
	[ $? != 0  ] && echo -e "\nsource ${WORKLOG}aliases.sh"                 >> $HOME/.profile
	grep "PROFILE FINISHED" $HOME/.profile
	[ $? != 0  ] && echo -e "\n${WORKLOG}wlog.sh PROFILE FINISHED\n"        >> $HOME/.profile

    $ECHO $COLOR1 "\nCheck configuration!"$NORMCO
    $ECHO $COLOR1"------------------------------------------------------"$COLOR2
	tail ".git/info/exclude"
    $ECHO $COLOR1"------------------------------------------------------"$COLOR2
	tail "$HOME/.bashrc"
    $ECHO $COLOR1"------------------------------------------------------"$COLOR2
	tail "$HOME/.profile"
    $ECHO $COLOR1"------------------------------------------------------"$NORMCO
	gedit ".git/info/exclude" "$HOME/.bashrc" "$HOME/.profile"
	
	$ECHO $COLOR1 "\nChecking for linuxlogo..." $NORMCO
	linuxlogo
	if [[ $? != 0 ]]
	then
		$ECHO $COLOR2"Tool 'linuxlogo' is suggested for this toolbox!" $NORMCO
		sudo apt install linuxlogo
	else
		echo OK
	fi
	
	$ECHO $COLOR1 "\nChecking for xprintidle..." $NORMCO
	if [[ ! -f "/usr/bin/xprintidle" ]]
	then
		$ECHO $COLOR2"Tool 'xprintidle' is required for this toolbox to work!" $NORMCO
		sudo apt install xprintidle
	else
		echo OK
	fi
	
	$ECHO $COLOR1 "\nChecking for sysstat..." $NORMCO
	mpstat
	if [[ $? != 0 ]]
	then
		$ECHO $COLOR2"Tool 'mpstat' from 'sysstat' is required for this toolbox to work!" $NORMCO
		sudo apt install sysstat
	else
		echo OK
	fi
fi

$ECHO $COLOR1 "\nInstalation finished..."  $NORMCO
popd

$ECHO $COLOR1'Remember to configure git with your identification'$COLOR3
$ECHO 'git config --global user.email' $COLOR2'"you@example.com"'$COLOR3
$ECHO 'git config --global user.name' $COLOR2'"Your Name"'$NORMCO



