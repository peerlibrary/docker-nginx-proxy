FROM cloyne/nginx

MAINTAINER Mitar <mitar.docker@tnode.com>

ENV DOCKER_HOST unix:///docker.sock

RUN apt-get update -q -q && \
 apt-get install wget ca-certificates --yes --force-yes && \
 mkdir /dockergen && \
 wget -P /dockergen https://github.com/jwilder/docker-gen/releases/download/0.3.1/docker-gen-linux-amd64-0.3.1.tar.gz && \
 tar xvzf /dockergen/docker-gen-linux-amd64-0.3.1.tar.gz -C /dockergen && \
 mkdir /etc/service/dockergen && \
 /bin/echo -e '#!/bin/sh' > /etc/service/dockergen/run && \
 /bin/echo -e 'exec /dockergen/docker-gen -watch -only-exposed -notify "/usr/sbin/nginx -s reload" /dockergen/nginx.tmpl /etc/nginx/sites-enabled/virtual 2>&1' >> /etc/service/dockergen/run && \
 chown root:root /etc/service/dockergen/run && \
 chmod 755 /etc/service/dockergen/run && \
 mkdir /etc/service/dockergen/log && \
 mkdir /var/log/dockergen && \
 /bin/echo -e '#!/bin/sh' > /etc/service/dockergen/log/run && \
 /bin/echo -e 'exec chpst -u nobody:nogroup svlogd -tt /var/log/dockergen' >> /etc/service/dockergen/log/run && \
 chown root:root /etc/service/dockergen/log/run && \
 chmod 755 /etc/service/dockergen/log/run && \
 chown nobody:nogroup /var/log/dockergen && \
 apt-get purge wget ca-certificates --yes --force-yes

COPY ./etc/conf.d/proxy.conf /etc/nginx/conf.d/
COPY ./etc/nginx.tmpl /dockergen/nginx.tmpl
