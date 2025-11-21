FROM alpine:3.20

ENV OBS_BRANCH=trunk
ENV OBS_PATH=/opt/observium

RUN apk add --no-cache \
    subversion \
    nginx \
    php83 \
    php83-fpm \
    php83-cli \
    php83-mysqli \
    php83-mbstring \
    php83-xml \
    php83-gd \
    php83-session \
    php83-pecl \
    php83-dev \
    php83-openssl \
    php83-snmp \
    php83-posix \
    php83-json \
    php83-zip \
    php83-ctype \
    php83-simplexml \
    php83-fileinfo \
    php83-tokenizer \
    php83-iconv \
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

# SVN checkout
RUN mkdir -p /opt \
    && svn checkout http://svn.observium.org/svn/observium/${OBS_BRANCH}/ ${OBS_PATH}

# RADIUS module
RUN pecl83 install radius \
    && echo "extension=radius.so" > /etc/php83/conf.d/00_radius.ini

# Permissions
RUN mkdir -p ${OBS_PATH}/logs ${OBS_PATH}/rrd \
    && chown -R nginx:nginx ${OBS_PATH}

# NGINX runtime
RUN mkdir -p /run/nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm-www.conf /etc/php83/php-fpm.d/www.conf
COPY crontab.txt /etc/crontabs/root

EXPOSE 80

CMD php-fpm83 && nginx -g "daemon off;"
