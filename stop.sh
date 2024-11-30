#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

CONTAINER_NAME=gen8diagram
IMAGE_NAME=gen8diagram
IMAGE_VERSION=latest
GEN8_PORT=5050
WORK_DIR=${SCRIPT_DIR}

# kill prior instances
podman ps | grep ${IMAGE_NAME} | awk '{print $1}' | xargs podman kill
podman rm ${CONTAINER_NAME}



