#!/bin/bash

set -e

RSYNC_REMOTE="rsync://${RSYNC_DAEMON_CONTAINER}:23985/gdal-docker-cache/${BASE_IMAGE_NAME}"

BUILD_ARGS=(
    "--build-arg" "PROJ_DATUMGRID_LATEST_LAST_MODIFIED=${PROJ_DATUMGRID_LATEST_LAST_MODIFIED}"
    "--build-arg" "PROJ_VERSION=${PROJ_VERSION}"
    "--build-arg" "GDAL_VERSION=${GDAL_VERSION}"
    "--build-arg" "GDAL_RELEASE_DATE=${GDAL_RELEASE_DATE}"
    "--build-arg" "RSYNC_REMOTE=${RSYNC_REMOTE}"
)

echo  "${BUILD_ARGS[@]}"

docker build  --network "${BUILD_NETWORK}" --target builder \
        -t "test-rsync-daemon"  <<EOF
FROM alpine
RUN apk add --nocache rsync ccache

ARG RSYNC_REMOTE
ARG GDAL_VERSION=master
RUN if test "${RSYNC_REMOTE}" != ""; then \
        echo "Downloading cache..."; \
        rsync -ra ${RSYNC_REMOTE}/gdal/ $HOME/; \
        export CC="ccache gcc"; \
        export CXX="ccache g++"; \
        ccache -M 1G; \
    fi \
    # omitted: download source tree depending on GDAL_VERSION
    # omitted: build
    && if test "${RSYNC_REMOTE}" != ""; then \
        ccache -s; \
        echo "Uploading cache..."; \
        rsync -ra --delete $HOME/.ccache ${RSYNC_REMOTE}/gdal/; \
        rm -rf $HOME/.ccache; \
    fi
    EOF