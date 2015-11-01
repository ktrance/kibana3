FROM ubuntu:latest

#get around warnings
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -q

RUN apt-get install -yq wget

#install kibana
ENV KIBANA_VERSION 3.1.1

RUN cd /tmp && \
    wget -nv https://download.elasticsearch.org/kibana/kibana/kibana-${KIBANA_VERSION}.tar.gz && \
    tar zxf kibana-${KIBANA_VERSION}.tar.gz && \
    rm -f kibana-${KIBANA_VERSION}.tar.gz && \
    mkdir -p /var/www && \
    mv /tmp/kibana-${KIBANA_VERSION} /var/www/

#install nginx
RUN apt-get install -yq nginx && \
    echo "\ndaemon off;" >> /etc/nginx/nginx.conf

ADD conf/default /etc/nginx/sites-available/default

RUN sed -i 's/root.*$/root \/var\/www\/kibana-'"$KIBANA_VERSION"';/g' /etc/nginx/sites-available/default

VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx"]

CMD ["nginx"]

EXPOSE 80 
