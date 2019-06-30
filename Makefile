.DEFAULT_GOAL := test
SHELL := /usr/bin/env bash
MAKEFLAGS += s

APP_NAME := acestream-server
VERSION := 3.1.16

build:
	docker build --compress -t ${APP_NAME} . && \
	docker tag acestream-server pabsi/acestream-server:$VERSION

test:
	docker run --rm --name ${APP_NAME} -P -it ${APP_NAME}

shell:
	docker exec -it ${APP_NAME} bash

push:
	docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
	docker push pabsi/acestream-server:$VERSION
