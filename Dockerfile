FROM php:8.2-apache

# Install packages
RUN apt-get update

RUN apt-get install -y nodejs npm
RUN apt-get install -y wget
RUN apt-get install -y unzip
RUN apt-get install -y inkscape

# Install npm packages
RUN npm install -g bower
RUN npm install -g grunt-cli

COPY build.sh package.json package-lock.json /var/www/html/

RUN npm install
RUN ./build.sh fetch jmol

COPY src/svg /var/www/html/src/svg
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN ./build.sh render

COPY . /var/www/html

RUN bower install
RUN grunt

RUN if command -v a2enmod >/dev/null 2>&1; then \
        a2enmod rewrite headers \
    ;fi

USER www-data