#!/bin/bash

function closeAll
{
    xdotool search --name '13' >> remove.txt
    xdotool search --name 'lhearen@localhost' >> remove.txt
    xdotool search --name 'server*' >> remove.txt
    xdotool search --name 'mongo' >> remove.txt

    xdotool getactivewindow >> remove.txt
    windows=$(cat remove.txt)
    for window in $windows
    do
            xdotool windowactivate $window key shift+ctrl+q
    done
}

closeAll
