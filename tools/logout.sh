#!/bin/bash
#####################################################################################
#Author      : LHearen
#E-mail      : LHearen@gmail.com
#Time        : Thu, 2016-05-05 14:46
#Description : Used to logout from ISCAS network;
#####################################################################################

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

function send_logout_request {
    t=$(date +%s)
    echo "Trying to send logout request..."
    curl http://133.133.133.150/ajaxlogout?_t=$t >/dev/null
    echo
}

function logout_network {
    while [ 1 ]
    do
        send_logout_request
        return_code=`check_network "cn.bing.com"`
        if [ $return_code -eq 200 ]
        then 
            echo "Failed! retry in 1 second"
            sleep 1
        else
            echo "Log out successfully!"
            break
        fi
    done
}

logout_network

