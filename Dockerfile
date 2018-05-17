FROM php:7.1-fpm

 # PHP necessities \
RUN docker-php-source extract \
    docker-php-ext-install sqlite3 curl xml \
    & docker-php-source delete

#install Git and Crontab
RUN apt-get update &&\
	apt-get install -y git-core cron


#Clone the main build in
RUN \
    cd /var/www/ && git clone https://github.com/shibdib/Keepstar.git 
    #Get Composing
RUN cd /var/www/Keepstar/ composer install
    # #Change dir ownerships
    # chown -R www-data:www-data /var/www/Keepstar/

    #Set up cron job for checking perms, 
RUN touch crontab.tmp \
	&& echo '0 */2 * * * php /var/www/Keepstar/cron.php' > crontab.tmp \
	&& crontab crontab.tmp \
    && rm -rf crontab.tmp

#set config file outside to config file inside,

# COPY config.php /var/www/keepstar/config/config.php

VOLUME ["/var/www/Keepstar"]

# EXPOSE 80

WORKDIR /var/www/Keepstar

# #Change some Apache stuff
# RUN cd /etc/apache2/sites-enabled/ && rm 000-default.conf && \
# 	cd /var/www/ rmdir html 
# COPY keepstar.conf /etc/apache2/sites-enabled/keepstar.conf


# #fix weird rewrite .htaccess bug and restart apache
# RUN a2enmod rewrite && service apache2 restart


