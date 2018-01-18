#!/bin/bash


#arr=("17.03.00.0000" "17.05.00.0000" "17.08.00.0000" "17.09.00.0000" "17.11.00.0000" "17.11.00.0000-rehearsal" "18.01.00.0000")

#for i in "${arr[@]}"
#do 
    #mkdir "$i"
#done

dir=`ls | sort -n | tail -n1`

echo $dir
