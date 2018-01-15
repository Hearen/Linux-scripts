#!/bin/bash

function trap_ctr_c () {
    echo "Ctrl-C caught"
    echo "Doning the cleanup now..."
    exit 2
}

trap "trap_ctr_c" 2

for (( i = 0; i < 10; ++i ))
do
    sleep 1
    echo "hello "$i;
done
