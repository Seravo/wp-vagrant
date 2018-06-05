#!/bin/bash
set -e
set -o pipefail

IMAGE_NAME="seravo/wordpress:vagrant"
CONTAINER_NAME="seravo_wordpress"

COMMAND="${1:-all}"
case "${COMMAND}"
in
    create)
        echo "I: Create new container"
        ID="$(docker create \
            --name "${CONTAINER_NAME}" \
            --publish "80:80" \
            --publish "443:443" \
            --publish "2222:22" \
            --publish "3306:3306" \
            --publish "9000:9000" \
            --volume "/data:/data" \
            "${IMAGE_NAME}")"
        if [ -z "${ID}" ]
        then
            echo "E: Container creation failed!"
            exit 1
        fi
    ;;
    pull)
        echo "I: Pull latest box from Docker Hub"
        docker pull "${IMAGE_NAME}"
        exit 0
    ;;
    remove)
        echo "I: Remove current container"
        # it's ok for this to fail, eg. if container doesn't exist yet
        set +e
        docker rm --force "${CONTAINER_NAME}" || true
        sleep 5
        set -e
        exit 0
    ;;
    start)
        echo "I: Start new container"
        docker start "${CONTAINER_NAME}"
        exit 0
    ;;
    pull-and-create)
        $0 pull
        $0 remove
        $0 create
    ;;
    create-and-start)
        $0 remove
        $0 create
        $0 start
    ;;
    all)
        $0 pull
        $0 remove
        $0 create
        $0 start
        exit 0
    ;;
esac

