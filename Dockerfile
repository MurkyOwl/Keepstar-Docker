FROM fauria/lamp:latest

RUN apt-get install -y \
	php7.0-xml \
	cron 

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


WORKDIR /var/www/Keepstar

#Change some Apache stuff
ENV APACHE_DOCUMENT_ROOT /var/www/Keepstar/

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf


