FROM ubuntu:18.04

ARG PHP_VERSION=7.3.13
ARG PHP_SHA256=561bb866bdd509094be00f4ece7c3543ec971c4d878645ee81437e291cffc762
ARG GPG_KEY1=CBAF69F173A0FEA4B537F470D66C9593118BCCB6
ARG GPG_KEY2=F38252826ACD957EF380D39F2F7956BC5DA04B5D
ARG PHP72_CONFIGURE='--with-password-argon2 --with-sodium=shared --with-openssl --with-pear'
ARG XDEBUG_VERSION=2.9.1

ENV DEBIAN_FRONTEND=noninteractive
RUN set -eux; \
{ \
  echo 'Package: php*'; \
    echo 'Pin: release *'; \
    echo 'Pin-Priority: -1'; \
} > /etc/apt/preferences.d/no-debian-php

ENV PHPIZE_DEPS \
      tzdata \
      autoconf \
      dpkg-dev \
      file \
      g++ \
      gcc \
      libc-dev \
      make \
      pkg-config \
      re2c

RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
  libonig-dev \
  $PHPIZE_DEPS \
  ca-certificates \
  curl \
  xz-utils \
  ; \
  rm -rf /var/lib/apt/lists/*

ENV PHP_INI_DIR /usr/local/etc/php
RUN set -eux; \
  mkdir -p "$PHP_INI_DIR/conf.d"; \
  [ ! -d /var/www/html ]; \
  mkdir -p /var/www/html; \
  chown www-data:www-data /var/www/html; \
  chmod 777 /var/www/html

ENV APACHE_CONFDIR /etc/apache2
ENV APACHE_ENVVARS $APACHE_CONFDIR/envvars

RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends apache2; \
  rm -rf /var/lib/apt/lists/*; \
  \
  sed -ri 's/^export ([^=]+)=(.*)$/: ${\1:=\2}\nexport \1/' "$APACHE_ENVVARS"; \
  \
  . "$APACHE_ENVVARS"; \
  for dir in \
  "$APACHE_LOCK_DIR" \
  "$APACHE_RUN_DIR" \
  "$APACHE_LOG_DIR" \
  ; do \
  rm -rvf "$dir"; \
  mkdir -p "$dir"; \
  chown "$APACHE_RUN_USER:$APACHE_RUN_GROUP" "$dir"; \
  chmod 777 "$dir"; \
  done; \
  \
  rm -rvf /var/www/html/*; \
  \
  ln -sfT /dev/stderr "$APACHE_LOG_DIR/error.log"; \
  ln -sfT /dev/stdout "$APACHE_LOG_DIR/access.log"; \
  ln -sfT /dev/stdout "$APACHE_LOG_DIR/other_vhosts_access.log"; \
  chown -R --no-dereference "$APACHE_RUN_USER:$APACHE_RUN_GROUP" "$APACHE_LOG_DIR"

RUN a2dismod mpm_event && a2enmod mpm_prefork

RUN { \
  echo '<FilesMatch \.php$>'; \
  echo '\tSetHandler application/x-httpd-php'; \
  echo '</FilesMatch>'; \
  echo; \
  echo 'DirectoryIndex disabled'; \
  echo 'DirectoryIndex index.php index.html'; \
  echo; \
  echo '<Directory /var/www/>'; \
  echo '\tOptions -Indexes'; \
  echo '\tAllowOverride All'; \
  echo '</Directory>'; \
  } | tee "$APACHE_CONFDIR/conf-available/docker-php.conf" \
  && a2enconf docker-php

ENV PHP_EXTRA_BUILD_DEPS apache2-dev
ENV PHP_EXTRA_CONFIGURE_ARGS --with-apxs2 --disable-cgi
ENV PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"
ENV PHP_CPPFLAGS="$PHP_CFLAGS"
ENV PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"

ENV GPG_KEYS="${GPG_KEY1} ${GPG_KEY2}"

ENV PHP_URL="https://www.php.net/get/php-${PHP_VERSION}.tar.xz/from/this/mirror" PHP_ASC_URL="https://www.php.net/get/php-${PHP_VERSION}.tar.xz.asc/from/this/mirror"

RUN mkdir ~/.gnupg && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf

RUN set -eux; \
  \
  savedAptMark="$(apt-mark showmanual)"; \
  apt-get update; \
  apt-get install -y --no-install-recommends gnupg dirmngr; \
  rm -rf /var/lib/apt/lists/*; \
  \
  mkdir -p /usr/src; \
  cd /usr/src; \
  \
  curl -fsSL -o php.tar.xz "$PHP_URL"; \
  \
  if [ -n "$PHP_SHA256" ]; then \
  echo "$PHP_SHA256 *php.tar.xz" | sha256sum -c -; \
  fi; \
  \
  if [ -n "$PHP_ASC_URL" ]; then \
  curl -fsSL -o php.tar.xz.asc "$PHP_ASC_URL"; \
  export GNUPGHOME="$(mktemp -d)"; \
  for key in $GPG_KEYS; do \
  gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key"; \
  done; \
  gpg --batch --verify php.tar.xz.asc php.tar.xz; \
  gpgconf --kill all; \
  rm -rf "$GNUPGHOME"; \
  fi; \
  \
  apt-mark auto '.*' > /dev/null; \
  apt-mark manual $savedAptMark > /dev/null; \
  apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false

COPY docker-php-source /usr/local/bin/

RUN set -eux; \
  \
  savedAptMark="$(apt-mark showmanual)"; \
  sed -e 's/stretch/buster/g' /etc/apt/sources.list > /etc/apt/sources.list.d/buster.list; \
  { \
  echo 'Package: *'; \
  echo 'Pin: release n=buster'; \
  echo 'Pin-Priority: -10'; \
  echo; \
  echo 'Package: libargon2*'; \
  echo 'Pin: release n=buster'; \
  echo 'Pin-Priority: 990'; \
  } > /etc/apt/preferences.d/argon2-buster; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
  libargon2-0-dev \
  libcurl4-openssl-dev \
  libedit-dev \
  libsodium-dev \
  libsqlite3-dev \
  libssl-dev \
  libxml2-dev \
  zlib1g-dev \
  ${PHP_EXTRA_BUILD_DEPS:-} \
  ; \
  rm -rf /var/lib/apt/lists/*; \
  \
  export \
  CFLAGS="$PHP_CFLAGS" \
  CPPFLAGS="$PHP_CPPFLAGS" \
  LDFLAGS="$PHP_LDFLAGS" \
  ; \
  docker-php-source extract; \
  cd /usr/src/php; \
  gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
  debMultiarch="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)"; \
  if [ ! -d /usr/include/curl ]; then \
    ln -sT "/usr/include/$debMultiarch/curl" /usr/local/include/curl; \
  fi; \
  ./configure \
  --build="$gnuArch" \
  --with-config-file-path="$PHP_INI_DIR" \
  --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
  \
  --enable-option-checking=fatal \
  \
  --with-mhash \
  \
  --enable-ftp \
  --enable-mbstring \
  --enable-mysqlnd \
  --with-pdo-sqlite=/usr \
  --with-sqlite3=/usr \
  \
  --with-curl \
  --with-libedit \
  --with-zlib \
  \
  $(test "$gnuArch" = 's390x-linux-gnu' && echo '--without-pcre-jit') \
  --with-libdir="lib/$debMultiarch" \
  \
  ${PHP72_CONFIGURE:-} \
  ${PHP_EXTRA_CONFIGURE_ARGS:-} \
  ; \
  make -j "$(nproc)"; \
  find -type f -name '*.a' -delete; \
  make install; \
  find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true; \
  make clean; \
  \
  cp -v php.ini-* "$PHP_INI_DIR/"; \
  \
  cd /; \
  docker-php-source delete; \
  \
  apt-mark auto '.*' > /dev/null; \
  [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; \
  find /usr/local -type f -executable -exec ldd '{}' ';' \
  | awk '/=>/ { print $(NF-1) }' \
  | sort -u \
  | xargs -r dpkg-query --search \
  | cut -d: -f1 \
  | sort -u \
  | xargs -r apt-mark manual \
  ; \
  apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false

COPY docker-php-ext-* /usr/local/bin/

RUN if [ -n "$PHP72_CONFIGURE" ]; then docker-php-ext-enable sodium; fi

RUN set -eux; \
      \
      if command -v a2enmod; then \
      a2enmod rewrite; \
      fi; \
      \
      savedAptMark="$(apt-mark showmanual)"; \
      \
      apt-get update; \
      apt-get install -y --no-install-recommends \
      libfreetype6-dev \
      libjpeg-dev \
      libpng-dev \
      libpq-dev \
      libzip-dev \
      ; \
      \
      docker-php-ext-configure gd \
      --with-freetype-dir=/usr \
      --with-jpeg-dir=/usr \
      --with-png-dir=/usr \
      ; \
      \
      docker-php-ext-install -j "$(nproc)" \
      gd \
      opcache \
      pdo_mysql \
      pdo_pgsql \
      zip \
      ; \
      \
      apt-mark auto '.*' > /dev/null; \
        apt-mark manual $savedAptMark; \
        ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
        | awk '/=>/ { print $3 }' \
        | sort -u \
        | xargs -r dpkg-query -S \
        | cut -d: -f1 \
        | sort -u \
        | xargs -rt apt-mark manual; \
        \
        apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
        rm -rf /var/lib/apt/lists/*

RUN { \
  echo 'opcache.memory_consumption=128'; \
  echo 'opcache.interned_strings_buffer=8'; \
  echo 'opcache.max_accelerated_files=4000'; \
  echo 'opcache.revalidate_freq=60'; \
  echo 'opcache.fast_shutdown=1'; \
  } > /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN pecl install xdebug-${XDEBUG_VERSION}
RUN docker-php-ext-enable xdebug
RUN echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "display_startup_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "display_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.idekey=\"PHPSTORM\"" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN cp /usr/share/zoneinfo/Mexico/General /etc/localtime

WORKDIR /var/www/html

COPY httpd.conf /etc/apache2/httpd.conf
COPY www.conf /usr/local/etc/php-fpm.d/www.conf
COPY index.php /var/www/localhost/htdocs

EXPOSE 80
