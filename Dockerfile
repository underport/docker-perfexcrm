FROM php:7.4-apache

EXPOSE 80

RUN apt-get update -y && \
    apt-get install -y apt-utils tree htop libpng-dev libc-client-dev libkrb5-dev libzip-dev zip --no-install-recommends 

# Installing php Dependencies 
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install -j$(nproc) imap

RUN docker-php-ext-install mysqli gd zip

# Assuming Perfex-CRM root is located in 'pwd'/perfex_crm
RUN a2enmod rewrite
COPY crm /var/www/html/

# Configuring Ownerships and permissions
RUN chown -R www-data:www-data /var/www/html/ \
&& chmod 777 /var/www/html/uploads/ \
&& chmod 777 /var/www/html/application/config/ \
&& chmod 777 /var/www/html/application/config/config.php \
&& chmod 777 /var/www/html/application/config/app-config-sample.php \
&& chmod 777 /var/www/html/temp/
