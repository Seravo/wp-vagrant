#!/bin/bash
set -e
set -o pipefail

IMAGE_NAME="seravo/wordpress:development"
CONTAINER_NAME="seravo_wordpress"
HOSTNAME="$(hostname -s)"
# The end user will see the hostname of the Docker container in their terminal
# window title and in the console prompt. Inheriting the hostname from the host
# is good as Vagrant automatically assigns it the box name.

COMMAND="${1:-autostart}"
case "${COMMAND}"
in
    enter)
        set +e
        while true
        do
            sudo docker exec -it "${CONTAINER_NAME}" bash && break
            sleep 1
        done
        set -e
    ;;
    create)
        shift
        echo "I: Create new container"
        ID="$(docker create \
            --name "${CONTAINER_NAME}" \
            --hostname "${HOSTNAME}" \
            --publish "80:80" \
            --publish "443:443" \
            --publish "2222:22" \
            --publish "3306:3306" \
            --publish "1337:1337" \
            --publish "1338:1338" \
            --publish "8080:8080" \
            --publish "9000:9000" \
            --volume "/data:/data" \
            --restart "always" \
            "$@" \
            "${IMAGE_NAME}")"

        # NOTE! If running pure Docker without a VirtualBox wrapper, remember
        # to expose Avahi ports with:
        #   --publish "5353:5353" \
        #   --publish "5353:5353/udp" \

        # Update Avahi hostname to match container hostname
        sed "s/wordpress.local/$HOSTNAME.local/g" -i /etc/avahi/services/http.service
        # Ensure hostname change takes effect
        systemctl restart avahi-daemon

        if [ -z "${ID}" ]
        then
            echo "E: Container creation failed!"
            exit 1
        fi
    ;;
    maybe-create)
        set +e
        docker ps | grep -q "${CONTAINER_NAME}"
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
        echo "I: Start container"
        docker start "${CONTAINER_NAME}"
        exit 0
    ;;
    autostart)
        echo "I: Autostart container"
        if [ -e "/data/wordpress/.seravo-controller-autoupdate" ]
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

        SSH_FLAGS="-A -i /home/vagrant/.ssh/id_rsa_vagrant -p 2222 -o StrictHostKeyChecking=no "
        echo "Connecting to local Vagrant environment... (ssh -- $*)"

        # Count total wait time to be able to bale out if SSH never seems to get up
        TIME_PASSED=0

        # Always wait first for 10 seconds that Docker had a chance to start
        sleep 10

        # Wait for SSH port to become operational
        while ! ssh ${SSH_FLAGS} -q localhost echo "SSH connection confirmed"
        do
            # If too much time has passed, just abort and exit
            if  [[ "$TIME_PASSED" -gt 60 ]]
            then
              echo "Previous event:"
              docker logs --tail 50 "${CONTAINER_NAME}" || true
              echo "SSH did not come online in 60 seconds, aborting..."
              exit

            else
              echo "Previous event:"
              docker logs --tail 1 "${CONTAINER_NAME}" || true
              echo "Waiting for SSH to come online..."

              sleep 5
              TIME_PASSED=$((TIME_PASSED+5))
            fi
        done

        if [ -n "${SCSHELL_WRAPPER}" ]
        then
            # When running via the wp-wrapper, keep SSH silent with -q to
            # avoid displaying too many SSH banners.
            SSH_FLAGS+="-q "
        fi

        # If SSH session was interactive and a (pseudo) tty was allocated, continue
        # to do so in the subsession so that all interactive prompts can work
        if [ -t 1 ]
        then
          echo "SSH session is interactive"
          SSH_FLAGS+="-t "
        fi

        # Always enter as user 'vagrant'. None of our commands need root, or if
        # they do, the command can be prefixed with 'sudo'.
        ssh ${SSH_FLAGS} vagrant@localhost "$@"

    ;;
    wait-mounts)
        MPATH="/data/wordpress/config.yml"

        for _ in $(seq -s " " 15)
        do
            if [ -e "${MPATH}" ]
            then
                # Vagrant mount successful, exit & allow Docker to launch
                exit 0
            fi
            sleep 5
        done

        echo "ERROR: Mounting /data failed, '${MPATH}' not found!"
        exit 1
    ;;
    log|logs)
        docker logs --follow "${CONTAINER_NAME}"
    ;;
    stop)
        # Triggers to run when Vagrant box is stopped/halted
        echo "I: Stop container"
        # Give the Docker container 60 seconds to exit gracefully, e.g. dump
        # the database and run other triggers
        docker stop --time=60 "${CONTAINER_NAME}"
    ;;
esac
