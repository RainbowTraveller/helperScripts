#!/bin/sh
while true
do

	pidlist=""
	for ip in ip1 ip2 ip3 ip4
	do
	    ssh mav@$ip 'httperf --server LOADBALANCER.elb.amazonaws.com --wlog Y,wlog.log --num-conns 500000 --rate 150' &
	    pidlist="$pidlist $!" # get the process number of the last forked process
	done

	sleep 3600

	while true
	do
		sleep 1
		alldead=true
		for ip in ip1 ip2 ip3 ip4
		do
			if ssh mav@$ip pgrep -x httperf
			then
				alldead=false
				echo 'Some process is alive'
				break
			fi
		done
		if $alldead
		then
			break
		fi
	done
done

