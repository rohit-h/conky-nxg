#!/bin/bash

STR=$(date +%m)
YRS=$(date +%Y)

if [ "$STR" = "01" -o "$STR" = "03" -o  "$STR" = "05" -o  "$STR" = "07" -o  "$STR" = "08" -o  "$STR" = "10" -o  "$STR" = "12" ]; then
	MAX_DAYS=31
else
	MAX_DAYS=30
fi

if [ "$STR" = "02" ]; then
	if [ $(( YRS%4 )) -eq 0 -a $(( YRS%100 )) -ne 0 ]; then
		MAX_DAYS=29
	else
		MAX_DAYS=28
	fi   
fi

let D=$(date +%d | bc)

for iter in `seq 1 $MAX_DAYS`; do
	if [ $iter -eq $D ]; then
		echo -n '${font Open Sans:style=bold:size=9}'
		echo -n $iter'    ${font}'
	else
		echo -n $iter'    '
	fi
done
