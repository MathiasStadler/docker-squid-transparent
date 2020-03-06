-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: squid
Binary: squid, squid-common, squidclient, squid-cgi, squid-purge
Architecture: any all
Version: 4.10-1
Maintainer: Luigi Gangitano <luigi@debian.org>
Uploaders: Santiago Garcia Mantinan <manty@debian.org>
Homepage: http://www.squid-cache.org
Standards-Version: 4.5.0
Vcs-Browser: https://salsa.debian.org/squid-team/squid
Vcs-Git: https://salsa.debian.org/squid-team/squid.git
Testsuite: autopkgtest
Testsuite-Triggers: @builddeps@, apache2, apparmor-utils, elinks, fakeroot, netcat, python3-minimal, ssl-cert, vsftpd
Build-Depends: ed, libltdl-dev, pkg-config, g++ (>= 4.9) <!cross> | clang (>= 3.7) <!cross>, gcc (>= 4.9) <!cross> | clang (>= 3.7) <!cross>, cdbs, debhelper (>= 10), dpkg-dev (>= 1.17.11~), lsb-release, dh-apparmor, libcppunit-dev, libcap2-dev [linux-any], libdb-dev, libecap3-dev (>= 1.0.1-2), libexpat1-dev, libgnutls28-dev (>= 3.5), libkrb5-dev, comerr-dev, libldap2-dev, libnetfilter-conntrack-dev [linux-any], libpam0g-dev, libsasl2-dev, libxml2-dev, nettle-dev
Package-List:
 squid deb web optional arch=any
 squid-cgi deb web optional arch=any
 squid-common deb web optional arch=all
 squid-purge deb web optional arch=any
 squidclient deb web optional arch=any
Checksums-Sha1:
 b8b267771550bb8c7f2b2968b305118090e7217a 2445848 squid_4.10.orig.tar.xz
 fdff4b67d709f66ecaa54c5ae7357d10ee844b04 1194 squid_4.10.orig.tar.xz.asc
 295bf9f815c478377799e3060729b2264163c63b 39620 squid_4.10-1.debian.tar.xz
Checksums-Sha256:
 98f0100afd8a42ea5f6b81eb98b0e4b36d7a54beab1c73d2f1705ab49b025f1f 2445848 squid_4.10.orig.tar.xz
 f2dea9f2b34f35eb600cea3af5d6e0a494cea02177236b54c8614eac57d9f0ec 1194 squid_4.10.orig.tar.xz.asc
 d51fe3b0dbd4c450d935664802835456698a206a3af7f7dd8daaaa273c4e5f2c 39620 squid_4.10-1.debian.tar.xz
Files:
 af7ac6e70f9bd03ae4fcec0c9b99c38a 2445848 squid_4.10.orig.tar.xz
 e95056cfce4a7aad8c6c2464773c391e 1194 squid_4.10.orig.tar.xz.asc
 987b7d63180c1b9348bdbb322cc3a88b 39620 squid_4.10-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEjUhaNf8ebreQ5Q9tAoTyDCupfO0FAl5BWioACgkQAoTyDCup
fO2DXg//bj4EGUSSZ1tjmn1y9dU6KP+Bl/+mK8/1OLO1G9iigDc45VQlSi7MtZhu
mG5c70OhOvK4k5RPso0HDxIQKuaWlWE4tYJaR1q4KK0rsfy9TkOKRzYQWVhcn0qT
4Z1PruPBabp1UrF/6uaOnB0rxBS43ycsCIPzyO1yuCG0a3p8vevHeuLTgSG/RIUf
ULRIGReK2YdNXbnVKWj4Cx3ZhSy5asA1NQW1xUZ8gN2m4G1SnksaTJvqwPGk4692
dtkoom1Wh/DLPhet/bLKG0hzpVef89tvSOqaX5aegv/nnDQ73zqkcJlbGJ16tg7Q
o3CsYF2pd0eMqJh+UCadfK/ZltQRSZ+B+ypKjm2Qs4lhMtQDAQ5ny788ujQFLWZx
2X8ww5ucIiSn3onIfmCWG97nzJA4Ig42xXkuQY7ePoqE5cJih0QkBm39pJ0HV8ko
FNs/68QEf2KQ9FyMSkooOMk3ejS+yh4rlQiUoiOTBN3M0I6zNJTsQfMjt1lIDEPl
4+ZUrXTutxnJcg8+o4R3rj4WmGcbq9rxLIUoxCksvP3ytdMOwCHGTOjMxmpXszgQ
Q/cXcH+QwCR8NIMINCRiuevmdOv+SXpH2qTaA7p1NujzhlRD8BMvyGDybgNvP9jm
QSlFyo8OduzE8IOgVZ3bJbxXKehwovUpHQ7+EATYqcu540Z7Gx0=
=OLb/
-----END PGP SIGNATURE-----
