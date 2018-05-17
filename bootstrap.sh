#!/bin/bash

set -e

KEEPSTAR_DOCKER_INSTALL=/opt/keepstar_docker

#check to see if running as root

if (( $EUID != 0 )); then

    echo "Please run as root"
    exit
fi

#check for curl install


if ! [ -x "$(command -v curl)" ]; then

    echo "curl is not installed."
    exit 1
fi

# Have docker?
if ! [ -x "$(command -v docker)" ]; then

    echo "Docker is not installed. Installing..."

    sh <(curl -fsSL get.docker.com)

    echo "Docker installed"
fi

# Make sure /opt/keepstar_docker exists
echo "Ensuring $KEEPSTAR_DOCKER_INSTALL is available..."
mkdir -p $KEEPSTAR_DOCKER_INSTALL
cd $KEEPSTAR_DOCKER_INSTALL

echo "Grabbing dockerfile and config file"

curl -L https://raw.githubusercontent.com/MurkyOwl/Keepstar-Docker/master/Dockerfile -o $KEEPSTAR_DOCKER_INSTALL/Dockerfile
curl -L https://raw.githubusercontent.com/MurkyOwl/Keepstar-Docker/master/config.php -o $KEEPSTAR_DOCKER_INSTALL/config.php

echo "Please edit your config file in /opt/keepstar_docker/ before continuing, Yes when ready."
select yn in "Yes" "No"; do
    case $yn in
        Yes ) make install; break;;
        No ) exit;;
    esac
done

echo "Starting docker image.\n"
docker build -t keepstar && docker run -p 4000:80 keepstar

echo "Docker has Started!"
