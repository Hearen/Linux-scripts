#!/bin/bash

bar="=================================================="
barlength=${#bar}
i=0
while ((i < 100)) 
do
    # Number of bar segments to draw.
    n=$((i*barlength / 100))
    printf "\r[%-${barlength}s]" "${bar:0:n}"
    ((i += RANDOM%5+2))
    # Of course, in real life, we'd be getting i from somewhere meaningful.
    sleep 1
done
echo
