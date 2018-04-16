#!/bin/bash
docker ps | awk '{print $1}'|sed '1d'|xargs docker kill
docker rm $(docker ps -qa --filter name=shipyard)

HOSTIP=$(ifconfig -a|grep inet|grep -v 0.0.0.0|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:")
DeleteName()
{
	docker rm $(docker ps -qa --filter name=$1)

}
#step 1 start retninkdb
docker run -ti -d -p 8080:8080 --name shipyard-rethinkdb docker.isoft.zhcn.cc/zhuyaliang/rethinkdb
RETHINK=$(docker ps |awk '{print $2}'| grep "rethinkdb")
while [ -z $RETHINK ]
do
	DeleteName shipyard-rethinkdb
	docker run -ti -d -p 8080:8080 --name shipyard-rethinkdb docker.isoft.zhcn.cc/zhuyaliang/rethinkdb
	RETHINK=$(docker ps |awk '{print $2}' | grep "rethinkdb")
done
 
#step 2 start etcd
docker run -ti -d -p 4001:4001 --name shipyard-discovery docker.isoft.zhcn.cc/zhuyaliang/etcd -name discovery
ETCD=$(docker ps |awk '{print $2}'| grep "etcd")
while [ -z $ETCD ]
do
	DeleteName shipyard-discovery
	docker run -ti -d -p 4001:4001 --name shipyard-discovery docker.isoft.zhcn.cc/zhuyaliang/etcd -name discovery
	ETCD=$(docker ps |awk '{print $2}'| grep "etcd")
done
 
#step 3 start docker-proxy
docker run  -ti -d -p 2375:2375 --hostname=$HOSTNAME --name shipyard-proxy -v /var/run/docker.sock:/var/run/docker.sock -e PORT=2375docker.isoft.zhcn.cc/zhuyaliang/docker-proxy:latest
PROXY=$(docker ps |awk '{print $2}'| grep "docker-proxy")
while [ -z $PROXY ]
do
	DeleteName shipyard-proxy
	docker run  -ti -d -p 2375:2375 --hostname=$HOSTNAME --name shipyard-proxy -v /var/run/docker.sock:/var/run/docker.sock -e PORT=2375 docker.isoft.zhcn.cc/zhuyaliang/docker-proxy:latest
	PROXY=$(docker ps |awk '{print $2}'| grep "docker-proxy")
done

#step 4 start swarm
docker run  -ti -d -p 2376:2375 --name shipyard-swarm-manager  docker.isoft.zhcn.cc/zhuyaliang/swarm:latest manage -H=0.0.0.0:2375 etcd://192.168.30.66:4001/swarm
SWARM=$(docker ps |awk '{print $2}'| grep "swarm")
while [ -z $SWARM ]
do
	DeleteName shipyard-swarm-manager
	docker run  -ti -d -p 2376:2375 --name shipyard-swarm-manager docker.isoft.zhcn.cc/zhuyaliang/swarm:latest manage -H=0.0.0.0:2375 etcd://192.168.30.66:4001/swarm
	SWARM=$(docker ps |awk '{print $2}'| grep "swarm")
done
sleep 20
#step 5 start shipyard
docker run -ti -d  --link shipyard-rethinkdb:rethinkdb --link shipyard-swarm-manager:swarm -p 8083:8080 docker.isoft.zhcn.cc/zhuyaliang/shipyard:v0.0.2 server -d tcp://swarm:2375
SHIPYARD=$(docker ps |awk '{print $2}'| grep "shipyard/shipyard")
while [ -z $SHIPYARD ]
do
	DeleteName shipyard-controller
	docker run -ti -d  --link shipyard-rethinkdb:rethinkdb --link shipyard-swarm-manager:swarm -p 8083:8080 docker.isoft.zhcn.cc/zhuyaliang/shipyard:v0.0.2  server -d tcp://swarm:2375
	SHIPYARD=$(docker ps |awk '{print $2}'| grep "shipyard/shipyard")
done
echo "success"
