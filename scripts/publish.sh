#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source $SCRIPT_DIR/settings.sh

# build new container image
pushd ${SCRIPT_DIR}/..
podman build -t ${QUAY_REPO}:${IMAGE_VERSION} .
popd

podman tag localhost/${IMAGE_NAME}:${IMAGE_VERSION} ${QUAY_REPO}:${IMAGE_VERSION}
podman push ${QUAY_REPO}:${IMAGE_VERSION}

podman tag localhost/${IMAGE_NAME}:${IMAGE_VERSION} ${QUAY_REPO}:latest
podman push ${QUAY_REPO}:latest

