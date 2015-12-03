#!/bin/bash
########################
#Author: LHearen
#E-mail: LHearen@126.com
########################

###################################################
#This script is used to interact with the host user
###################################################


##########################################################
#Install expect tool for interactive commands in later use
##########################################################
function configure_expect {
    echo
    echo "If you want the program to automatically configure 'expect' if it's still not configured"
    echo "And configure the remote client directly. [1]"
    echo
    echo "If you just want to install expect from source and configure it manually according to the guide in Section 2"
    echo "Their official sites available:"
    echo 'Expect: http://sourceforge.net/projects/expect/files/'
    echo 'Tcl: http://sourceforge.net/projects/tcl/ [2]'
    echo
    echo "Or, if you want to quit. [0]"
    echo
    read -n1 -p "What's your choice [1|2|0]:      " choice

    while true
    do
        case $choice in
            1)
                echo
                check_package "expect"
                if [ $? -gt 0 ]
                then 
                    ((exit_code++))
                fi
                return 0
                ;;
            2)
                echo
                echo "Leaving the program now..."
                return 1
                ;;
            0)
                echo
                echo "Leaving the program now..."
                return 1
                ;;
            *)
                echo
                echo "Input error!"
                read -n1 -p "What's your choice [1|2|0]:      " choice
                ;;
        esac
    done
    return 1       
}

configure_expect 

if [ $? -eq 0 ]
then
    echo
    echo "Before you try to configure the repository of the remote client, "
    echo "You have to input some basic infomation to reset it."
    read -p "Client IP address: " client_ip
    read -p "username: " username
    read -r -p "password:" -s password
    echo
    read -p "Repository url [ip/repos/]:" repo_url
    echo
    echo "Configuring the remote client..."
    ./reset_client_repo.sh "$client_ip" "$username" "$password" "$repo_url" 1>/dev/null
    echo
    echo "Done redirecting the repository for the remote!"
fi
