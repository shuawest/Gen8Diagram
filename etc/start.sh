#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source $SCRIPT_DIR/settings.sh

pushd $SCRIPT_DIR/..

echo "Starting in $PWD"

# build new container image
echo "podman build -t ${IMAGE_NAME}:${IMAGE_VERSION} . "
podman build -t ${IMAGE_NAME}:${IMAGE_VERSION} . 

# kill prior instances
podman ps | grep ${IMAGE_NAME} | awk '{print $1}' | xargs podman kill
podman rm ${CONTAINER_NAME}

# start the gen8diagram container
echo "podman run -d --name ${CONTAINER_NAME} -p ${GEN8_PORT}:5050 -v './':/app -w /app localhost/${IMAGE_NAME}:${IMAGE_VERSION}"
podman run -d --name ${CONTAINER_NAME} -p ${GEN8_PORT}:5050 -v './':/app -w /app localhost/${IMAGE_NAME}:${IMAGE_VERSION}

# display how to access it
echo "Use the editor at http://localhost:${GEN8_PORT}/"

popd

# Interactively log into the container
#   podman run -it --entrypoint /bin/bash localhost/gen8diagram:latest



