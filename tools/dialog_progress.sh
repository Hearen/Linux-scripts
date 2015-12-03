#!/bin/bash

files=(*.sh)
dialog --gauge "Working..." 20 75 < <(
    sleep 1
    n=${#files[*]}; i=0
    for f in "${files[@]}" 
    do
        # process "$f" in some way (for testing, "sleep 1")
        echo $((100*(++i)/n))
    done
)
