#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

IMAGE_NAME=gen8diagram
IMAGE_VERSION=0.5

QUAY_REPO=quay.io/jowest/gen8diagram

CONTAINER_NAME=gen8diagram
GEN8_PORT=5050
WORK_DIR=${SCRIPT_DIR}/..
