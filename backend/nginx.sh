#!/bin/sh

set -e
exec nginx -g 'daemon off; master_process on;'
