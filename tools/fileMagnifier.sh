#-------------------------------------------
# Author      : LHearen
# E-mail      : LHearen@126.com
# Time        : 2016-10-25 15:07
# Description : Used to magnify a txt file exponentially;
#-------------------------------------------
#!/bin/bash
echo 
echo "This little script is used to magnify a file by exponential times."
echo "Usage: ./this_script [source file] [exponential times] [destination file]"

src_file=$1
times=$2
des_file=$3

if [ ! -f "$src_file" ]; then
    echo "Source file [$src_file] doesn't exist!"
fi

if (( times < 1 )); then
    echo "Incorrect exponential times $times!"
    exit 1
fi

tput setaf 4
echo "You wanna the [$src_file] file to be magnified by [$times] times exponentially to [$des_file]."
echo "If not, press [Ctrl+C] to terminate or press [Enter] to proceed."
tput sgr0
read -n1 confirm

tmp_file=`mktemp tmp.XXX`
times=$(($times*2+2))

date
echo "Start to magnify $src_file to $des_file ..."
for i in `seq 1 $times`
do
    if (( i == 1 ))
    then
        cat "$src_file" >> "$tmp_file"
    else
        if (( i%2==0 ))
        then
            cat "$tmp_file" > "$des_file"
            tput setaf 4
            ls -alh $des_file
            tput sgr0
        else
            cat "$des_file" >> "$tmp_file"
        fi
    fi
done

rm -f $tmp_file

echo "Completed!"
date

tput setaf 4
ls -alh $src_file
ls -alh $des_file
tput sgr0
