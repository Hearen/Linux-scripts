
############################################################################
#When using DHCP login process is quite essential to access external network
############################################################################
function login_network {
    while [ 1 ]
    do
        tmp=$(mktemp curl_tmp.XXX)
        echo "Using a fixed account to login - simulating browser login process."
        echo "curl -d 'username=luosonglei14&password=111111&pwd=111111&secret=true' http://133.133.133.150/webAuth/ >$tmp 2>/dev/null"
        curl -d "username=luosonglei14&password=111111&pwd=111111&secret=true" http://133.133.133.150/webAuth/ >$tmp 2>/dev/null
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
                break
            else
                echo "Successfully login!!"
                break
            fi
        fi
    done
}

login_network
