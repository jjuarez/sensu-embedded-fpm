#!/bin/bash

set -e
DEFAULT_IMAGE="sensu-fpm"
DEFAULT_TAG="latest"

[[ -n "${1}" ]] || _die "Please take a look to the README file" 1

[[ -d "${PWD}/out" ]] || mkdir -p ${PWD}/out

docker build -t ${DEFAULT_IMAGE}:${DEFAULT_TAG} .
docker run -i -t -v ${PWD}/out:/out ${DEFAULT_IMAGE}:${DEFAULT_TAG} "${@}"

