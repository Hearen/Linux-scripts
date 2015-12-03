#!/usr/bin/expect
########################
#Author: LHearen
#E-mail: LHearen@126.com
########################
set host [lindex $argv 0]
set name [lindex $argv 1]
set password [lindex $argv 2]
set repo_dir "/etc/yum.repos.d/CentOS-Base.repo"
set repo_url [lindex $argv 3]
spawn ssh $host -l $name
expect {
"yes/no" {send "yes\r"; exp_continue}
"password" {send "$password\r"}
}

#expect "password:" { send "$password\r" }

expect "#"
send "echo \[custom\] > $repo_dir \r" 
expect "#"
send "echo name=CentOS-custom >> $repo_dir \r" 
expect "#"
send "echo baseurl=http://$repo_url >> $repo_dir \r" 
expect "#"
send "echo gpgcheck=0 >> $repo_dir \r" 
expect "#"
send "echo gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 >> $repo_dir \r" 
expect "#"
send "exit\r" 
interact
