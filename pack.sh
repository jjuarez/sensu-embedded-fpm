#!/bin/bash

set -e
declare readonly FPM_VERSION="1.6.0"
declare readonly EMBEDDED_PATH="/opt/sensu/embedded"
declare readonly EMBEDDED_GEM="${EMBEDDED_PATH}/bin/gem"
declare readonly FPM_PATH=$(/usr/bin/gem environment gemdir)/gems/fpm-${FPM_VERSION}
declare readonly FPM=${FPM_PATH}/bin/fpm
declare readonly PREFIX="sensu-gem"
declare readonly OPTIONS="--gem-gem ${EMBEDDED_GEM} --gem-package-name-prefix=${PREFIX}"
declare readonly EXCLUDED_DEPENDENCIES=$(${EMBEDDED_GEM} list --local --no-versions)

TARGETS=""


while [[ -n "${1}" ]] && [[ "${1}" != "--" ]]; do

	TARGETS="${TARGETS} ${1}"
	shift
done

echo "Building Sensu gems for: ${TARGETS}"

if [ "${1}" = "--" ]; then
	shift
	DEPENDENCIES="${@}"
fi


for dependency in ${EXCLUDED_DEPENDENCIES}; do
	OPTIONS="${OPTIONS} --gem-disable-dependency ${dependency}"
done

[[ -n "${DEPENDENCIES}" ]] && apt-get install -qqy --force-yes ${DEPENDENCIES}

env ARCHFLAGS="-arch x86_64" ${EMBEDDED_GEM} install --no-ri --no-rdoc --install-dir /tmp/gems ${TARGETS} &&
find /tmp/gems -type f -name "*.gem" -exec ${FPM} -p /out -d sensu -s gem -t deb ${OPTIONS} {} \;

