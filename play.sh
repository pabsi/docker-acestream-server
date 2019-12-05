#!/bin/sh
echo -n "Starting ACE Stream Server... "
docker run -d --rm --name acestream-server -p 6878:6878 -it pabsi/acestream-server || exit 1
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
acestream-launcher -p vlc "$1"

echo -n "Stopping ACE Stream Server... "
docker rm -f acestream-server

exit $?
