FROM php:7.3-fpm

# Get repository and install wget and vim
RUN apt-get update && apt-get install -y \
    wget \
    apt-utils \
    gnupg \
    cron \
    libxslt-dev \
    software-properties-common \
    apt-transport-https \
    libxml2-dev \
    unixodbc-dev \
    libzip-dev

# Install PHP extensions deps
RUN apt-get update \
&& apt-get install --no-install-recommends -y \
libfreetype6-dev \
libjpeg62-turbo-dev \
libmcrypt-dev \
libjpeg-dev \
libpng-dev \
zlib1g-dev \
libicu-dev \
g++ \
unixodbc-dev \
&& apt-get install --no-install-recommends -y libxml2-dev \
libaio-dev \
libmemcached-dev \
freetds-dev \
libssl-dev \
openssl \
supervisor

# PRA VER SE TEM ALGUM BUG NO PHP
# RUN php -i | grep "Configure Command"

RUN docker-php-ext-install \
iconv \
sockets \
pdo \
pdo_mysql \
gettext \
mbstring \
mysqli \
xsl \
exif \
gd \
xml \
zip \
bcmath \
xmlrpc

COPY crontab /etc/cron.d/crontab
RUN chmod 0644 /etc/cron.d/crontab
RUN crontab /etc/cron.d/crontab
RUN touch /var/log/cron.log
CMD cron && tail -f /var/log/cron.log

# Clean repository
RUN apt-get autoremove -y && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*
#RUN sed -e 's/max_execution_time = 30/max_execution_time = 900/' -i /etc/php/7.3/fpm/php.ini
