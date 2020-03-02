#!/bin/bash

set -e

source ./rsync-daemon.env

# mkdir -p "${HOST_CACHE_DIR}/${BASE_IMAGE_NAME}/proj"
# mkdir -p "${HOST_CACHE_DIR}/${BASE_IMAGE_NAME}/gdal"
# mkdir -p "${HOST_CACHE_DIR}/${BASE_IMAGE_NAME}/spatialite"
mkdir -p "${HOST_CACHE_DIR}/${BASE_IMAGE_NAME}/ccache"

# Start a Docker container that has a rsync daemon, mounting HOST_CACHE_DIR
if ! docker ps | grep "${RSYNC_DAEMON_CONTAINER}"; then
    RSYNC_DAEMON_IMAGE=osgeo/gdal:gdal_rsync_daemon
    docker rmi "${RSYNC_DAEMON_IMAGE}" 2>/dev/null || /bin/true
    docker build -t "${RSYNC_DAEMON_IMAGE}" - <<EOF
FROM alpine
VOLUME /opt/gdal-docker-cache
EXPOSE 23985
RUN apk add --no-cache rsync \
            && mkdir -p /opt/gdal-docker-cache \
            && echo "[gdal-docker-cache]" > /etc/rsyncd.conf \
            && echo "path = /opt/gdal-docker-cache" >> /etc/rsyncd.conf  \
            && echo "hosts allow = *" >> /etc/rsyncd.conf \
            && echo "read only = false" >> /etc/rsyncd.conf \
            && echo "use chroot = false" >> /etc/rsyncd.conf
CMD rsync --daemon --port 23985 && while sleep 1; do /bin/true; done
EOF

    if ! docker network ls | grep "${BUILD_NETWORK}"; then
        docker network create "${BUILD_NETWORK}"
    fi

    THE_UID=$(id -u "${USER}")
    THE_GID=$(id -g "${USER}")

    docker run -d -u "${THE_UID}:${THE_GID}" --rm \
        -v "${HOST_CACHE_DIR}":/opt/gdal-docker-cache \
        --name "${RSYNC_DAEMON_CONTAINER}" \
        --network "${BUILD_NETWORK}" \
        --network-alias "${RSYNC_DAEMON_CONTAINER}" \
        "${RSYNC_DAEMON_IMAGE}"

fi

docker ps
docker network list