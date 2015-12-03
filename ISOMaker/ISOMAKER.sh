#!/bin/bash
#######################################
#This script is used to make the 
#Custom ISO from an existing minimal OS
#######################################
. ./check_environment.sh
. ./configure.sh

function redirect {
    exec 1>output.log
    exec 2>err.log
}

echo `date +%H:%M:%S` - `date +%m/%d/%Y` 
echo `date +%H:%M:%S` - `date +%m/%d/%Y` >&2 
echo 
echo "To make sure the program execute smoothly" 
echo "Checking the current authority..."
check_permission 
if [ $? -eq 0 ] 
then 
    echo "Pemission granted." 
else 
    echo "Pemission denied!" 
    echo "Make sure you are running this program in root or sudo command." 
    echo "Leaving the program..."
    exit 1
fi

echo
echo "Checking configuration files..."
check_cfgs 
if [ $? -gt 0 ]
then
    echo
    echo "Cannot build iso without these configuration files!"
    echo "Leaving the program..."
    exit 1
fi

echo
echo "If you are running this program the first time, please continue by [1]."
echo "If you just solved the unfound packages problem, please continue by [2]."
echo "If you want to quit, please continue by [0]."
while [ 1 ]
do
    read -n1 -p "Input your choice:[1/2/0]" choice
    case $choice in
        0)
            echo 
            echo "Leaving the program..."
            exit 0
            ;;
        1)
            echo
            echo "Checking the network for online installation..."
            echo
            check_fix_network 
            if [ $? -eq 0 ]
            then
                echo
                echo "Some essential packages are needed for the program to run successfully."
                echo "Checking installed essential packages..."
                check_essential_packages
                if [ $? -eq 0 ]
                then
                    echo "All essential packages installed!"
                    echo
                    echo "To install from local ISO, we have to make sure the external ISO is mounted to the computer properly."
                    echo "And the external ISO is mounted to /mnt/cdrom right."
                    echo "Make some checking..."
                    echo -e "Attention:\nIn the current directory"
                    echo "There are two executable scripts for further installation: set_local_installation.sh and set_online_installation.sh"
                    echo "If you want to install other packages from local ISO, run the set_local_installation.sh first and follow its steps."
                    echo "If you want to install packages online, run the set_online_installation.sh first and follow its steps."
                    read -n1 -p "Go to install some packages first? [y/n]" answer
                    echo
                    if [ $answer = 'y' -o $answer = 'Y' ]
                    then
                        echo
                        echo "Leaving the program now..."
                        exit 0
                    fi
                    #redirect    #TODO for debugging only
                    check_files #Make sure all essential files and directories are prepared
                    if [ $? -eq 0 ]
                    then
                        echo
                        echo "Now, let's copy the essential contents from /mnt/cdrom/."
                        move_iso_file
                        if [ $? -eq 0 ]
                        then
                            echo "Preparing configuration files for the custom ISO..."
                            replace_packages_list 
                            #customize_isolinux 
                            echo "Replacing the essetial configuaration files..."
                            replace_cfg_files
                            echo "Creating a new repository for the custom ISO..."
                            create_repo 
                            echo
                            echo "Building custom ISO..." 
                            build_ISO
                            exit 0
                        else
                            echo 
                            echo "Failed copying from /mnt/cdrom/!"
                            echo "Unexpected error!"
                            echo "Leaving the program..."
                            exit 1
                        fi  
                    else
                        echo    #We are trying to access the internal contents of the external ISO via /mnt/cdrom here
                        echo "Failed mounting external ISO to /mnt/cdrom."
                        echo "Leaving the program now..."
                        echo 
                        exit 1
                    fi
                else    #The essential packages here refer to some essential tools for the program
                    echo
                    echo "Some essential packages are not installed!"
                    echo "Failed installing!"
                    echo "Leaving the program now..."
                    echo
                    exit 1
                fi
            else    #Actually if the essential packages have already been installed and all the 
                    #Auxiliary packages have been downloaded, connection might not be that necessary
                echo 
                echo "Network disconnected!"
                echo "Cannot continue with the rest of the program."
                echo "Leaving the program now..."
                echo
                exit 1
            fi
            ;;
        2)
            echo
            echo "Now, let's copy the packages again from /mnt/cdrom "
            echo "And local cache according to ./isomake/Packages.list..."
            #redirect #TODO for debugging only
            recopy_packages
            if [ $? -eq 0 ]
            then
                echo
                echo "Preparing configuration files for the custom ISO..."
                replace_packages_list 
                #customize_isolinux 
                echo "Replacing the essetial configuaration files..."
                replace_cfg_files
                echo "Creating a new repository for the custom ISO..."
                create_repo 
                echo
                echo "Building custom ISO..." 
                build_ISO
                exit 0
            else
                echo 
                echo "Failed copying from /mnt/cdrom/!"
                echo "Unexpected error!"
                echo "Leaving the program..."
                exit 1
            fi  
            ;;
        *)
            echo "Input error! Please input [1/2/0]."
            echo
            ;;
    esac
done
