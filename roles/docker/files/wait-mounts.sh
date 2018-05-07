#!/bin/sh
set -e

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