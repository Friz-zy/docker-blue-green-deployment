# docker-blue-green-deployment
Example of blue-green deployment with docker-compose

time spent for the research is ~10.5 hours in sum

```
# ./setup.sh

# curl -s 127.0.0.1
green-backend

# ./switch.sh
Removing old "blue-backend" container
Stopping mnt_blue-backend_1 ... done
Going to remove mnt_blue-backend_1
Removing mnt_blue-backend_1 ... done
Starting new "blue-backend" container
Creating mnt_blue-backend_1 ... 
Creating mnt_blue-backend_1 ... done
New "blue-backend" container started
Sleeping 5 seconds
Checking "blue-backend" container
blue-backend
New "blue-backend" container passed http check
Changing ingress config
Check ingress configs
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
New ingress nginx config is valid
Reload ingress configs
Ingress reloaded
Sleeping 2 seconds
Checking new ingress backend
blue-backend
New ingress backend passed http check
All done here! :)

# curl -s 127.0.0.1
blue-backend
```
