#!/bin/bash
########################
#Author: LHearen
#E-mail: LHearen@126.com
########################

########################################################
#This script is used to check the working environment
#To ensure the working conditions of the program
########################################################

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
            echo "You might have to run login.sh enclosed with this program to login in to access network."
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
        echo "To run this program successfully "
        echo "Try to use root account or sudo command."
        return 126 #Command cannot execute
    else
	return 0
    fi
}

