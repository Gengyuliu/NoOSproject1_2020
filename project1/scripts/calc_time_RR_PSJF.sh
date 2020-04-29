#!/usr/bin/env bash

#automatically version of calc_time_2.sh

qt=0.001554701  # length of time unit measured with get_time.sh
#begin=0.0
#first=65536


for method in RR PSJF
do
	echo ${method}
	#find the smallest pid and then get the corresponding start time
	for i in $(seq 1 5)
	do 
		first=65536 #choose any sufficient large num
		begin=0.0
		input="../output/${method}_${i}_dmesg.txt"
		while IFS= read -r line
		do
		    if [ ! "$line" ]; then
			break
		    fi

		    pid=$(echo $line | cut -f4 -d" ")
		    if [ $pid -lt $first ]; then
			first=$pid
			begin=$(echo $line | cut -f5 -d" ")
		    fi
		done < $input
		#finish finding
		echo ${first}
		echo ${begin}
		
		while IFS= read -r line
		do
		    if [ ! "$line" ]; then
			break
		    fi

		    pid=$(echo $line | cut -f4 -d" ")
		    time2=$(echo $line | cut -f6 -d" ")

		    diff=$(echo "scale=9; $time2-$begin" | bc -q)
		    rec=$(echo "scale=9; $diff/$qt" | bc -q)
		    echo "$pid finish at $rec unit" 

		done < $input
		echo ---------------------------
	done
done
