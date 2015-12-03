#!/bin/bash

function ip_checker {
    local ip=$1
    result=`echo $ip | gawk --re-interval '/^([0-9]{1,3}|\*)\.([0-9]{1,3}|\*)\.([0-9]{1,3}|\*)\.([0-9]{1,3}|\*)$/'`
    #echo $result
    if [ -z "$result" ]
    then
        return 1
    fi

    tmp=`echo $ip | sed "s/\./ /g; s/\*/a/g"`
    #echo ${tmp[*]}
    for a in $tmp
    do
        #echo $a
        if [ $a != "a" ] && [ $a -gt 255 ] 
        then
            return 1
        fi
    done
    return 0
}
while true
do
    read -p "Input the ip to test: " ip
    ip_checker $ip
    if [ $? -eq 0 ]
    then
        echo "Correct!"
    else
        echo "Wrong!"
    fi
done
