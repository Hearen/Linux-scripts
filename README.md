/*******************************************
    Author: LHearen
    E-mail: LHearen@126.com
    Time  :	2015-12-03 20:08
    Description: 
    Source: 
*******************************************/

# Linux-scripts
Used to automate some big task in linux environment

#ISOMaker Introduction
##################################################
#Section 1: Basic Rules to Make a Custom CentOS 7 
##################################################
1) You have to firstly install minimal version of centos 7 via Virtual Machine Manager using a iso file of centos 7; remember to connect the network otherwise it will be uneasy to set it in shell environment; 

2) Set up a virtual DVD device for your virtual machine in IDE CDROM TAB from the os iso file and mount -o loop /dev/cdrom /mnt/cdrom; if you want to install packages from the local ISO, it's time to edit the yum source in /etc/yum.repo.d/CentOS-Base.repo (Attention: before you really edit it, try to make a copy of it in case of unexpected failure) - commenting the mirrorlist, uncommenting the baseurl and change the baseurl to file:///mnt/cdrom where the iso mounted - edit them in each section;

3) It's time to install some packages from the mounted iso but if it fails, try to login in by login.sh to access external network and reset the /etc/yum.repo.d/CentOS-Base.repo and then install the packages online but remember to set the keepcache to 1 in /etc/yum.conf first which will enable you to get the packages you just installed;

4) Get a list of all the installed packages by rpm -qa > packages.list; 

5) According to the packages.list, we start to copy all the packages from /mnt/cdrom/Packages and /var/cache/yum/* to isomake/ISO/Packages/ to get ready for the custom ISO; if there are some missed packages, delete it from the packages.list or remove the package the reinstall it and then you can find them in the cache; 

6) Replace the packages part with the content of packages.list in ks.cfg and change the labels in isolinux.cfg for special needs after which copy them to isomake/data/OS/isolinux; p.s. the post part in ks.cfg is a place to run some shells for system configuration;

7) createrepo for the custom ISO; 

8) genisoimage or mkisofs a custom ISO based on the prepared files;

9) Create a new virtual machine via this new os iso file to check its completeness; p.s. transfer this iso file to the host using scp *.iso root@ip:/home first; if there is something wrong, like chrony needed, try to copy this package from /mnt/cdrom/Packages/ to isomake/ISO/Packages/ and then start with step 7 till step 9;

P.S. If there is something wrong about the source packages, find it in /mnt/cdrom/Packages and move it to isomake/data/OS/Packages/ but if this would not work either, then you should try to install it online and because the keepcache was set true, you then can find the package and its denpendency in /var/cache/yum and then copy them to isomake/data/OS/Packages/ and then after this copying operation, you should do what you should do as it does in step 5 and then follow the next few steps. Good luck!


########################################################################
#Section 2: Files Specification
########################################################################
This part is used to specify the structure and details of this program

1) ISOMAKER.sh is the main script to control the whole program. 
In ISOMAKER.sh, we first check the authority of the user - this program has to be run by root, so when this program is not run by a root, it will prompt the user to use sudo or gain root authority; 
then the program will check the ks.cfg and isolinux.cfg configuration files which are quite essential for the custom iso making so if there is no backup, the program will automatically back them up but if there are backups, it will use the backups to restore ks.cfg and isolinux.cfg files which is quite essential to make the configuration files complete and clean for later use; 
after this process, the program will check the network for installing some tools online and if it's not connected, it will automatically try to fix it and propose some suggestions to fix it; 
now it's time to check necessary tools and if they are not installed, the program will try to install them for later use; 
check the /dev/cdrom and mount it to /mnt/cdrom and if this directory does not exist, create it and if it is mounted already, umount it first and if it's still unsolved, it will propose a solution to handle it; 
now it's time to do something serious, using rpm -qa to retrieve all the packages this OS needs to isomake/Packages.list and copy the packages from /mnt/cdrom/Packages/ and /var/cache/yum/*/packages to isomake/ISO/Packages/ and if there is still some packages missed, there will be a unfound_packages.list and the program will automatically propose some solutions to handle this problem and furthermore if you manually handle the packages missing problem and when you re-run this program you can directly continue the remained steps the previous try did not finish; 
now we will replace the packages part in ks.cfg with the list of isomake/Packages.list and modify the isolinux.cfg and mv them to isomake/ISO/isolinux/; 
the next step is to use the *comps.xml in isomake/ISO/repodata/ to make a repository for the custom ISO and then build the ISO using mkisofs command;
Now the custom ISO file is built and lies in isomake/ISO/;
using scp to copy the ISO file to host and use this ISO to set up the custom system and if there is something wrong with packages, solved it following the suggestions proposed by the program and re-run the program and do it all over again until it works right;

2) The configure.sh script is used to define the major building functions:
    set_local_repo,
    set_package_cache,
    set_online_repo,
    reset_package_cache,
    copy_packages_from_mnt,
    recopy_packages,
    replace_packages_list,
    customize_isolinux, 
    replace_cfg_files, 
    create_repo,
    build_ISO; 
the details is specified in their corresponding comments and the output;

3) The check_environment.sh is used to make sure the environment is sufficient for building the custom ISO file and try to fix the problem automatically and if they failed, they will propose some helpful suggestions to solve it manually and the major functions defined in this script are: 
    check_cfg, 
    check_cfgs, 
    check_network, 
    check_fix_network, 
    check_permission, 
    mount_cdrom, 
    check_files, 
    check_package, 
    check_essential_packages;
the details is specified in their corresponding comments and the output;

4) The login.sh is used to login with a granted account in ISCAS LAN to access network;

5) The set_local_installation.sh is used to set the keepcache=1 in /etc/yum.conf to cache the online installed packages and meantime restore the /var/yum.repos.d/CentOS-Base.repo to make sure the packages are installed from remote repositories instead of local ones - /mnt/cdrom;

6) The set_local_installation.sh is used to make the packages installed locally from local repository - /mnt/cdrom by modifying the /var/yum.repos.d/CentOS-Base.repo and back it up for later restoration in set_local_installation.sh;

7) ks.cfg is used to set the password for root, the packages list needed by the custom system, the auto-start programs and the like;

8) isolinux.cfg is where you can customize the titles and labels presented when installing the custom ISO.

#############################
#Section 3 Installation
#############################
git clone https://git.oschina.net/lhearen/ISOMaker.git

cd ISOMaker

./ISOMAKER.sh

Now it's time to follow the program to finish the rest of the work. Good luck!

##############################################
#Section 4 Possible problems and solutions
##############################################
After your installing the custom system, the network might not be initialized and started and as a result network may be unavailable at that time.

So at this very moment you can cd /etc/sysconfig/network-scripts/ and open the local network configuration file - mine is ifcfg-eth0, and change the 'ONBOOT' to yes and add HWADDR='your current MAC address', which can be retrieved by command 'ip a or ip addr'; and at last you should restart your network by 'service network restart'. Now if everything works right, you can ping youku.com for further test. Good luck!

#auto-installer
Used to configure Tcl and install expect on CentOS 7 - sadly this process can be easily achieved by apt-get or yum in most platforms;

#nfs-configurer
Used to configure NFS service and enable sharing files with remotes much easier;

#tools
This folder holds many convenient small tools to ease the burden of my daily tasks;

#Summary
All those shell scripts are made up for personal use, if they can ever help you a little bit, I will be much flattered. 
P.S. If there are some bad points inside, please do not hesitate to contact me and tell me about it. So many thanks in advance.
