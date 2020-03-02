FROM alpine

# from here
# https://github.com/OSGeo/gdal/blob/26342f736f38fd5c7ba8b63fcfe9d29648d67035/gdal/docker/util.sh#L223:L269
# build
# docker build --rm -f "ccache/rsync-daemon/Dockerfile" -t rsync-daemon:latest "ccache/rsync-daemon"
#
# used
# RSYNC_DAEMON_CONTAINER=rsync-daemon:latest
# rsync -ra README.md rsync://${RSYNC_DAEMON_CONTAINER}:23985:/test



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
