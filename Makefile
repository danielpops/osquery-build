SHELL := /bin/bash
TAG=${whoami}-osquery-build

DISTRIBUTIONS=lucid trusty xenial

DOCKER_BUILD = $(addprefix docker_build_,${DISTRIBUTIONS})
DOCKER_RUN = $(addprefix docker_run_,${DISTRIBUTIONS})
DOCKER_EXEC = $(addprefix docker_exec_,${DISTRIBUTIONS})
DOCKER_STOP = $(addprefix docker_stop_,${DISTRIBUTIONS})

all:
	echo >&2 "Must specify target."

whoami    := $(shell whoami)

${DOCKER_BUILD}: docker_build_%:
	docker build -f dockerfiles/$*/Dockerfile -t $(TAG)-$* .

${DOCKER_RUN}: docker_run_%:
	docker run -it --rm -h docker-$(TAG)-$* --entrypoint /bin/bash --name $(TAG)-$* $(TAG)-$*

${DOCKER_EXEC}: docker_exec_%:
	docker exec -it $(TAG)-$* /bin/bash

${DOCKER_STOP}: docker_stop_%:
	docker stop $(TAG)-$* && docker rm -f $(TAG)-$*

.PHONY: all test docker_build docker_run docker_exec docker_stop
