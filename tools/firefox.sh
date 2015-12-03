#########################################################
#Used to run firefox in background and open certain sites
#Redirecting stderr and stdout to /dev/null
#########################################################
exec 1>/dev/null
exec 2>/dev/null
if [ $# -eq 0 ]
then
    nohup /usr/local/firefox/firefox baidu.com &
else
    case $1 in
    b)
        nohup /usr/local/firefox/firefox baidu.com &
        ;;
    mail)
        nohup /usr/local/firefox/firefox 126.com&
        ;;
    t|y)
        nohup /usr/local/firefox/firefox youku.com &
        ;;
    *)
        nohup /usr/local/firefox/firefox baidu.com &
    esac
fi
exit 0

