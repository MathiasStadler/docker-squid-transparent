# global

ARG ARCH

FROM debian:buster as build_env

ARG ARCH

# from here
#  https://stackoverflow.com/questions/57734271/how-to-verify-build-args-is-set-properly-in-dockerfile
RUN if [  -z $ARCH ];then \
>&2 echo  "\n****************Warning!!!!*************\n"; \
>&2 echo "--build-arg ARCH= seems empty!" ;\
false; \
fi

ARG DEBIAN_FRONTEND=noninteractive

RUN  apt-get -qy update && \
apt-get install -y -qq --no-install-recommends \
    ed \
    devscripts \
    build-essential \
    fakeroot \
    cdbs \
    debhelper \
    dh-apparmor \
    dh-autoreconf \
    wget \ 
    curl \
    debian-keyring \
&& apt-get install -y -qq --no-install-recommends \
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
    libecap3-dev \
    libltdl7 \
    logrotate \
    lsb-base 

FROM build_env AS squid_install

ARG ARCH
# from here
#  https://stackoverflow.com/questions/57734271/how-to-verify-build-args-is-set-properly-in-dockerfile
RUN if [  -z $ARCH ];then \
>&2 echo  "\n****************Warning!!!!*************\n"; \
>&2 echo "ARCH seems empty!" ;\
false; \
fi

ARG DEBIAN_FRONTEND=noninteractive

# @TODO old install ccache
# RUN  apt-get -qy update && apt-get -y -qq install ccache

# copy the patches to the working folder
COPY rules.patch build/squid/rules.patch

# set squid version
# @TODO old RUN source squid.ver
ENV SQUID_VER="4.10"
ENV SQUID_PKG="${SQUID_VER}-1"

# @TDDO old
# ENV MAKEFLAGS='CC=ccache\ gcc'

# decend into working directory
RUN cd build/squid

# get squid from debian experimental
# RUN wget http://http.debian.net/debian/pool/main/s/squid/squid_${SQUID_PKG}.dsc && \
# wget http://http.debian.net/debian/pool/main/s/squid/squid_${SQUID_VER}.orig.tar.xz && \
# wget http://http.debian.net/debian/pool/main/s/squid/squid_${SQUID_VER}.orig.tar.xz.asc && \
# wget http://http.debian.net/debian/pool/main/s/squid/squid_${SQUID_PKG}.debian.tar.xz

COPY squid_${SQUID_PKG}.dsc build/squid
COPY squid_${SQUID_VER}.orig.tar.xz  build/squid
COPY squid_${SQUID_VER}.orig.tar.xz.asc  build/squid
COPY squid_${SQUID_PKG}.debian.tar.xz  build/squid

RUN ls -l build/squid
RUN cd build/squid
RUN pwd

# unpack the source package
RUN dpkg-source -x build/squid/squid_${SQUID_PKG}.dsc

# modify configure options in debian/rules, add --enable-ssl --enable-ssl-crtd
RUN patch squid-${SQUID_VER}/debian/rules < build/squid/rules.patch

# build the package
# @TODO to test RUN cd squid-${SQUID_VER} && dpkg-buildpackage -rfakeroot -b -us -uc
RUN cd squid-${SQUID_VER} 
RUN dpkg-buildpackage -rfakeroot -b -us -uc -j$(awk '/^processor/{n+=1}END{print n}' /proc/cpuinfo)

FROM debian:buster-slim AS squid-runcontainer

ARG ARCH
# from here
#  https://stackoverflow.com/questions/57734271/how-to-verify-build-args-is-set-properly-in-dockerfile
RUN if [  -z $ARCH ];then \
>&2 echo  "\n****************Warning!!!!*************\n"; \
>&2 echo "ARCH seems empty!" ;\
false; \
fi

ENV SQUID_VER="4.10"
ENV SQUID_PKG="${SQUID_VER}-1"

COPY --from=squid_install /squid-common_${SQUID_PKG}_all.deb /tmp
COPY --from=squid_install /squid_${SQUID_PKG}_${ARCH}.deb /tmp
COPY --from=squid_install /squidclient_${SQUID_PKG}_${ARCH}.deb  /tmp

# install squid packages
RUN apt-get -y -qq update \
&& apt-get -y -qq --no-install-recommends install \
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
    libecap3-dev \
    libltdl7 \
    logrotate \
    lsb-base \
&& apt-get install squid-langpack
RUN dpkg --install /tmp/squid-common_${SQUID_PKG}_all.deb 
RUN dpkg --install /tmp/squid_${SQUID_PKG}_${ARCH}.deb 
RUN dpkg --install /tmp/squidclient_${SQUID_PKG}_${ARCH}.deb 

