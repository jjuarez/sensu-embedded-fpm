#!/bin/bash

set -e
declare readonly DEFAULT_IMAGE="sensu-embedded-gems"
declare readonly DEFAULT_TAG="latest"

##
# Log to console
_console() {
  local message=${1:-''}

  [[ -n "${message}" ]] && echo -e "${message}"
}

##
# Exit from the script
_die() {
  local message=${1:-""}
  local exit_code=${2:-0}

  _console "${message}"
  exit ${exit_code}
}


[[ -n "${@}" ]] || _die "Please take a look to the README file" 1

[[ -d "${PWD}/out" ]] || mkdir -p "${PWD}/out"

docker build -t ${DEFAULT_IMAGE}:${DEFAULT_TAG} . &&
docker run -i -t -v ${PWD}/out:/out ${DEFAULT_IMAGE}:${DEFAULT_TAG} "${@}"

