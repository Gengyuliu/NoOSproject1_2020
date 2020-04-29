#!/usr/bin/env bash

# This script takes the timing details from dmesg and
# calculates each tasks converted finish time
# and straighforwordly regard the first input as the first process

#only works for FIFO SJF

input=$1
qt=0.001554701  # length of time unit measured with get_time.sh
begin=0.0
cnt=0

while IFS= read -r line
do
    if [ ! "$line" ]; then
	break
    fi

    pid=$(echo $line | cut -d" " -f4 )
    time1=$(echo $line | cut -d" " -f5)
    time2=$(echo $line | cut -d" " -f6)

    #take the first input as the first process
    if [ $cnt -eq 0 ]; then
	begin=$time1
	cnt=1
    fi

    diff=$(echo "scale=9; $time2-$begin" | bc -q)
    rec=$(echo "scale=9; $diff/$qt" | bc -q)
    echo "$pid finish at $rec unit" 
done < input
