#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source $SCRIPT_DIR/settings.sh

# kill prior instances
podman ps | grep ${IMAGE_NAME} | awk '{print $1}' | xargs podman kill
podman rm ${CONTAINER_NAME}



