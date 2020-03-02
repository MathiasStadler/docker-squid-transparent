FROM debian:buster-slim

# from here last entry
# https://stackoverflow.com/questions/39650056/using-ccache-when-building-inside-of-docker
# build
# docker create -v /mnt/ccache:/ccache --name ccache debian
# used
# docker run -e CCACHE_DIR=/ccache --volumes-from ccache -it debian


ARG DEBIAN_FRONTEND=noninteractive

RUN  apt-get -qy update && \
apt-get -y install ccache

