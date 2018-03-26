FROM docker.isoft.zhcn.cc/zhuyaliang/shipyard/rethinkdb:latest
MAINTAINER Shipyard Project "zhuyaliang"
ENV DEBIAN_FRONTEND noninteractive
EXPOSE 8080
EXPOSE 28015
EXPOSE 29015
WORKDIR /data
VOLUME /data
CMD ["--bind", "all"]
ENTRYPOINT ["/usr/bin/rethinkdb"]
