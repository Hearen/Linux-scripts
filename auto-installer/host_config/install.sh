#!/bin/bash
########################
#Author: LHearen
#E-mail: LHearen@126.com
########################
. ./check_environment.sh
. ./configure.sh

check_permission
if [ $? -gt 0 ]
then
    echo "Permission denied"
    exit 1
fi

check_fix_network
if [ $? -gt 0 ]
then
    exit 1
fi

configure_repo 

