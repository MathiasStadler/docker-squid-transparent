

# squid-docker-transparent

> - project based on other git project
> - all credits goes to 
> - https://linuxize.com/post/how-to-install-and-configure-squid-proxy-on-debian-10/
> - https://github.com/jacobalberty/squid-docker


## source

```txt
https://github.com/sameersbn/docker-squid#usage
http://squid-web-proxy-cache.1019090.n4.nabble.com/using-clang-to-compile-squid-4-5-td4687235.html#a4687298
```

## git credential.helper cache

```bash
git config --global credential.helper cache
trapapa@lan-rk3399:~/playground/squid-docker$ git config --global credential.helper "cache --timeout=3600"
```


## use docker in container

```bash

# copy Dockerfile
mkdir buster && cp Dockerfile buster
# and edit Docker file
FROM debian:buster-backports as builder
# FROM debian:buster as builder
```

## set image name

```bash
DOCKER_SQUID_IMAGE_NAME="docker-strech-squid"
echo "Docker image name: ${DOCKER_SQUID_IMAGE_NAME}"
DOCKER_SQUID_IMAGE_TAG="${USER}:${DOCKER_SQUID_IMAGE_NAME}"
echo "Docker squid image tag ${DOCKER_SQUID_IMAGE_TAG}"
```


## build docker image

```bash
cd buster
docker build -t "${DOCKER_SQUID_IMAGE_TAG}"  .
```

## start docker squid with expose port

```bash
DOCKER_SQUID_CONTAINER_ID=docker run --name squid -d --restart=always \
  --publish 3128:3128 \
  --volume squid4_default.conf:/conf/squid.conf \
  --volume /srv/docker/squid/cache:/var/spool/squid \
  "${DOCKER_SQUID_IMAGE_TAG}"
```

## start log

```bash
docker logs "${DOCKER_SQUID_CONTAINER_ID}"
```

## test squid

```bash
curl -x 0.0.0.0:3128 http://www.heise.de
```

## helper craete script from README.md

```bash
SCRIPT_NAME="readme2script.sh"
rm -rf ${SCRIPT_NAME}
cat << EOF |tee ${SCRIPT_NAME}
#!/bin/bash
set -o posix -o errexit
if [ -z \${1+x} ]; then printf "set script name that you would extract \n "; exit 1;fi
if [ -z \${2+x} ]; then printf "set source markdown file\n" ;exit 1; fi
if grep -q "\$1" "\$2"; then printf "" ; else printf "ERROR: script tag \$1 NOT exists in \$2\n"; exit 1; fi;
unset SCRIPT
unset SCRIPT_PATH
SCRIPT=\$1;
SCRIPT_PATH="work_folder/\${SCRIPT}"
# printf "SCRIPT => %s \n" "\${SCRIPT}"
expr="/^\\\`\\\`\\\`bash \${SCRIPT}/,/^\\\`\\\`\\\`/{ /^\\\`\\\`\\\`bash.*$/d; /^\\\`\\\`\\\`$/d; p; }"
# printf "Expression %s \n" "\${expr}"
if [ -f "\${1}" ]; then printf "File \${1} exists please delete first \n";exit 1;fi;
sed -n "\${expr}" "\${2}" >"\${1}"
chmod +x "\${1}"
EOF
chmod +x ${SCRIPT_NAME}
```


## squid way build self signed certificate

-  [from here](https://wiki.squid-cache.org/ConfigExamples/Intercept/SslBumpExplicit)


```bash
SCRIPT_NAME="mk_self_sign_certificate.sh"
./readme2script.sh ${SCRIPT_NAME} README.md && \
./${SCRIPT_NAME}
```


```bash mk_self_sign_certificate.sh
#!/bin/bash
set -o errexit -o posix -o nounset -o pipefail
KEZ_LENGTH="2048"
# create passphrase text file
echo "topSecret" >passphrase.txt
# create generate CA private
openssl genrsa -aes256 -passout file:passphrase.txt -out ca-key.pem "${KEZ_LENGTH}"
# remove key
# from https://www.jamescoyle.net/how-to/1073-bash-script-to-create-an-ssl-certificate-key-and-request-csr
openssl rsa -in ca-key.pem -passin file:passphrase.txt -out ca-key.pem
# create ca
openssl req -new -x509 -days 30 -key ca-key.pem -sha256 -out ca.pem -passout file:passphrase.txt\
  -subj "/C=DE/ST=Test/L=for/O=Test/CN=localhost"
# create server key
openssl genrsa -out server-key.pem 4096
# sign the server key
openssl req -subj "/CN=${HOST:-}" -sha256 -new -key server-key.pem -out server.csr
# prepare file
IP="$(ip route get 1 | sed 's/^.*src \([^ ]*\).*$/\1/;q')";
echo "used IP ${IP}";
echo "subjectAltName=critical,DNS:$(hostname),IP:${IP},IP:127.0.0.1" > extfile.cnf
echo "extendedKeyUsage = serverAuth" >> extfile.cnf
# create cert
openssl x509 -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem \
-CAcreateserial -out server-cert.pem -extfile extfile.cnf


```



## Squid-4 default config

- [found here](https://wiki.squid-cache.org/Squid-4)


## squid-docker
This is a squid (http://www.squid-cache.org/) docker image

## Notes about development

This container is under heavy development at the moment. I do use it in production but at this point it is tailored
to my own use. I am actively working to get it generalized enough to be useful for other people. This section contains
notes about planned changes and how things work (Or don't work).

### Configuration files
At this point configuration files just go under `/conf`. I intend to make this a little more nested to allow some of the other
features to be implemented.

### Dependencies
This image contains all of the default authentication handlers and options from the debian defaults for squid. But it does not include
all of those authentication handlers dependencies. I have plans for a special conf file just for the image that will allow you to add
dependencies that are specific to your setup without having to modify the image itself.


## Usage

Simply put your squid configuration in /conf with squid.conf located there as well.

