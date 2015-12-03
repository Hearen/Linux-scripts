#!/bin/bash
########################
#Author: LHearen
#E-mail: LHearen@126.com
########################

########################################################
#This script is used to configure the host to make sure 
#The environment can work smooth in maintaining yum 
#Repository and controlling remotes
########################################################
function install_tool {
    tool=$1
    result=`rpm -qa | grep $tool`
    if [ -n "$result" ]
    then
        echo "$tool installed already!"
    else
        echo "$tool is not installed"
        echo "Installing $tool now..."
        yum install -y $tool
    fi
    
}
function configure_repo {
    install_tool httpd
    install_tool createrepo

    echo "Starting httpd.service..."
    systemctl start httpd.service
    systemctl enable httpd.service
    echo "Configuring firewall for http and https..."
    firewall-cmd --permanent --zone=public --add-service=http
    firewall-cmd --permanent --zone=public --add-service=https
    firewall-cmd --reload

    docker_dir=/var/www/html/docker_repos
    if [ -e $docker_dir ]
    then
        echo "$docker_dir already exists!"
        echo "Resetting $docker_dir..."
        rm -rf $docker_dir
    else
        echo "$docker_dir does not exist!"
        echo "Creating $docker_dir..."
        mkdir -p $docker_dir 
    fi
    echo "Creating repository based on $docker_dir..."
    createrepo /var/www/html/docker_repos
}


