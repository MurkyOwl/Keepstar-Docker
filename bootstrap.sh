#!/bin/bash
KEEPSTAR_DOCKER_INSTALL=/opt/keepstar_docker

set -e

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

# Have docker-compose?
if ! [ -x "$(command -v docker-compose)" ]; then

    echo "docker-compose is not installed. Installing..."

    curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose

    echo "docker-compose installed"
fi

# Make sure /opt/keepstar_docker exists
echo "Ensuring $KEEPSTAR_DOCKER_INSTALL is available..."
mkdir -p $KEEPSTAR_DOCKER_INSTALL
cd $KEEPSTAR_DOCKER_INSTALL


echo "Grabbing dockerfile and config file"

curl -L https://raw.githubusercontent.com/MurkyOwl/Keepstar-Docker/master/docker-compose.yml -o $KEEPSTAR_DOCKER_INSTALL/Dockerfile
curl -L https://raw.githubusercontent.com/MurkyOwl/Keepstar-Docker/master/config.php -o $KEEPSTAR_DOCKER_INSTALL/config.php
curl -L https://raw.githubusercontent.com/MurkyOwl/Keepstar-Docker/master/.env -o $KEEPSTAR_DOCKER_INSTALL/.env

        

echo "pulling docker image.\n"
cd $KEEPSTAR_DOCKER_INSTALL
docker-compose pull

echo "Images downloaded. edit your config files in in /opt/keepstar_docker then run 'docker-compose up -d' to run the containers, also run 'docker-compose logs --tail 5 -f' to view the logs"

