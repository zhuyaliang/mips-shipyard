FROM docker.isoft.zhcn.cc/zhuyaliang/golang:latest
COPY . /go/src/github.com/docker/swarm
WORKDIR /go/src/github.com/docker/swarm
ENV SWARM_HOST :2375
RUN cp swarm /usr/bin/.
EXPOSE 2375
VOLUME $HOME/.swarm
ENTRYPOINT ["swarm"]
CMD ["--help"]
