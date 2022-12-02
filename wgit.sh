#!/bin/bash
#"worklog" git monitoring for version (1.25) and above
################################################################################
# Skrypt logowania w logu wykonanych róznych akcji GITa , które coś zmieniają
#
# TODO:
# $* vs $@ --> 
#https://unix.stackexchange.com/questions/129072/whats-the-difference-between-and


echo "$DEFGIT" $@

#"$DEFGIT" $* #To ma problem ze spacjami w komunikacie po -m
"$DEFGIT" $@ #Ale i to ma problem ze spacjami w komunikacie po -m

#echo "$DEFGIT" $1 $2 $3 $4 $5 $6 $7 $8 $9     #Tak też ma ten problem
#"$DEFGIT" $1 $2 $3 $4 $5 $6 $7 $8 $9

#echo "$DEFGIT" "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" #fatal: empty string is not a valid pathspec.
#"$DEFGIT" "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"

if [ $? == 0 ]
then
        if [ $1 == "commit" ]\
        || [ $1 == "push" ]\
        || [ $1 == "pull" ]\
        || [ $1 == "add" ]\
        || [ $1 == "mv" ]\
        || [ $1 == "rm" ]\
        || [ $1 == "branch" ]\
        || [ $1 == "merge" ]\
        || [ $1 == "clone" ]\
        || [ $1 == "restore" ]\
        || [ $1 == "remote" ]
        then
        #echo CAP:
        ${WORKLOG}wlog.sh "GIT\t" "`pwd`\t" $@
        fi
fi


