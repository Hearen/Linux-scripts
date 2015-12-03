#!/bin/bash
########################
#Author: LHearen
#E-mail: LHearen@126.com
########################

##############################################################################################################
#This script is used to guide the user to configure a remote client to redirect to a custom private repository
##############################################################################################################

clear
echo "This program will guide you to configure a remote client to "
echo "Make its yum repository redirected to your own custom private one."
echo
echo
echo "Before we truly start this journey, there are several things you might need to remember:"
echo
echo "To fully automate the configuration process, you'd better run this program using root privilege"
echo "Maybe some tools will be installed to assist the configuration process like gcc"
echo "Make sure your network is available during the whole process"
echo "Since we have to download some essential packages and connect to the remote~"


. ./check_environment.sh

#################################################################
#Make sure privilege, network, packages and services are all good
#################################################################
function check_env {
    . ./check_environment.sh

    echo
    check_permission
    if [ $? -gt 0 ]
    then
        exit 1
    fi

    check_fix_network
    if [ $? -gt 0 ]
    then
        exit 1
    fi

    check_essential_packages
    if [ $? -gt 0 ]
    then
        exit 1
    fi

}

check_env

if [ $? -eq 0 ]
then
    . ./configure.sh
fi



