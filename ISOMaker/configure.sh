#!/bin/bash
########################
#Author: LHearen
#E-mail: LHearen@126.com
########################

##################################################################
#This script is used to make sure the basic environment is all set
##################################################################
#exec 1>>output.log
#exec 2>>err.log

#######################################################
#Make the installation source redirected to the 
#Local ISO file via the baseurl attribute in 
#Configuration file  /etc/yum.repos.d/CentOS-Base.repo 
#######################################################
function set_local_repo {
    . ./check_environment.sh
    check_files
    if [ $? -eq 0 ]
    then
	    basefile=/etc/yum.repos.d/CentOS-Base.repo
	    tmpfile=`mktemp base-repo.XXX`
	    cp -f $basefile $basefile".bak" #Back up in case of unexpected failure
	    cat $basefile | sed -n '/mirrorlist/!p' | sed '/#baseurl/i\baseurl=file:///mnt/cdrom' | sed '/#baseurl/d' > $tmpfile
	    mv $tmpfile $basefile
	    echo "Set the repository to local ISO file."
	    echo "Now, we can install some packages locally."
	fi
}



#################################################
#Make sure the online installation will store all 
#The related packages for later use
#################################################
function set_package_cache {
    basefile=/etc/yum.conf
    echo 
    echo "Backing up the /etc/yum.conf to /etc/yum.conf.bak in case of accidental failure"
    echo 
    cp -f $basefile $basefile".bak" #Back up the configuration file in case of unexpected failure
    tmpfile=`mktemp yum.conf.tmp.XXX` 
    cat $basefile | sed 's/keepcache=0/keepcache=1/' >/dev/null
    mv -f $tmpfile $basefile
    echo 
    echo "Done setting the keepcache true."
    echo "Now, we can store the installed packages for later use."
    echo 
}



##########################################################################
#If there is a backup, use /etc/yum.repos.d/CentOS-Base.repo.bak 
#To replace /etc/yum.repos.d/CentOS-Base.repo to reset the base repository
##########################################################################
function set_online_repo {
    basefile=/etc/yum.repos.d/CentOS-Base.repo
    if [ -e $basefile".bak" ]
    then
        mv -f $basefile".bak" $basefile
    fi 
    set_package_cache
    echo
    echo "Now, we can install packages online."
    echo "And after installation, we can retrieve"
    echo "The installed packages under /var/cache/yum/*"
}

#set_local_repo 
#set_online_repo

################################################
#Reset the yum installing configuration to make 
#It discard the packages after installation
################################################
function reset_package_cache {
    basefile=/etc/yum.conf
    if [ -e $basefile".bak" ]
    then
        echo
        echo "Using the /etc/yum.conf.bak to restore /etc/yum.conf."
        echo "Now, all the related installed packages will"
        echo "Not be saved to spare more space."
        echo
        mv -f $basefile".bak" $basefile
    fi
}

#set_package_cache 
#reset_package_cache


#########################################################################
#When essential packages missed in /mnt/cdrom/Packages
#We have to search them under /var/cache/yum/x86.64/6|7/base|extra|update
#And then copy them to ./isomake/data/OS/Packages
#If still cannot find it, prompt the user about the failure
#########################################################################
#TODO After debugging, we have to set the inner error to /dev/null
function copy_packages_from_cache {
    echo
    echo "Start to copy left packages from local cache..."
    #TODO in different release the base path will be different
    #base_path=/var/cache/yum/x86.64/6/ #Release 6
    base_path=/var/cache/yum/   #Release 7
    des_path=./isomake/ISO/Packages/
    packages_list=$1
    unfound=0
    rm -f unfound_packages.list.*
    packages_unfound_list=`mktemp unfound_packages.list.XXX`
    number_of_packages=`cat $packages_list | wc -l`
    for ((index=1; index <= $number_of_packages; index++))
    do
        package=`cat $packages_list | sed -n "$index p"`
        echo
        cp $base_path"base/packages/"$package* $des_path 
        if [ $? -gt 0 ]
        then
            echo Cannot find $package under $base_path"base"
            cp $base_path"extras/packages/"$package* $des_path 
            if [ $? -gt 0 ]
            then
                echo Cannot find $package under $base_path"extra"
                cp -f $base_path"updates/packages/"$package* $des_path 
                if [ $? -gt 0 ]
                then
                    echo Cannot find $package under $base_path"update"
                    echo "Cannot find $package in local cache!"
                    echo 
                    echo $package>>$packages_unfound_list 
                    unfound=$[$unfound + 1]
                else
                    echo "Found $package in $base_path"updates/"."
                fi
            else
                echo "Found $package in $base_path"extras/"."
            fi
        else
            echo "Found $package in $base_path"base/"."
        fi
    done
    #If the unfound temporary file is not empty
    if [ $unfound -gt 0 ]
    then
        echo
        echo "Finished searching!"
        echo 
        echo "Check the unfound packages by yourself,please."
        echo "The following suggestions might be helpful in such failure."
        echo
        echo "1. You can remove some packages from /isomake/Packages.list manually like gpg-pubkey;"
        echo
        echo "2. You can manually copy these packages in "
        echo "$packages_unfound_list from other resources like /mnt/cdrom/Packages/ or /var/cache/yum/* to $des_path ;"
        echo 
        echo "3. You can remove it first and then reinstall it;"
        echo "After which you may find them under /var/cache/yum/* if you firstly run set_online_installation.sh;"
        echo 
        echo "4. You can edit the package version in isomake/Packages.list and the rest will be handled automatically by the program when the packages exist in /mnt/cdrom/Package/ but the version is not consistent with that in isomake/Packages.list;"
        echo
        echo "Unfortunately, there might be some weird packages for certain version of CentOS 7 that need to be added when all packages have worked right "
        echo "Finally when you are testing the custom ISO, it might prompt that some packages are missing take chrony as an example; "
        echo "And usually these packages can be found in /mnt/cdrom/Packages/ and we can simply copy them from /mnt/cdrom/Packages/ to isomake/ISO/Packages/ and re-run the program."
        echo
        echo "When you rerun this program, you can select 2 to continue the unfinished steps to make your packages problem solved." 
        echo
        return 1
    else
        return 0
    fi
}


########################################################################
#Copy packages from /mnt/cdrom/ according to the ./isomake/Packages.list
#To ./isomake/ISO/Packages/ a temporary unfound packages list file 
#Will be defined here and used by copy_packages_from_cache
########################################################################
function copy_packages_from_mnt {
    echo
    echo "Start to copy packages from /mnt/cdrom/Packages to "
    echo "/isomake/data/OS/Packages/  ..."
    echo
    package_list_file=./isomake/Packages.list
    os_dir=./isomake/ISO/

    mkdir -p $os_dir"Packages/"
    src=/mnt/cdrom/Packages/
    des=$os_dir"Packages/"
    number_of_packages=`cat $package_list_file | wc -l`

    rm -f package_tmp.list*

    #This temporary file will be used by copy_packages_from_cache as a parameter
    package_tmp_list=`mktemp package_tmp.list.XXX`  
   
    for ((index=1; index<=$number_of_packages; index++))
    do
        package=`cat $package_list_file | sed -n "$index p"`
        cp -f $src$package* $des 

        #The copying process failed
        #Record the unfound packages in temporary file
        #Try to search them under /var/cache/yum
        #later by passing $package_tmp_list to copy_packages_from_cache 
        if [ $? -gt 0 ] 
        then
            echo $package>>$package_tmp_list
        fi
    done
}

#######################################################################
#According to the current environment retrieve a list 
#Of all the essential and installed packages and copy all the packages 
#From /mnt/cdrom/Packages or /var/cache/yum/ to 
#isomake/data/OS/Packages/
#######################################################################
function move_iso_file {
    root_dir=./isomake/
    os_dir=./isomake/ISO/
    if [ -d "./isomake" ]
    then
        echo
        echo "Directory isomake already exists!"
        echo "We have to delete it first to restart iso-making process."
        echo 
        echo "Removing the whole isomake directory..."
        rm -rf isomake
    fi
    echo "Making a bran-new directory $root_dir."
    mkdir -p $root_dir
    echo "Making a bran-new directory $os_dir."
    mkdir -p $os_dir
    package_list_file=./isomake/Packages.list
    echo
    echo "Retrieving a list of all installed packages to $package_list_file"
    echo 
    rpm -qa > $package_list_file 
    if [ -d /mnt/cdrom ]
    then
        echo
        echo "Copying files from /mnt/cdrom/ to $os_dir ..." 
        echo
        echo
        rsync -a --exclude=Packages --progress /mnt/cdrom/. $os_dir >/dev/null 
    else
        echo 
        echo "Directory /mnt/cdrom does not exist!"
        echo "Please run this program step by step!"
        echo "Now, leaving the program..."
        echo 
        exit
    fi

    copy_packages_from_mnt

    #Make sure no package left - copy them from local cache
    #After copy_packages_from_cache there will be a unfound_packages.list.*
    #For users to manually solve the packages missing problem
    copy_packages_from_cache $package_tmp_list 
    if [ $? -gt 0 ]
    then 
        rm -f $package_tmp_list 
        return 1
    else
        rm -f $package_tmp_list 
        return 0
    fi
}

#move_iso_file

#########################################################################################################
#After reconfiguring the ./isomake/Packages.list and manually search the missing packages
#We have re-copy the packages from /mnt/cdrom/Packages and local cache according to the new Packages.list
#########################################################################################################
function recopy_packages {
    copy_packages_from_mnt

    #Make sure no package left - copy them from local cache
    copy_packages_from_cache $package_tmp_list 
    if [ $? -gt 0 ]
    then 
        #rm -f $package_tmp_list 
        return 1
    else
        #rm -f $package_tmp_list 
        return 0
    fi
}



##############################################
#Replace the packages section in ks.cfg 
#with the list in isomake/Packages.list
##############################################
function replace_packages_list {
    echo 
    echo "Initializing for ks.cfg..."
    rm -f ks_tmp.cfg.*
    package_list=./isomake/Packages.list
    
    #Using two temporary file to assist 
    #In inserting packages name from Packages.list
    ks_tmp0=`mktemp ks_tmp.cfg.XXX`
    ks_tmp1=`mktemp ks_tmp.cfg.XXX`

    #Remove all the contents between %packages and %end - inclusive
    #Store all the left contents in a temporary file
    echo "Removing old packages section from ks.cfg..."
    cat ks.cfg | sed '/%packages/,/%end/{d}' > $ks_tmp0
    number_of_packages=`cat $package_list | wc -l`
    
    #To insert %packages - header and %end - footer
    #Increment number_of_packages and start from 0
    echo "Inserting bran-new packages list into ks.cfg..."
    ((number_of_packages++))
    for((index=0; index<=$number_of_packages; index++))
    do
        #Get line $index package - (line 1 is the first line)
        package=`cat $package_list | sed -n "$index p"`
        #echo $index -- $package 
        case $index in
            0)
                cat $ks_tmp0 | sed '/%post --nochroot/i\%packages' >$ks_tmp1
                ;;
            $number_of_packages)
                cat $ks_tmp0 | sed '/%post --nochroot/i\%end\n\n' >$ks_tmp1
                ;;
            *)
                cat $ks_tmp0 | sed "/%post --nochroot/i$package" >$ks_tmp1
                ;;
        esac
        #Exchange ks_tmp0 and ks_tmp1
        tmp=$ks_tmp0
        ks_tmp0=$ks_tmp1
        ks_tmp1=$tmp
    done 
    #echo $number_of_packages 
    mv -f $ks_tmp0 ks.cfg
    rm -f $ks_tmp1 
    echo "Done rebuilding ks.cfg!!"
}

#replace_packages_list 




######################################################
#Customize the ISO label - changing CentOS 7 to FireUp
######################################################
function customize_isolinux {
    rm -f isolinux.tmp.* 
    tmp=`mktemp isolinux.tmp.XXX`
    echo 
    echo "Start to replacing label CentOS 7 to FireUp..."
    #cat isolinux.cfg | sed 's/CentOS 7/FireUp/; s/CentOS\\x207/FireUp/' >$tmp
    cat isolinux.cfg | sed 's/CentOS 7/FireUp/;' >$tmp
    mv -f $tmp isolinux.cfg
    echo "Done replacing label CentOS 7."
}
#customize_isolinux


##################################################################
#Replace the configuration file under ./isomake/data/OS/isolinux/ 
#With ks.cfg and isolinux.cfg
##################################################################
function replace_cfg_files {
    mv -f isolinux.cfg ks.cfg ./isomake/ISO/isolinux/
}

#############################################
#Used to create repository for the custom ISO
#############################################
function create_repo {
    mv ./isomake/ISO/repodata/*-x86_64-comps.xml ./isomake/ISO/repodata/c7-x86_64-comps.xml
    createrepo -g repodata/c7-x86_64-comps.xml ./isomake/ISO/
}

##########################
#Making the custom ISO now
##########################
function build_ISO {
    WORKDIR=`pwd`
    #-V is the label used to identify the custom ISO which is used in isolinux.cfg leble attribute
    mkisofs -R -J -T -r -l -d -joliet-long -allow-multidot -allow-leading-dots -no-bak -o ${WORKDIR}/isomake/CentOS-x86_64.1.0.0.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -V 'CentOS 7 x86_64' -boot-load-size 4 -boot-info-table ${WORKDIR}/isomake/ISO
    
    echo
    echo "Done building custom ISO"
    echo "We can find it under ./isomake/"
    echo 
    echo "Attention:"
    echo "After your installation of this custom ISO, the default password for root is 123456."
    echo
}
#build_ISO
