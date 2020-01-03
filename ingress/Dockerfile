# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.11

CMD nginx -g 'daemon off; master_process on;'

RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"
RUN apt-get install nginx -y -o Dpkg::Options::="--force-confold"
RUN apt-get install logrotate -y -o Dpkg::Options::="--force-confold"

RUN rm -f /etc/nginx/sites-enabled/default

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose ports
EXPOSE 80
