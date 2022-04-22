#!/bin/zsh



# Help
usage() { echo "Usage: $0 [-s <session-name>] [-n <no. of windows <=10>]" 1>&2; exit 1; }

#get arguments
while getopts s:n: flag
do
    case "${flag}" in
        s) 
            sessionName=${OPTARG}
            ;;
        n) 
            numWindows=${OPTARG}
            ((numWindows <= 10)) || usage
            ;;
        *) 
            usage
            ;;
    esac
done

#shift "$((OPTIND-1))"

if [ -z "$sessionName" ] || [ -z "$numWindows" ]; then
    usage
fi

#Checks if session already exists
tmux has-session -t $sessionName

#if not then process create request
if [ $? != 0  ]
then
    tmux new-session -s $sessionName -n Launch -d

    #Add windows to it
    for ((i=1;i<=$numWindows;i++))
    do
        echo "tmux new-window -n $i -t $sessionName"
        tmux new-window -n $i -t $sessionName
    done
fi

#Attach the session
tmux attach -t $sessionName
