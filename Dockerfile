FROM php:7.0-apache

RUN apk add --no-cache \
    # Install OS level dependencies
    git zip unzip curl \
	# Install PHP dependencies
    docker-php-ext-install 

COPY src/ /var/www/keepstar/


ENTRYPOINT ["/bin/sh", "/root/startup.sh"]
