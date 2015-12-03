#!/bin/bash
########################
#Author: LHearen
#E-mail: LHearen@126.com
########################

#########################################################
#This script is used to check the network and commands
#And it will try to fix it firstly and warn it when failed
#########################################################


#############################
#Using a given test site to
#Check the network and return
#Http code 200 - okay
#############################
function check_network {
   test_site=$1
   timeout_max=2    #seconds before time out
   return_code=`curl -o /dev/null/ --connect-timeout $timeout_max -s -w %{http_code} $test_site`
   echo $return_code
}


####################################
#Check the network and try to fix it
####################################
function check_fix_network {
return_code=`check_network "baidu.com"`
   if [ $return_code -eq 200 ]
   then
        echo "Network available"
   else
        echo "Connection error!"
        echo "Trying to fix the network..."
        service network restart > /dev/null  
        return_code=`check_network "baidu.com"`
        if [ $return_code -eq 200 ]
        then
            echo "Network available now."
            return 0
        else
            echo "Failed to fix the connection."
            echo "When you are using ISCAS Network, you might have to run login.sh enclosed with this program"
            echo "To login in to access network."
            echo "If you are using other networks, you should try to use browser to login or rewrite the login.sh to login."
            echo "Remember sometimes 'ping works' does not mean you can access network normally and install online packages."
            echo "You have to fix the network by yourself now."
            echo "Leaving the script..."
            return 1
        fi 
   fi
}

#check_fix_network

####################################################
#Make sure the root privelege is given to the script
####################################################
function check_permission {
    if [ $UID -ne 0 ]
    then
        echo
        echo "Pemission denied!"
        echo "You have to gain root privilege to run this program!"
        echo "Try to use sudo or su to run it."
        echo "Leaving the program now..."
        return 126 #Command cannot execute
    else
        return 0
    fi
}

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

##############################################
#Check the existence of a certain package 
#And try to install it if it was not installed
##############################################
function check_package {
    package=$1
    check=`rpm -qa | grep $package`
    if [ -z "$check" ]
    then
        echo
        echo "Tool - $package is not installed."
        echo "To run the program properly, we have to install it first."
        echo "Installing $package ..."
        echo
        yum install -y $package 
        if [ $? -eq 0 ]
        then
            echo "$package installed successfully!"
            return 0
        else
            echo "Failed installing $package ."
            echo "Make sure your internet is connected."
            echo
            return 1
        fi
    else
        echo "$package has been installed!"
        return 0
    fi
}

##############################################
#Ensure the whole program to run as expected,
#Some essential packages should be installed 
#Before running this program; this function 
#Is used to check their existence and install 
#Them if they are not installed so far
##############################################
function check_essential_packages {
    exit_code=0
    check_package "nfs-utils"
    if [ $? -gt 0 ]
    then 
        exit_code=1
    fi
    return $exit_code
}

#check_essential_packages 
