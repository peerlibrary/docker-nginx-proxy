#/bin/bash -e

docker run -d -p 80:80/tcp --name nginx -v /var/run/docker.sock:/docker.sock -v /srv/var/log/nginx:/var/log/nginx -v /srv/var/log/dockergen:/var/log/dockergen cloyne/nginx-proxy
