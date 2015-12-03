
############################################################################
#When using DHCP login process is quite essential to access external network
############################################################################
function login_network {
    tmp=`mktemp curl_tmp.XXX`
    echo "Using a fixed account to login - simulating browser login process."
    curl -d "username=tao&password=111111&pwd=111111&secret=true" http://133.133.133.150/webAuth/ >tmp 2>/dev/null
    result=`cat tmp | sed -n '/authfailed/p'`
    if [ -n "$result" ]
    then
        echo "Login Failed!"
    else
        echo "Successfully login!!"
    fi
    rm -f $tmp
}

login_network
