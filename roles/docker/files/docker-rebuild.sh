#!/bin/bash
set -e
set -o pipefail

# If there is 1 or more arguments, just create the container
# but don't start it.
ONLY_CREATE="$1"

echo "I: Pull latest box from Docker Hub"
docker pull seravo/wordpress:vagrant

echo "I: Remove current container"
# it's ok for this to fail, eg. if container doesn't exist yet
set +e
docker rm --force seravo_wordpress 
set -e

echo "I: Create new container"
ID="$(docker create \
    --name seravo_wordpress \
    --volume "/data:/data" \
    --publish "80:80" \
    --publish "443:443" \
    --publish "3306:3306" \
    --publish "2222:22" \
    --publish "9000:9000" \
    --restart always \
    seravo/wordpress:vagrant)"

if [ -z "${ID}" ]
then
    echo "E: Container creation failed!"
    exit 1
fi

if [ -n "${ONLY_CREATE}" ]
then
    echo "I: Container creation completed, id ${ID}"
    exit 0
fi

echo "I: Start new container"
docker start "${ID}"
