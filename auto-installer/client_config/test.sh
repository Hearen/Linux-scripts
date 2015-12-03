#!/bin/bash


function tcl_installer {
    result=`ls /usr/tcl/bin | grep expect`
    if [ -n "$result" ]
    then
        return 0
    fi
     old_path=`pwd`
     tar xfvz tcl*-src.tar.gz 
     cd tcl*/unix 
     ./configure --prefix=/usr/tcl --enable-shared 
     make 
     make install 
     cd $old_path
    result=`ls /usr/tcl/bin `
    if [ -n "$result" ]
    then
        return 0
    else
        return 1
    fi
}

function expect_installer {
    result=`ls /usr/bin | grep expect`
    if [ -n "$result" ]
    then
        return 0
    fi
    old_path=`pwd`
    tar xfvz expect5.45.tar.gz 1>/dev/null 2>/dev/null
    cd expect* 
    ./configure --prefix=/usr/expect --with-tcl=/usr/tcl/lib --with-tclinclude=../tcl*/generic 1>/dev/null 2>/dev/null
    make 1>/dev/null 2>/dev/null
    make install 1>/dev/null 2>/dev/null
    ln -s /usr/tcl/bin/expect /usr/bin/expect 1>/dev/null 2>/dev/null
    cd $old_path
    result=`ls /usr/bin | grep expect`
    if [ -n "$result" ]
    then
        return 0
    else
        return 1
    fi
}
tcl_installer

if [ $? -eq 0 ]
then
    echo "***************************"
    echo "Tcl installed successfully!"
    echo "***************************"
    expect_installer
    if [ $? -eq 0 ]
    then
        echo "***************************"
        echo "Expect installed successfully!"
        echo "***************************"
    fi
else
    echo
    echo "Tcl installation failed!"
fi
