#!/bin/bash

i=0
while ((i < 100))
do
    printf "\r%3d%% complete" $i
    ((i += RANDOM%5+2))
      # Of course, in real life, we'd be getting i from somewhere meaningful.
    sleep 1
done
echo
