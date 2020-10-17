#!/bin/bash
function ctrlc_kill_docker()
{
	echo -n "Force killing ACE Stream Server... "
	docker rm -f acestream-server
	exit
}

# Trap Ctrl-C
trap ctrlc_kill_docker SIGINT

echo -n "Starting ACE Stream Server... "
docker run -d --rm --name acestream-server -p 6878:6878 -it pabsi/acestream-server:latest || exit 1
echo "ACE Stream Server started. Waiting for it to be ready..."

while true
do
	state="$(docker inspect --format='{{ json . }}' acestream-server | jq -r .State.Health.Status)"
	if [ "$state" = "healthy" ]
	then
		break
	fi
	sleep 0.5
done

echo "ACE Stream Server is now ready and listening for connections. Launching ACE Stream Player..."
acestream-launcher -p vlc "$1" || true

echo -n "Stopping ACE Stream Server... "
docker rm -f acestream-server
