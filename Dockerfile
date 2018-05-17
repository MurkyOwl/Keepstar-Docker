FROM php:7.0-apache

RUN apk add --no-cache \
    # Install OS level dependencies
    git zip unzip curl \

	# Install PHP dependencies
    docker-php-ext-install pdo_sqlite curl xml && \

    #cd to web dir and clone keepstar to it
    cd /var/www/ && git clone https://github.com/shibdib/Keepstar.git && \

    #Get Composer
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \

    #Composer install for dependencies
    composer install &&\

    #Change dir ownerships??
    sudo chown -R www-data:www-data /var/www/Keepstar/ &&\

    #Set up cron job for checking perms, 
    crontab -u www-data -e && echo "0 */2 * * * php /var/www/Keepstar/cron.php" &&\

#set config file outside to config file inside,

COPY config.php /var/www/keepstar/config/config.php


WORKDIR /var/www/Keepstar

#Change some Apache stuff
ENV APACHE_DOCUMENT_ROOT /var/www/Keepstar/

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf


