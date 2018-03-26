GOOS=linux
GOARCH=mips64
COMMIT=`git rev-parse --short HEAD`
APP?=docker-proxy
REPO?=swarm
TAG?=latest
export GO15VENDOREXPERIMENT=1

all: build image
build:
	@go build .
build-static:
	@go build -a -tags "netgo static_build" -installsuffix netgo .
image:
	@docker build -t $(REPO):$(TAG) .

.PHONY: build build-static image clean
