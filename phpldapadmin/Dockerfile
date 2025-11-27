FROM dunglas/frankenphp:php8.4-alpine

ARG BUILD_VERSION
ARG BUILD_REVISION

LABEL org.opencontainers.image.vendor="Deon George" \
      org.opencontainers.image.licenses="GPLv2" \
      org.opencontainers.image.source="https://github.com/leenooks/phpldapadmin" \
      org.opencontainers.image.title="phpLDAPadmin" \
      org.opencontainers.image.description="An LDAP Administration Tool" \
      org.opencontainers.image.url="https://phpldapadmin.org" \
      org.opencontainers.image.version="${BUILD_VERSION}" \
      org.opencontainers.image.revision="${BUILD_REVISION}"

# ---------------------------------------------------------------------
# Base packages
# ---------------------------------------------------------------------
RUN apk add --no-cache \
        bash \
        curl \
        openssl \
        openldap-clients \
        tzdata

# ---------------------------------------------------------------------
# PHP extensions
# ---------------------------------------------------------------------
RUN install-php-extensions \
        ldap \
        igbinary \
        msgpack \
        memcached \
        opcache

# ---------------------------------------------------------------------
# PHP tuning via ini files
# ---------------------------------------------------------------------
# Создаём отдельный конфиг OPcache и performance-настройки
RUN { \
      echo "opcache.enable=1"; \
      echo "opcache.enable_cli=1"; \
      echo "opcache.memory_consumption=256"; \
      echo "opcache.interned_strings_buffer=16"; \
      echo "opcache.max_accelerated_files=20000"; \
      echo "opcache.validate_timestamps=0"; \
      echo "opcache.save_comments=1"; \
      echo "opcache.jit=1255"; \
      echo "opcache.jit_buffer_size=128M"; \
    } > /usr/local/etc/php/conf.d/opcache.ini

RUN { \
      echo "memory_limit=512M"; \
      echo "realpath_cache_size=4096K"; \
      echo "realpath_cache_ttl=600"; \
      echo "expose_php=0"; \
      echo "upload_max_filesize=64M"; \
      echo "post_max_size=64M"; \
      echo "date.timezone=UTC"; \
    } > /usr/local/etc/php/conf.d/custom.ini

# ---------------------------------------------------------------------
# LDAPS support
# ---------------------------------------------------------------------
RUN echo "TLS_REQCERT never" >> /etc/openldap/ldap.conf

# ---------------------------------------------------------------------
# Composer
# ---------------------------------------------------------------------
RUN curl -fsSL https://getcomposer.org/installer \
      | php -- --install-dir=/usr/local/bin --filename=composer

ENV COMPOSER_HOME=/var/cache/composer
ENV COMPOSER_ALLOW_SUPERUSER=1

# ---------------------------------------------------------------------
# ENV-driven configuration for phpLDAPadmin
# ---------------------------------------------------------------------
ENV PLA_LDAP_HOST="ldap" \
    PLA_LDAP_PORT="389" \
    PLA_LDAP_TLS="false" \
    PLA_LOGIN_DN="cn=admin,dc=example,dc=org" \
    PLA_LOGIN_PASS="admin" \
    PLA_BASE_DN="dc=example,dc=org"

# ---------------------------------------------------------------------
# User and permissions
# ---------------------------------------------------------------------
ENV SITE_USER=www-data

COPY ./init-docker /sbin/init-docker
COPY ./configure-env.php /sbin/configure-env.php

RUN chmod 550 /sbin/init-docker /sbin/configure-env.php && \
    chown ${SITE_USER}:0 /sbin/init-docker /sbin/configure-env.php && \
    mkdir -p ${XDG_DATA_HOME} ${XDG_CONFIG_HOME} && \
    chown -R ${SITE_USER}:0 ${XDG_DATA_HOME} ${XDG_CONFIG_HOME}

# ---------------------------------------------------------------------
# Application
# ---------------------------------------------------------------------
COPY . /app
WORKDIR /app

# Replace config at runtime dynamically
# (создаётся файл config.php на основе ENV)
RUN mkdir -p /app/config \
    && rm -f /app/config/config.php

USER ${SITE_USER}

# ---------------------------------------------------------------------
# FrankenPHP
# ---------------------------------------------------------------------
ENV SERVER_NAME=:8080
EXPOSE 8080

ENTRYPOINT ["/sbin/init-docker"]
CMD ["--config","/etc/caddy/Caddyfile","--adapter","caddyfile"]
