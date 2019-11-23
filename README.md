# AceStream Engine server

| CI/CD | DockerHub stats |
| ----- | --------------- |
| [![Docker Build](https://img.shields.io/docker/cloud/build/pabsi/acestream-server.svg)](https://hub.docker.com/r/pabsi/acestream-server/builds) | [![Docker Pulls](https://img.shields.io/docker/pulls/pabsi/acestream-server.svg)](https://hub.docker.com/r/pabsi/acestream-server) |

## Info

Debian Jessie based docker image to run AceStream Engine

### Note

In order to be able to use `play.sh` (a wrapper to play acestream links using this docker image) you need to have installed [acestream-launcher](https://github.com/jonian/acestream-launcher) and VLC as a player.

### Make targets

To facilitate the use of this repo, I included a Makefile with some simple targets:
- `build` will build the docker image, and tag it
- `test` will run the container in the foreground
- `shell` will run the container in the background, and attach to the shell
- `push` will push to a remote repo (dockerhub)
