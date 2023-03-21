#!/bin/bash
# Skrypt uaktualniający sekwencje Doxygenowe 
#               "@date XX-XX-XX ( x xxxx modification)"
# aktualną data modyfikacji pliku.
# Plik do zmiany podaje się jako pierwszy i jedyny parametr.
################################################################################
set -e #???

grep -E --color=ALWAYS '@date \w+.\w+.\w+ .* modification)' $1
date -r $1 "+%Y-%m-%d %H:%M:%S"

NEWDATE=`date -r $1 "+%Y-%m-%d"`
#echo $NEWDATE
sed --in-place=.bak -E "s#(@date )(\w+.\w+.\w+)( .* modification\))#\1$NEWDATE\3#" $1

grep  -E --color=ALWAYS '@date \w+.\w+.\w+ .* modification)' $1

