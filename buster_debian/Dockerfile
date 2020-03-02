FROM debian:buster as build_env

ARG DEBIAN_FRONTEND=noninteractive

RUN  apt-get -qy update && \
apt-get -y install ed devscripts build-essential fakeroot cdbs debhelper dh-apparmor dh-autoreconf wget curl && \
apt-get -y install \
    libcppunit-dev \
    libsasl2-dev \
    libxml2-dev \
    libkrb5-dev \
    libdb-dev \
    libnetfilter-conntrack-dev \
    libexpat1-dev \
    libcap2-dev \
    libldap2-dev \
    libpam0g-dev \
    libgnutls28-dev \
    libssl-dev \
    libdbi-perl \
    libecap3 \
    libecap3-dev


FROM build_env AS squid_install


# copy the patches to the working folder
COPY rules.patch build/squid/rules.patch

# set squid version
# @TODO old RUN source squid.ver
ENV SQUID_VER="4.10"
ENV SQUID_PKG="${SQUID_VER}-1"

# decend into working directory
RUN cd build/squid

# get squid from debian experimental
RUN wget http://http.debian.net/debian/pool/main/s/squid/squid_${SQUID_PKG}.dsc && \
wget http://http.debian.net/debian/pool/main/s/squid/squid_${SQUID_VER}.orig.tar.xz && \
wget http://http.debian.net/debian/pool/main/s/squid/squid_${SQUID_VER}.orig.tar.xz.asc && \
wget http://http.debian.net/debian/pool/main/s/squid/squid_${SQUID_PKG}.debian.tar.xz

# unpack the source package
RUN dpkg-source -x squid_${SQUID_PKG}.dsc

# modify configure options in debian/rules, add --enable-ssl --enable-ssl-crtd
RUN patch squid-${SQUID_VER}/debian/rules < build/squid/rules.patch

# build the package
RUN cd squid-${SQUID_VER} && dpkg-buildpackage -rfakeroot -b -us -uc

# install squid packages
RUN apt-get install squid-langpack && \
dpkg --install squid-common_${SQUID_PKG}_all.deb && \
dpkg --install squid_${SQUID_PKG}_amd64.deb && \
dpkg --install squidclient_${SQUID_PKG}_amd64.deb 

# and revert
RUN popd