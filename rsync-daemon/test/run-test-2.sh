#!/bin/bash

set -e

source ../rsync-daemon.env

RSYNC_REMOTE="rsync://${RSYNC_DAEMON_CONTAINER}:23985/gdal-docker-cache/${BASE_IMAGE_NAME}"

BUILD_ARGS=(
    "--build-arg" "PROJ_DATUMGRID_LATEST_LAST_MODIFIED=${PROJ_DATUMGRID_LATEST_LAST_MODIFIED}"
    "--build-arg" "PROJ_VERSION=${PROJ_VERSION}"
    "--build-arg" "GDAL_VERSION=${GDAL_VERSION}"
    "--build-arg" "GDAL_RELEASE_DATE=${GDAL_RELEASE_DATE}"
    "--build-arg" "RSYNC_REMOTE=${RSYNC_REMOTE}"
)

# echo  "${BUILD_ARGS[@]}"

docker build  --network "${BUILD_NETWORK}" --no-cache \
        -t "test-rsync-daemon" - <<EOF
FROM debian:buster-slim AS PRE_WITH_BUILD_CCACHE
RUN apt-get update && apt-get install -qy --no-install-recommends rsync ccache
ARG RSYNC_REMOTE 
ARG GDAL_VERSION=master
RUN if test "${RSYNC_REMOTE}" != ""; then \
        echo "Downloading cache..."; \
        rsync -ra ${RSYNC_REMOTE}/ccache/ $HOME/; \
        export CC="ccache gcc"; \
        export CXX="ccache g++"; \
        ccache -M 1G; \
        pwd $HOME; \
        ls -l $HOME; \
    fi
    # omitted: download source tree depending on GDAL_VERSION
    # omitted: build

FROM PRE_WITH_BUILD_CCACHE AS POST_WITH_BUILD_CCACHE
RUN mkdir -p $HOME/.ccache
RUN touch $HOME/.ccache/testfile1    
RUN if test "${RSYNC_REMOTE}" != ""; then \
        ccache -s; \
        echo "Uploading cache..."; \
        rsync -ra --delete $HOME/.ccache ${RSYNC_REMOTE}/ccache/; \
        rm -rf $HOME/.ccache; \
    fi
EOF