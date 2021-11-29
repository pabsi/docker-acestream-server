.DEFAULT_GOAL := test
SHELL := /usr/bin/env bash
MAKEFLAGS += s

REPO_NAME := pabsi
APP_NAME := acestream-server
IMAGE_NAME := ${REPO_NAME}/${APP_NAME}
VERSION := 3.1.49

build:
	docker build --compress -t ${IMAGE_NAME}:${VERSION} .
	docker tag ${IMAGE_NAME}:${VERSION} ${IMAGE_NAME}:latest

test:
	docker run --rm --name ${APP_NAME} -P -v /dev/null:/dev/disk/by-id/nvme -it ${IMAGE_NAME}

shell:
	docker run --rm -d --name ${APP_NAME} -P -it ${IMAGE_NAME}
	docker exec -it ${APP_NAME} bash
	docker stop -t1 ${APP_NAME}

push:
	docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}
	docker push ${IMAGE_NAME}:${VERSION}

security-check:
	conftest test --policy dockerfile-security.rego  Dockerfile
