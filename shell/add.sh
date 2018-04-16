#!/bin/bash
HOSTIP=$(ifconfig -a|grep inet|grep -v 0.0.0.0|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:")
echo $HOSTIP
if [ -z $1 ];then
echo "please shipyard server IP....."
else
	docker run -ti -d --name shipyard-swarm-agent swarm join --addr $HOSTIP:2375 etcd://$1:4001/swarm
	SWARM=$(docker ps |awk '{print $4}'| grep "join")
	while [ -z $SWARM ]
	do
		 docker rm $(docker ps -qa --filter name=shipyard-swarm-agent)
		 docker run -ti -d --name shipyard-swarm-agent swarm join --addr $HOSTIP:2375 etcd://$1:4001
		 SWARM=$(docker ps |awk '{print $4}'| grep "join")
	done
fi
