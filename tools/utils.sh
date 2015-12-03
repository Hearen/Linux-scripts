#!/bin/bash



################################################
#Using regx to determine the existence of a file
#Using [ -e "$file_name" ] can be much easier
################################################
function file_existed {
    result=`ls | grep $1`
    if [ -n "$result" ]
    then
        echo $result already exists!
        return 0
    else
        echo $1 does not exist in the current directory!
        echo Please download it first and move it to the current directory.
        return 1
    fi
}

#file_existed "expect.*.tar.gz"

########################################
#Used to automatically install Tcl 
#Remember to reset the working directory
########################################
function tcl_installer {
    result=`ls /usr/tcl/bin | grep expect`
    if [ -n "$result" ]
    then
        return 0
    fi
     old_path=`pwd`
     tar xfvz tcl*-src.tar.gz 1>/dev/null 2>/dev/null
     cd tcl*/unix 
     ./configure --prefix=/usr/tcl --enable-shared 
     make 
     make install 
     cd $old_path
    result=`ls /usr/tcl/bin`
    if [ -n "$result" ]
    then
        return 0
    else
        return 1
    fi
}

#tcl_installer

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
        echo
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
        echo
        echo "Pemission granted!"
	return 0
    fi
}

##############################################
#Check the existence of a certain package 
#And try to install it if it was not installed
##############################################
function check_package {
    package=$1
    check=`rpm -qa | sed -n "/^$package/p"`
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
    echo
    echo "Checking essentials tools' availability..."
    exit_code=0
    check_package "gcc"
    if [ $? -gt 0 ]
    then 
        exit_code=1
    fi
    check_package "expect"
    if [ $? -gt 0 ]
    then 
        exit_code=1
    fi
    return $exit_code
}

