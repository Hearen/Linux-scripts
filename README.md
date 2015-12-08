* Author: LHearen
* E-mail: LHearen@126.com

# Linux-scripts
Used to automate some big tasks in linux environment

# ISOMaker Introduction
##################################################
### Section 1: Basic Rules to Make a Custom CentOS 7 
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
### Section 2: Files Specification
########################################################################
This part is used to specify the structure and details of this program and is specified in its own folder.

#############################
### Section 3 Installation
#############################
git clone https://git.oschina.net/lhearen/ISOMaker.git

cd ISOMaker

./ISOMAKER.sh

Now it's time to follow the program to finish the rest of the work. Good luck!

##############################################
### Section 4 Possible problems and solutions
##############################################
After your installing the custom system, the network might not be initialized and started and as a result network may be unavailable at that time.

So at this very moment you can cd /etc/sysconfig/network-scripts/ and open the local network configuration file - mine is ifcfg-eth0, and change the 'ONBOOT' to yes and add HWADDR='your current MAC address', which can be retrieved by command 'ip a or ip addr'; and at last you should restart your network by 'service network restart'. Now if everything works right, you can ping youku.com for further test. Good luck!

###############
# auto-installer
###############
Used to configure Tcl and install expect on CentOS 7 - sadly this process can be easily achieved by apt-get or yum in most platforms;

###############
# nfs-configurer
###############
As you may know, the nfs - abbreviated from Network File System is a distributed file system protocol enable a client can access files in the remotes much like local files.

Used to configure NFS service and enable sharing files with remotes much easier;

With this little tool, you can easily configure nfs-server and share your local files with certain remotes which can be configured by the hostname part - regx supported for a range of hosts.

######
# tools
######
This folder holds many convenient small tools to ease the burden of my daily tasks;

They are currently consisting of:
* capsOverlapper + speedswapper                             - disable CapsLock and set it to ESC
* ip_checker                                                - used to check the regx's validity
* color                                                     - check the color usage in shell
* dialog_progress + progressbar + spinner + percent_counter - all are used to indicate the running status in shell
* sudo                                                      - used to gain root privilege much easier by expect command
* my_ssh                                                    - used to login the remote client and 'cd' to a certain working directory
* login                                                     - used to automatically log in the authentication page in LAN
* firefox                                                   - can set several frequently visisted pages to access
* pool_management_configurer                                - configure my personal pool management environment automatically

########
# Summary
########
All those shell scripts are made up for personal use, if they can ever help you a little bit, I will be much flattered. 
P.S. If there are some bad points inside, please do not hesitate to contact me and tell me about it. So many thanks in advance.
