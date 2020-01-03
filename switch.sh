#!/usr/bin/env bash
if grep -q 'proxy_pass http://green-backend;' ./ingress/conf.d/ingress.conf
then
    CURRENT_BACKEND="green-backend"
    NEW_BACKEND="blue-backend"
else
    CURRENT_BACKEND="blue-backend"
    NEW_BACKEND="green-backend"
fi

echo "Removing old \"$NEW_BACKEND\" container"
docker-compose rm -f -s -v $NEW_BACKEND

echo "Starting new \"$NEW_BACKEND\" container"
docker-compose up -d $NEW_BACKEND
rv=$?
if [ $rv -eq 0 ]; then
    echo "New \"$NEW_BACKEND\" container started"
else
    echo "Docker compose failed with exit code: $rv"
    echo "Aborting..."
    exit 1
fi

echo "Sleeping 5 seconds"
sleep 5

echo "Checking \"$NEW_BACKEND\" container"
docker-compose exec -T $NEW_BACKEND curl -s 127.0.0.1/ | grep "$NEW_BACKEND"
rv=$?
if [ $rv -eq 0 ]; then
    echo "New \"$NEW_BACKEND\" container passed http check"
else
    echo "\"$NEW_BACKEND\" container's check failed"
    echo "Aborting..."
    exit 1
fi

echo "Changing ingress config"
cp ./ingress/conf.d/ingress.conf ./ingress/conf.d/ingress.conf.back
sed -i "s|proxy_pass http://.*;|proxy_pass http://$NEW_BACKEND;|g" ./ingress/conf.d/ingress.conf

echo "Check ingress configs"
docker-compose exec -T ingress nginx -g 'daemon off; master_process on;' -t
rv=$?
if [ $rv -eq 0 ]; then
    echo "New ingress nginx config is valid"
else
    echo "New ingress nginx config is not valid"
    echo "Aborting..."
    cp ./ingress/conf.d/ingress.conf.back ./ingress/conf.d/ingress.conf
    exit 1
fi

echo "Reload ingress configs"
docker-compose exec -T ingress nginx -g 'daemon off; master_process on;' -s reload
rv=$?
if [ $rv -eq 0 ]; then
    echo "Ingress reloaded"
else
    echo "Ingress reloading is failed"
    echo "Aborting..."
    cp ./ingress/conf.d/ingress.conf.back ./ingress/conf.d/ingress.conf
    exit 1
fi

echo "Sleeping 2 seconds"
sleep 2

echo "Checking new ingress backend"
curl  -s 127.0.0.1/ | grep "$NEW_BACKEND"
rv=$?
if [ $rv -eq 0 ]; then
    echo "New ingress backend passed http check"
else
    echo "New ingress backend's check failed"
    echo "Aborting..."
    cp ./ingress/conf.d/ingress.conf.back ./ingress/conf.d/ingress.conf
    exit 1
fi

echo "All done here! :)"
