FROM alpine:3.20

ENV OBS_BRANCH=trunk
ENV OBS_PATH=/opt/observium

# Пакеты
RUN apk add --no-cache \
    subversion \
    nginx \
    php81 \
    php81-fpm \
    php81-cli \
    php81-mysqli \
    php81-mbstring \
    php81-xml \
    php81-gd \
    php81-session \
    php81-pear \
    php81-dev \
    php81-openssl \
    php81-snmp \
    php81-posix \
    php81-json \
    php81-zip \
    php81-ctype \
    php81-simplexml \
    php81-fileinfo \
    php81-tokenizer \
    php81-iconv \
    autoconf \
    make \
    gcc \
    musl-dev \
    openssl-dev \
    linux-headers \
    rrdtool \
    fping \
    net-snmp-tools \
    curl \
    bash

# Скачиваем Observium из SVN
RUN mkdir -p /opt \
    && svn checkout \
      http://svn.observium.org/svn/observium/${OBS_BRANCH}/ \
      ${OBS_PATH}

# Установка Radius модуля для PHP
RUN pecl install radius \
    && echo "extension=radius.so" > /etc/php81/conf.d/00_radius.ini

# Права
RUN mkdir -p ${OBS_PATH}/logs \
    && mkdir -p ${OBS_PATH}/rrd \
    && chown -R nginx:nginx ${OBS_PATH}

# Конфиг NGINX
RUN mkdir -p /run/nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm-www.conf /etc/php81/php-fpm.d/www.conf

# Cron для discovery/poller
COPY crontab.txt /etc/crontabs/root

EXPOSE 80

CMD php-fpm81 && nginx -g "daemon off;"
