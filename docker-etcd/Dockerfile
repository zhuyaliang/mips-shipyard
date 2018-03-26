#FROM        microbox/scratch
FROM	docker.isoft.zhcn.cc/yetist/minibox

ADD         etcd-v0.4.9-linux-mips64le/etcd        /bin/etcd

# exclude the cli tool to reduce the size of the image
#ADD         etcd-v0.4.9-linux-mips64le/etcdctl     /bin/etcdctl

VOLUME ["/data"]

EXPOSE 4001 7001

ENTRYPOINT ["/bin/etcd"]

CMD ["-data-dir=/data"]
