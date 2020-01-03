# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.11

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"
RUN apt-get install software-properties-common tzdata -y -o Dpkg::Options::="--force-confold"
RUN add-apt-repository -y ppa:ondrej/php
RUN apt-get install nginx -y -o Dpkg::Options::="--force-confold"
RUN apt-get install php7.2-fpm -y -o Dpkg::Options::="--force-confold"
RUN apt-get install logrotate -y -o Dpkg::Options::="--force-confold"

# Temporary solution for problem with syslog-ng startup
RUN echo "#!/usr/bin/env bash\n exit 0" > /etc/my_init.d/10_syslog-ng.init

COPY nginx.conf /etc/nginx/nginx.conf
COPY backend.conf /etc/nginx/conf.d/backend.conf
RUN rm -f /etc/nginx/sites-enabled/default
COPY index.php /var/www/html/index.php
# COPY www.conf /etc/php/7.2/fpm/pool.d/www.conf
COPY nginx.sh /etc/service/nginx/run
COPY php-fpm.sh /etc/service/php-fpm/run

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose ports
EXPOSE 80
