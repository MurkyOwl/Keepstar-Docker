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

curl -L https://raw.githubusercontent.com/PLACEHOLDER -o $KEEPSTAR_DOCKER_INSTALL/Dockerfile
curl -L https://raw.githubusercontent.com/PLACEHOLDER -o $KEEPSTAR_DOCKER_INSTALL/configP

echo "Starting docker stack. This will download the images too. Please wait...\n"
docker-compose up -d

echo "Images downloaded. The containers are now iniliatising. To check what is happening, run 'docker-compose logs --tail 5 -f' in /opt/keepstar_docker"

echo "Done!"
