#!/bin/bash
##########################
# Author: LHearen 
# E-mail: LHearen@126.com 
##########################
#When using DHCP login process is quite essential to access external network
function login_network {
    userName=$1
    password=${2-111111}
    while [ 1 ]
    do
        tmp=$(mktemp curl_tmp.XXX)
        echo "Using a fixed account to login - simulating browser login process."
        echo "curl -d 'username=$userName&password=$password&pwd=$password&secret=true' http://133.133.133.150/webAuth/ >$tmp 2>/dev/null"
        curl -d "username=$userName&password=$password&pwd=$password&secret=true" http://133.133.133.150/webAuth/ >$tmp 2>/dev/null
        result=$(cat $tmp | sed -n '/authfailed/p')
        if [ ! -s "$tmp" ]
        then
            echo "NoResponse!"
            sleep 3s
            rm -f $tmp
            continue
        else
            rm -f $tmp
            if [ -n "$result" ]
            then
                echo "AuthFailed!"
                echo "Hint: in this case, you either have already logged in or you are using a wrong account."
                break
            else
                echo "Successfully log in!!"
                break
            fi
        fi
    done
}

echo "[Usage: userName, password[default: 111111]]"
read -p "userName:" userName
echo "If you would like to use default value (111111) just Press Enter instead."
read -p "password:" password
login_network $userName $password
