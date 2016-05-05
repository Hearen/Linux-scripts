#!/bin/bash
#####################################################################################
#Author      : LHearen
#E-mail      : LHearen@gmail.com
#Time        : Thu, 2016-05-05 14:46
#Description : Used to logout from ISCAS network;
#####################################################################################

function logout_network {
    tmp=$(mktemp tmp_logout.XXX)
    t=$(date +%s)
    echo "curl http://133.133.133.150/ajaxlogout?_t=$t >$tmp"
    curl http://133.133.133.150/ajaxlogout?_t=$t >$tmp
    echo "Logout request sent successfully!"
    echo
    rm -f $tmp
}

logout_network

exit 0
