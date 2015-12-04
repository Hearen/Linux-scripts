#!/bin/bash
########################
#Author: LHearen
#E-mail: LHearen@126.com
########################


######################################################################
#This script is used to check the privilege, network, essential tools 
#And try its best to automatically handle all of them; if it cannot, 
#It will also prompt the user to manually handle it easily
######################################################################

. ./check_environment.sh
#################################################################
#Make sure privilege, network, packages and services are all good
#################################################################
function check_env {
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

    systemctl enable nfs-server 1>/dev/null 2>/dev/null
    systemctl enable nfs-lock 1>/dev/null 2>/dev/null
    systemctl start nfs-server 1>/dev/null 2>/dev/null
    systemctl start nfs-lock 1>/dev/null 2>/dev/null
}

#########################################
#Configure the sharing directory and host
#########################################
function server_configure {
    check_permission
    if [ $? -gt 0 ]
    then 
        exit 1
    fi
    echo
    read -p "Input the directory you try to share with remotes: [abosulte path]" path
    while [ -z "$path" ] || [ ! -e $path ]
    do
        read -p "The directory input not found, please INPUT another one: " path
    done

    echo
    read -p "Input the host address you want to share: [regular expression supported]" host
    ip_checker $host 
    while [ $? -gt 0 ]
    do
        read -p "Input Error! Try again: " host
        ip_checker $host 
    done

    if [ $1 = "replace" ]
    then
        echo -e "$path \t $host(rw,sync,no_root_squash,no_all_squash)" > /etc/exports
    elif [ $1 = "append" ]
    then
        echo -e "$path \t $host(rw,sync,no_root_squash,no_all_squash)" >> /etc/exports
    fi
        

    systemctl restart nfs-server
    
    echo
    echo
    echo "Now you can check the sharing direcotris of the NFS server by command 'showmount -e hostname|ip'"
    echo
    echo
    echo "If you cannot share the shared directories of this machine, check its firewall first."
    echo "Make sure the NFS sharing operation is available for the firewall."
}

#server_configure 

echo 
clear
echo "Welcome to set up the NFS server automatically in this system."
echo 
echo "To make the program run as it's planned, you have to gain root privilege first to run this program!"
echo 
echo "If you have configured NFS server before, and want to share a file now. [1]"
echo
echo "Just want add ANOTHER to share. [2]"
echo
echo "If you are new to NFS, and try to set up your FIRST NFS server and start to share files. [3]"
echo
echo "If you want to quit now. [0]"
echo
read -n1 -p "What's your choice then?[1|2|3|0]" choice
echo
while true
do
        case $choice in
        0)
            exit 0
            ;;
        1)
            server_configure replace
            break
            ;;
        2)
            server_configure append
            break
            ;;
        3)
            check_env
            if [ $? -gt 0 ]
            then
                exit 1
            fi
            server_configure
            break
            ;;
        *)
            read -n1 -p "INPUT ERROR! [1|2|3|0]" choice
            ;;
    esac
done
