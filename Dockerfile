FROM alpine:latest

######################
# ENVIRONMENT
######################

ENV NGINX_VERSION 1.20.1

######################
# nginx User
######################

RUN addgroup -S nginx && adduser -S -g nginx nginx

######################
# Update and download
######################

WORKDIR /tmp/nginx

RUN apk update && apk upgrade --no-cache && apk add --no-cache git vim curl openssl-dev pcre-dev zlib-dev build-base && \
    curl -O http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    tar -xzvf nginx-${NGINX_VERSION}.tar.gz

######################
# Download Broli nginx modules
######################
WORKDIR /tmp/nginx/brotli
RUN git clone --recursive https://github.com/google/ngx_brotli.git

######################
# Modify nginx header src file
######################

WORKDIR /tmp/nginx/nginx-${NGINX_VERSION}
COPY ./ngx_http_header_filter_module.c /tmp/nginx/nginx-${NGINX_VERSION}/src/http

######################
# Create nginx directories
######################

RUN mkdir /var/cache/nginx

######################
# Install nginx
######################

RUN ./configure \
        --user=nginx \
        --group=nginx \
        --prefix=/etc/nginx \
        --sbin-path=/usr/sbin/nginx \
        --modules-path=/usr/lib/nginx/modules \
        --conf-path=/etc/nginx/conf/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/nginx.lock \
        --http-client-body-temp-path=/var/cache/nginx/client_temp \
        --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
        --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
        --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
        --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
        --with-compat \
        --with-threads \
        --with-http_addition_module \
        --with-http_auth_request_module \
        --with-http_dav_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_random_index_module \
        --with-http_realip_module \
        --with-http_secure_link_module \
        --with-http_slice_module \
        --with-http_ssl_module \
        --with-http_stub_status_module \
        --with-http_sub_module \
        --with-http_v2_module \
        --with-stream \
        --with-stream_realip_module \
        --with-stream_ssl_module \
        --with-stream_ssl_preread_module \
        --add-module=/tmp/nginx/brotli/ngx_brotli && \
    make && make install

######################
# Log Collection
######################

RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

WORKDIR /etc/nginx

######################
# NGINX Config File
######################

RUN mkdir -p /etc/nginx/conf.d/

COPY ./nginx.conf /etc/nginx/conf

COPY ./index.html /etc/nginx/html
COPY ./50x.html /etc/nginx/html

######################
# Clean-up and run
######################


RUN apk del build-base git && \
    rm -rf /tmp/nginx

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
