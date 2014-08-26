#/bin/bash -e

mkdir -p /srv/log/nginx
mkdir -p /srv/log/dockergen

docker run -d -p 80:80/tcp --name nginx -v /var/run/docker.sock:/docker.sock -v /srv/log/nginx:/var/log/nginx -v /srv/log/dockergen:/var/log/dockergen cloyne/nginx-proxy
