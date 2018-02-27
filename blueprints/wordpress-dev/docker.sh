#! /usr/bin/env bash
#
# ========================================
#
# Wrapper to build/start/stop/etc Docker containers for freckle folders.
#
# Copyright: Markus Binsteiner, 2018
# License: GPL v3


THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd -P "$THIS_DIR"

IMAGE_NAME="freckelize_`basename ${THIS_DIR}/`"
IMAGE_NAME="makkus:website_new"

NO_CACHE="--no-cache"

if [[ "$1" == "--build" ]]; then
    docker build ${NO_CACHE} -t "$IMAGE_NAME" -f Dockerfile --build-arg FRECKLES_VERSION=git --build-arg FRECKLE_CONTEXT_REPOS='-r frkl:grav' --build-arg FRECKLE_EXTRA_VARS='-v /freckle/docker.yml' .
fi

#docker run -it -p 8280:8280 --mount type=bind,source="$THIS_DIR",target="/freckle"  --mount type=bind,source="/home/markus/projects/freckles",target="/src"  "$IMAGE_NAME" /bin/bash --login
docker run -it -p 8280:8280 --mount type=bind,source="$THIS_DIR",target="/freckle" -d "$IMAGE_NAME" 
