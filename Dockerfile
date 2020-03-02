# from here multi stage global arg
# https://github.com/moby/moby/issues/37345

ARG PKGNAME=squid
ARG PKGVERSION=4.10
ARG ARCH_TARGET=NOSET
ARG PKGRELEASE=1

ARG builddeps=" \
    build-essential \
    checkinstall \
    curl \
    devscripts \
    libcrypto++-dev \
    libssl-dev \
    openssl \
    "
ARG requires_checkinstall=" \
    libatomic1, \
    libc6, \
    libcap2, \
    libcomerr2, \
    libdb5.3, \
    libdbi-perl, \
    libecap3, \
    libexpat1, \
    libgcc1, \
    libgnutls30, \
    libgssapi-krb5-2, \
    libkrb5-3, \
    libldap-2.4-2, \
    libltdl7, \
    libnetfilter-conntrack3, \
    libnettle6, \
    libpam0g, \
    libsasl2-2, \
    libstdc++6, \
    libxml2, \
    netbase, \
    openssl \
    "
ARG requires=" \
    libatomic1 \
    libc6 \
    libcap2 \
    libcomerr2 \
    libdb5.3 \
    libdbi-perl \
    libecap3 \
    libexpat1 \
    libgcc1 \
    libgnutls30 \
    libgssapi-krb5-2 \
    libkrb5-3 \
    libldap-2.4-2 \
    libltdl7 \
    libnetfilter-conntrack3 \
    libnettle6 \
    libpam0g \
    libsasl2-2 \
    libstdc++6 \
    libxml2 \
    netbase \
    openssl \
    "
FROM debian:stretch as builder

ARG PKGNAME
ARG PKGVERSION
ARG ARCH_TARGET
ARG PKGRELEASE
ARG builddeps
ARG requires
ARG requires_checkinstall

RUN echo $PKGNAME
RUN echo $PKGVERSION
RUN echo $ARCH_TARGET
RUN echo $PKGRELEASE
RUN echo $builddeps
RUN echo $requires
RUN echo requires_checkinstall

ARG DEBIAN_FRONTEND=noninteractive

ENV SOURCEURL=http://www.squid-cache.org/Versions/v4/squid-4.10.tar.gz

RUN echo "deb-src http://deb.debian.org/debian stretch main" > /etc/apt/sources.list.d/source.list \
 && echo "deb-src http://deb.debian.org/debian stretch-updates main" >> /etc/apt/sources.list.d/source.list \
 && echo "deb-src http://security.debian.org stretch/updates main" >> /etc/apt/sources.list.d/source.list \
 && apt-get -qy update \
 && apt-get -qy install ${builddeps} \
 && apt-get -qy build-dep squid \
 && mkdir /build \
 && curl -o /build/squid-source.tar.gz ${SOURCEURL} \
 && cd /build \
 && tar --strip=1 -xf squid-source.tar.gz \
 && ./configure --prefix=/usr \
        --localstatedir=/var \
       --libexecdir=/usr/lib/squid \
        --datadir=/usr/share/squid \
        --sysconfdir=/etc/squid \
        --with-default-user=proxy \
        --with-logdir=/var/log/squid \
        --with-pidfile=/var/run/squid.pid \
        --mandir=/usr/share/man \
        --enable-inline \
        --disable-arch-native \
        --enable-async-io=8 \
        --enable-storeio="ufs,aufs,diskd,rock" \
        --enable-removal-policies="lru,heap" \
        --enable-delay-pools \
        --enable-cache-digests \
        --enable-icap-client \
        --enable-follow-x-forwarded-for \
        --enable-auth-basic="DB,fake,getpwnam,LDAP,NCSA,NIS,PAM,POP3,RADIUS,SASL,SMB" \
        --enable-auth-digest="file,LDAP" \
        --enable-auth-negotiate="kerberos,wrapper" \
        --enable-auth-ntlm="fake,SMB_LM" \
        --enable-external-acl-helpers="file_userip,kerberos_ldap_group,LDAP_group,session,SQL_session,time_quota,unix_group,wbinfo_group" \
        --enable-url-rewrite-helpers="fake" \
        --enable-eui \
        --enable-esi \
        --enable-icmp \
        --enable-zph-qos \
        --enable-ecap \
        --disable-translation \
        --with-swapdir=/var/spool/squid \
        --with-filedescriptors=65536 \
        --with-large-files \
        --enable-linux-netfilter \
        --enable-ssl --enable-ssl-crtd --with-openssl \
    && make -j$(( $(awk '/^processor/{n+=1}END{print n}' /proc/cpuinfo) * 4 / 3  )) \
    && checkinstall --default -D --install=no --fstrans=no --requires="${requires_checkinstallhtop}" --pkgname="${PKGNAME}" --pkgversion="${PKGVERSION}" --pkgarch $(dpkg --print-architecture) --pkgrelease="${PKGRELEASE}"

FROM debian:stretch-slim

ARG PKGNAME
ARG PKGVERSION
ARG ARCH_TARGET
ARG PKGRELEASE
ARG builddeps
ARG requires

RUN echo $PKGNAME
RUN echo $PKGVERSION
RUN echo $ARCH_TARGET
RUN echo $PKGRELEASE
RUN echo $builddeps
RUN echo $requires

LABEL maintainer="Jacob Alberty <jacob.alberty@foundigital.com>"

ARG DEBIAN_FRONTEND=noninteractive

#COPY --from=builder /build/squid_0-1_amd64.deb /tmp/squid.deb

COPY --from=builder "/build/${PKGNAME}_${PKGVERSION}-${PKGRELEASE}_$(dpkg --print-architecture).deb" "/tmp/squid.deb"

RUN echo "deb-src http://deb.debian.org/debian stretch main" > /etc/apt/sources.list.d/source.list \
 && echo "deb-src http://deb.debian.org/debian stretch-updates main" >> /etc/apt/sources.list.d/source.list \
 && echo "deb-src http://security.debian.org stretch/updates main" >> /etc/apt/sources.list.d/source.list \
 && apt-get -qy update \
 && apt-get -qy install ${builddeps} \ 
 && apt-get -qy install ${requires} 

RUN apt update \
 && apt -qy install libssl1.1 /tmp/squid.deb \
 && rm -rf /var/lib/apt/lists/*

COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["squid", "-NYC", "-f", "/conf/squid.conf"]
