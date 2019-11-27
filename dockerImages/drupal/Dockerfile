FROM php

ENV DRUPAL_VERSION 8.7.8
ENV DRUPAL_MD5 f281eb14d8aabf0c3e78dd519ca4b640

RUN set -eux; \
      curl -fSL "https://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz" -o drupal.tar.gz; \
      echo "${DRUPAL_MD5} *drupal.tar.gz" | md5sum -c -; \
      tar -xz --strip-components=1 -f drupal.tar.gz; \
      rm drupal.tar.gz; \
      chown -R www-data:www-data sites modules themes
