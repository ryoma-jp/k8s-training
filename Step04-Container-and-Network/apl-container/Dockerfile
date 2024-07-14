FROM php:8.3.8-apache

RUN apt update && apt install -y \
    libmcrypt-dev default-mysql-client \
    zip unzip git vim
#RUN docker-php-ext-install pdo_mysql session json mbstring
RUN docker-php-ext-install pdo_mysql session
COPY php/ /var/www/html/
