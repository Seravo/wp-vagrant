#!/bin/bash
set -e
set -o pipefail

IMAGE_NAME="seravo/wordpress:development"
CONTAINER_NAME="seravo_wordpress"

COMMAND="${1:-autostart}"
case "${COMMAND}"
in
    enter)
        set +e
        while true
        do
            docker exec -it "${CONTAINER_NAME}" bash && break
            sleep 1
        done
        set -e
    ;;
    autostart)
        echo "I: Autostart container if it was not running"

        if docker container top "${CONTAINER_NAME}" > /dev/null
        then
            echo "Container is already running, not restarting it"
            exit 0
        fi
        $0 start
    ;;
    start)
        shift
        echo "I: Starting container"

        while [ "$(hostname -s)" == "seravo-wordpress" ]
        do
          echo "Hostname unchanged, waiting for hostnamectl to run..."
          sleep 1
        done

        HOSTNAME="$(hostname -s)"
        # The end user will see the hostname of the Docker container in their terminal
        # window title and in the console prompt. Inheriting the hostname from the host
        # is good as Vagrant automatically assigns it the box name.

        ID="$(docker run -d \
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
            --entrypoint "/sbin/swd_init_debug" \
            --env VAGRANT="$(cat /buildtime)" \
            "$@" \
            "${IMAGE_NAME}")"

        # Keep using swd_init_debug as long as the 'docker logs --since 5s' is
        # used, otherwise it would be shoing the same output over and over.

        # NOTE! If running pure Docker without a VirtualBox wrapper, remember
        # to expose Avahi ports with:
        #   --publish "5353:5353" \
        #   --publish "5353:5353/udp" \

        # Update Avahi hostname to match container hostname
        # Run with sudo in case sc was not invoked as root
        sudo sed "s/wordpress.local/$HOSTNAME.local/g" -i /etc/avahi/services/http.service
        # Ensure hostname change takes effect
        sudo systemctl restart avahi-daemon

        if [ -z "${ID}" ]
        then
            echo "E: Container creation failed!"
            exit 1
        fi
    ;;
    pull)
        echo "I: Pull latest box from Docker Hub"
        docker pull "${IMAGE_NAME}"
    ;;
    remove|rm)
        echo "I: Remove current container"
        # It's OK for this to fail, eg. if container doesn't exist yet
        docker rm --force "${CONTAINER_NAME}" || true
    ;;
    restart)
        echo "I: Restart container"
        if [ -e "/data/wordpress/.seravo-controller-autoupdate" ]
        then
            $0 pull
        fi
        $0 remove
        sleep 5 # wait a bit before restarting
        $0 start
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
        echo "Connecting to development environment... (ssh -- $*)"

        # Count total wait time to be able to bale out if SSH never seems to get up
        TIME_PASSED=0

        # Wait for SSH port to become operational
        # shellcheck disable=SC2086
        while ! ssh ${SSH_FLAGS} -q localhost echo "SSH connection confirmed"
        do
            echo "Waiting for SSH connection..."
            # Sleep one second longer (6-5=1) than what is the 'docker logs'
            # scope to ensure there are no duplicate lines
            sleep 6
            TIME_PASSED=$((TIME_PASSED+6))

            # Show events from Docker logs so users can have a hint about what
            # the bootstrap is doing. Don't attemd to show anything if 'docker
            # logs' failed to run. Wrapping this in a if also prevents errors
            # from stopping the whole sc script.
            if LOGS="$(docker logs --since 5s "${CONTAINER_NAME}")"
            then
                echo "Events in past 5 seconds:"
                echo "$LOGS"
            fi

            # If too much time has passed and there is nothing in the logs,
            # just abort and exit
            if [[ "$TIME_PASSED" -gt 180 ]] && [ -z "$LOGS" ]
            then
                LONGLOGS="$(docker logs --since 180s "${CONTAINER_NAME}")"
                if [ -z "$LONGLOGS" ]
                then
                    # Spit out some debug info and exit with error
                    sc debug
                    echo
                    echo "Development environment has been silent for 3 minutes" >&2
                    echo "Aborting startup" >&2
                    echo "Skipped running commands ($*)" >&2
                    echo
                    echo "If this repeats, please file an issue at https://github.com/Seravo/WordPress"
                    echo
                    exit 1
                fi
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
        # shellcheck disable=SC2086,SC2029
        ssh ${SSH_FLAGS} vagrant@localhost "$@"

    ;;
    wait-mounts)
        MPATH="/data/wordpress/config.yml"

        for _ in $(seq 30)
        do
            if [ -e "${MPATH}" ]
            then
                # Vagrant mount successful, exit & allow Docker to launch
                exit 0
            fi
            sleep 2
        done

        echo "ERROR: Mounting /data failed, '${MPATH}' not found!"
        exit 1
    ;;
    wait-log-dir)
        MPATH="/data/log"

        for _ in $(seq 60)
        do
            if find /data/log -maxdepth 0 -user vagrant > /dev/null 2>&1
            then
                # Directory exists and is owned by user
                exit 0
            fi
            echo "Waiting for /data/log to become available.."
            sleep 2
        done

        ls -la /data # Provide some debug data in failure
        echo
        echo "ERROR: Path '${MPATH}' not found!"
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
    debug)
        # Ensure debug completes and don't exit on any errors
        set +e
        echo
        echo "Bootstrap log:"
        cat /data/log/bootstrap.log
        echo
        echo "File share status:"
        mount | grep /data
        echo
        tree -L 3 /data
        echo
        echo "Docker status:"
        # sudo needed to also include last lines from journald in case
        # sc was no invoked as root
        sudo systemctl status docker --no-pager -l
        echo
        docker ps --all
        echo
        docker container top seravo_wordpress
        echo
        echo "Last 30 events:"
        docker logs --tail 30 "${CONTAINER_NAME}"
        echo
        echo "Kernel version:"
        uname -a
        echo
        echo "VirtualBox utilities version:"
        VBoxControl --version
    ;;
    *)
      echo "Unknown argument: $*"
      exit 1
    ;;
esac
