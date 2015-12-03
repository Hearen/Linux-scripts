#!/bin/bash
########################
#Author: LHearen
#E-mail: LHearen@126.com
########################

#########################################################
#This script is used to check the network and commands
#And it will try to fix it firstly and warn it when failed
#########################################################

#exec 1>>output.log
#exec 2>>err.log

###############################################################
#Used to restore and backup ks.cfg isolinux.cfg for iso-making
###############################################################
function check_cfgs {
    local exit_code=0
    check_cfg "ks.cfg"
    if [ $? -gt 0 ]
    then
        ((exit_code++))
    fi
    check_cfg "isolinux.cfg"
    if [ $? -gt 0 ]
    then
        ((exit_code++))
    fi
    if [ $exit_code -gt 0 ]
    then
        return 1
    else
        return 0
    fi
}

#####################################################
#Make a certain file has backup and at the same time 
#When there is a backup, use it to restore the file
#####################################################
function check_cfg {
    file=$1
    if [ -e $file".bak" ]
    then
        echo "Using $file".bak" to reset $file."
        cp -f $file".bak" $file
        return 0
    else
        echo "$file".bak" does not exist!"
        if [ -e $file ]
        then
            echo "Backing up $file ..."
            cp $file $file".bak"
            if [ $? -eq 0 ]
            then
                echo "Backing up $file successfully!"
                return 0
            else
                echo "Failed backing up $file!"
                echo "Please back it up manually."
                return 1
            fi
        else
            echo
            echo "$file does not exist in the current directory!"
            return 1
        fi
    fi    
}


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
        echo "To run this program successfully "
        echo "Try to use root account or sudo command."
        return 126 #Command cannot execute
    else
	return 0
    fi
}

#############################################
#Mount /dev/cdrom to /mnt/cdrom for later use
#############################################
function mount_cdrom {
    umount /mnt/cdrom 
    echo "Start mounting /dev/cdrom to /mnt/cdrom..."
    mount -o loop /dev/cdrom /mnt/cdrom 
    if [ $? -eq 0 ]
    then
        echo
        echo "Successfully mount the /dev/cdrom to /mnt/cdrom."
        echo "Now, we should edit the /etc/yum.repo.d/CentOS-Base.repo "
        echo "To install packages from local ISO."
        echo
        return 0
    else
        echo
        echo "Failed mounting /dev/cdrom to /mnt/cdrom."
        echo "Check the /dev/cdrom again please."
        echo "Make sure the external ISO file is mounted to the computer successfully."

        echo "If you are using KVM to manage virtual machines"
        echo "Follow the steps:"
        echo "Step #1 - Open the virtual machine"
        echo "Step #2 - Show virtual hardware details"
        echo "Step #3 - Select IDE CDROM"
        echo "Step #4 - Connect the ISO file in host"
        echo "Now, you can check /dev/cdrom and mount it to /mnt/cdrom"
        echo 
        return 1
    fi
}

###################################################
#Make sure the iso file is mounted to /mnt/cdrom
#Then we change the /etc/yum.repo.d/CentOS-Base.repo
###################################################
function check_files {
    if [ -e "/dev/cdrom" ]
    then
        if [ -e "/mnt/cdrom" ]
        then 
            echo "Mounted file /mnt/cdrom exists, we can mount ISO here."
            mount_cdrom
            return $?   #Return exit code of function mount_cdrom
        else
            echo "/mnt/cdrom does not exist"
            echo "Create it to mount ISO file."
            mkdir -p /mnt/cdrom 
            mount_cdrom 
            return $?   #Return exit code of function mount_cdrom
        fi
    fi
}

#check_files 



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
    check_package "rsync"
    if [ $? -gt 0 ]
    then 
        exit_code=1
    fi
    check_package "createrepo" 
    if [ $? -gt 0 ]
    then 
        exit_code=1
    fi
    check_package "genisoimage"
    if [ $? -gt 0 ]
    then 
        exit_code=1
    fi
    return $exit_code
}

#check_essential_packages 
