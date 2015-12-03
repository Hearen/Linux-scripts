#!/bin/bash
if [ ! -d pool_res ] 
then
	mkdir pool_res
fi
result=$(mount -l | sed -n 's@133.133.133.128:/home/OnceServer/pool_management/bn-xend-core/xend on /home/pool_res@success@; /success/p')
if [ ! "$result" ]
then
   umount pool_res 2>/dev/null 
   mount 133.133.133.128:/home/OnceServer/pool_management/bn-xend-core/xend pool_res 
   echo "mount 133.133.133.128:/home/OnceServer/pool_management/bn-xend-core/xend pool_res"
else
   echo "pool_res already mounted!"
fi
#cp -r pool_res/* /usr/lib64/python2.6/site-packages/xen/xend
rsync --progress -rh pool_res/* /usr/lib64/python2.6/site-packages/xen/xend
echo "Restarting xend..."
/etc/init.d/xend restart
