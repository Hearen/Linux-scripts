#!/bin/bash

i=0
sp='/-\|'
n=${#sp}
printf ' '
while true; 
do
    printf '\b%s' "${sp:i++%n:1}"
done
