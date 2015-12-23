#!/bin/bash
#-------------------------------------------
# Author      : LHearen
# E-mail      : LHearen@126.com
# Time        : 2015-12-23 16:58
# Description : Used to open several terminals and execute 
#               some commands in each terminal to prepare 
#               the working environment;
#-------------------------------------------
function open
{
    gnome-terminal --title='mongo' -x bash -c "nohup mssh 13"
    gnome-terminal --title='server running' -x bash -c "setsid mssh 13"
    gnome-terminal --title='13' -x bash -c "mssh 13"
    gnome-terminal --title='localEditor' -x bash
}

function closeAll
{
    tmpfile=$(mktemp remove.XXX)
    xdotool search --name '13' >> $tmpfile
    xdotool search --name 'lhearen @ localhost' >> $tmpfile
    xdotool search --name 'server*' >> $tmpfile
    xdotool search --name 'mongo' >> $tmpfile

    #xdotool getactivewindow >> $tmpfile
    windows=$(cat $tmpfile)
    for window in $windows
    do
            xdotool windowactivate $window key shift+ctrl+q
    done
    rm -f $tmpfile
}

echo 'Usage: prepare all terminals or close them all at once'
echo 'prepare: 1 - default value will be 1'
echo 'close all: add at least one random parameter'
if [ $# -gt 0 ]
then
    closeAll
else
    open
fi
