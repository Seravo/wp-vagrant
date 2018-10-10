#!/bin/bash
set -e
set -o pipefail

IMAGE_NAME="seravo/wordpress:development"
CONTAINER_NAME="seravo_wordpress"

if [ "$(id -u)" != "0" ]
then
    sudo "$0" "$@"
fi

if [ -e "/data/wordpress/.seravo-env" ]
then
    ENVFILE="/data/wordpress/.seravo-env"
else
    ENVFILE="/usr/share/seravo/env"
fi

COMMAND="${1:-autostart}"
case "${COMMAND}"
in
    enter)
        set +e
        while true
        do
            sudo docker exec -it seravo_wordpress bash && break
            sleep 1
        done
        set -e
    ;;
    create)
        shift
        echo "I: Create new container"
        mkdir -p /data/db/mysql
        ID="$(docker create \
            --name "${CONTAINER_NAME}" \
            --env-file "${ENVFILE}" \
            --publish "80:80" \
            --publish "443:443" \
            --publish "2222:22" \
            --publish "3306:3306" \
            --publish "9000:9000" \
            --volume "/data:/data" \
            --volume "/data/db/mysql:/var/lib/mysql" \
            --restart "always" \
            "$@" \
            "${IMAGE_NAME}")"
        if [ -z "${ID}" ]
        then
            echo "E: Container creation failed!"
            exit 1
        fi
    ;;
    maybe-create)
        set +e
        docker ps |grep -q seravo_wordpress
        if [ "$?" = "1" ]
        then
            shift
            $0 create "$@"
        fi
        set -e
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
    autostart)
        if [ -e "/data/wordpress/.seravo_autoupdate" ]
        then
            $0 pull
            $0 remove
        fi
        $0 maybe-create
        $0 start
        exit 0
    ;;
    shell)
        shift
        #
        # Docker SSH shell forwarder
        #
        # Makes all 'vagrant ssh' invocations seamslessly run inside the Docker container
        # and not on the host Vagrant box, making it a fully transparent boot2Docker host.
        #
        # To escape this dockershell and get to the host Vagrant box, run
        #  touch .seravo-controller-shell # in wordpress project repo
        #  vagrant ssh
        #

        SSH_FLAGS="-A -i "/home/vagrant/.ssh/id_rsa_vagrant" -p 2222 -o StrictHostKeyChecking=no"
        echo "entering site container... (ssh -- $@)"
        
        if [ -n "${SCSHELL_WRAPPER}" ]
        then
            # When running via the wp-wrapper, keep SSH silent with -q to
            # avoid displaying too many SSH banners.
            ssh ${SSH_FLAGS} -q root@localhost "$@"
            exit 0
        else
            ssh ${SSH_FLAGS} vagrant@localhost "$@"
            exit 0
        fi
    ;;
    wait-mounts)
        MPATH="/data/wordpress/config.yml"
        
        for i in $(seq -s " " 15)
        do
            if [ -e "${MPATH}" ]
            then
                # vagrant mount succesful, exit & allow docker to launch
                exit 0
            fi
            sleep 5
        done
        
        echo "ERROR: Mounting /data failed, '${MPATH}' not found!"
        exit 1
    ;;
    log|logs)
        docker logs --follow seravo_wordpress
    ;;
esac

