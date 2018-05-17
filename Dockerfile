FROM php:7.0-apache


RUN docker-php-source extract \
    # do important things \
    docker-php-ext-install sqlite3 curl xml \
    && docker-php-source delete
RUN apt-get update &&\
	apt-get install -y git-core cron



RUN cd /var/www/ && git clone https://github.com/shibdib/Keepstar.git
    #Get Composer
RUN cd /var/www/Keepstar/ composer install &&\
    #Change dir ownerships??
    chown -R www-data:www-data /var/www/Keepstar/
    #Set up cron job for checking perms, 
# RUN    crontab -u www-data -e && echo "0 */2 * * * php /var/www/Keepstar/cron.php" > crontab.tmp
RUN touch crontab.tmp \
	&& echo '0 */2 * * * php /var/www/Keepstar/cron.php' > crontab.tmp \
	&& crontab crontab.tmp \
    && rm -rf crontab.tmp

#set config file outside to config file inside,

COPY config.php /var/www/keepstar/config/config.php

EXPOSE 80

WORKDIR /var/www/Keepstar

#Change some Apache stuff
RUN cd /etc/apache2/sites-enabled/ && rm 000-default.conf && \
	cd /var/www/ rmdir html 
COPY keepstar.conf /etc/apache2/sites-enabled/keepstar.conf





RUN a2enmod rewrite && service apache2 restart


