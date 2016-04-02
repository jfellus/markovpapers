#!/bin/bash

n=$((RANDOM%60))
i=0
while read line; do
	if [ $n -lt "0" ]; then
		echo '~['$i'] '
		i=$(( $i + 1 ))
		n=$((RANDOM%50))
	fi
	echo $line
	n=$(( $n - 1 ))
done
