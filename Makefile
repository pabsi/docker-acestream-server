.DEFAULT_GOAL := test
SHELL := /usr/bin/env bash
MAKEFLAGS += s

APP_NAME := acestream-server

build:
	docker build --compress -t ${APP_NAME} .

test:
	docker run --rm --name ${APP_NAME} -p 6878:6878 -it ${APP_NAME}

shell:
	docker exec -it ${APP_NAME} bash
