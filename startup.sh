#!/bin/sh

set -e	

if [ ! -f /root/.keepstar-installed ]; then

	# Install OS level dependencies
    git zip unzip curl 

    #Get Composer
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer 

    #Composer install for dependencies
    composer install 

    #Change dir ownerships??
    sudo chown -R www-data:www-data /var/www/Keepstar

    #Set up cron job for checking perms, 
    crontab -u www-data -e && echo "0 */2 * * * php /var/www/Keepstar/cron.php"

