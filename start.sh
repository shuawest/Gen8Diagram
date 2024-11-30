#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

CONTAINER_NAME=gen8diagram
IMAGE_NAME=gen8diagram
IMAGE_VERSION=latest
GEN8_PORT=5050
WORK_DIR=${SCRIPT_DIR}

pushd $SCRIPT_DIR

# kill prior instances
podman ps | grep ${IMAGE_NAME} | awk '{print $1}' | xargs podman kill
podman rm ${CONTAINER_NAME}

# build new container image
podman build -t ${IMAGE_NAME} . 

# start the gen8diagram container
podman run -d --name ${CONTAINER_NAME} -p ${GEN8_PORT}:5050 -v "${WORK_DIR}":/app -w /app ${IMAGE_NAME}:${IMAGE_VERSION}

# display how to access it
echo "Use the editor at http://localhost:${GEN8_PORT}/"

popd

# Interactively log into the container
#   podman run -it --entrypoint /bin/bash localhost/gen8diagram:latest



