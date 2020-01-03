#!/bin/sh

set -e
mkdir -p /run/php
exec php-fpm7.2 --nodaemonize

