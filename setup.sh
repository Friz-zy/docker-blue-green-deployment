#!/usr/bin/env bash
mkdir -p /var/log/{green-backend/nginx,blue-backend/nginx,nginx}
docker-compose up -d
