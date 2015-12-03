########################
#Author: LHearen
#E-mail: LHearen@126.com, luosonglei14@otcaix.iscas.ac.cn
########################

This little program is used to automatically set up NFS server for users to conveniently share files among different remotes

########################################################################
#Section 1 How to make a CentOS 7 system to share resources with remotes
########################################################################
1) To make sure the program run properly, the user has to gain root privilege - so the first thing it will check is the actor of the user;

2) Since we have to install nfs-utils to set up the nfs-server, the network is another critic element the program is about to check and when it's not available, it will prompt the user to fix it of course the program will firstly try to fix it;

3) After all of above conditions met, the program will check the essential packages and then download and install them automatically;

4) Configure the environment - enable the nfs service to make sure it will be persistent even after reboot unless manually disable it, after which the program will automatically start it too;

5) Edit the /etc/exports to make the sharing rules in format: sharing_files hostname|ip(conditions) to share files with hostname|ip;

6) Besides to make the program convenient, there are choices for the user to select to add another rule or just replace the previous rules at the very beginning of the program;

7) To make the program more tolerant, it will also check the existence of the input directory and prompt the user about its error when it's incorrect.

#######################
#Section 2 Installation
#######################
git clone https://git.oschina.net/lhearen/nfs_configurer.git

cd nfs_configurer

./configure

Then just follow the hints of the program and enjoy convenient little tool!

###############
#Section 3 ToDo
###############
There are many aspects for this little program to better way up.

1. More can be automated - check the current sharing files;

2. More can be checked - hostname or ip can be more carefully checked before writing down;

3. More can be beautified - the whole UI is pretty coarse and kind of ugly, maybe dialog or zenity is a choice;

Still on...

