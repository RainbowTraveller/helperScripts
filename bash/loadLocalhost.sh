#!/bin/sh
while true
do

        httperf --server localhost --wlog Y,wlog.log --num-conns 500000 --rate 800

        sleep 900

        while true
        do
                sleep 120
                if  pgrep -x httperf
                then
                        echo 'process is alive'
                else
                        break
                fi
        done
done
