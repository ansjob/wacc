#!/bin/bash

while read LINE; do
	NAME="`basename ${LINE}`"
	echo \\lstinputlisting[caption=${NAME}, language=Prolog]{${LINE}} 
done
