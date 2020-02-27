

# squid-docker-transparent

| # project based on other git project
| # all credits goes to 
| # https://linuxize.com/post/how-to-install-and-configure-squid-proxy-on-debian-10/
| # https://github.com/jacobalberty/squid-docker


## source

```txt
https://github.com/sameersbn/docker-squid#usage
http://squid-web-proxy-cache.1019090.n4.nabble.com/using-clang-to-compile-squid-4-5-td4687235.html#a4687298
```

## use docker in container

```bash

# copy Dockerfile
mkdir buster && cp Dockerfile buster
# and edit Docker file
FROM debian:buster-backports as builder
# FROM debian:buster as builder
```

## build docker image

```bash
cd buster
docker build -t my:docker-buster-squid
```

## start docker squid with expose port

```bash
docker run --name squid -d --restart=always \
  --publish 3128:3128 \
  --volume /path/to/squid.conf:/etc/squid/squid.conf \
  --volume /srv/docker/squid/cache:/var/spool/squid \
  sameersbn/squid:3.5.27-2
```



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

