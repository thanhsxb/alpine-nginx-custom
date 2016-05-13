FROM alpine:latest
MAINTAINER Hoang-Thanh VO <contact@thanh-vo.fr>

ENV NGINX_VERSION=1.10.0

RUN \
  pkgs1="build-base linux-headers openssl-dev pcre-dev curl zlib-dev" \
  && pkgs2="ca-certificates openssl pcre zlib" \
  && apk --no-cache add ${pkgs1} ${pkgs2} \
  && mkdir /tmp/src \
  && cd /tmp/src \
  && curl -fsSL http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -o nginx-${NGINX_VERSION}.tar.gz \
  && tar -xzf nginx-${NGINX_VERSION}.tar.gz \
  && cd nginx-${NGINX_VERSION} \
  && ./configure \
  --user=www-data \
  --group=www-data \
  --prefix=/etc/nginx \
  --sbin-path=/usr/sbin/nginx \
  --error-log-path=/var/log/nginx/error.log \
  --http-log-path=/var/log/nginx/access.log \
  --with-ipv6 \
  --with-http_auth_request_module \
  --with-http_dav_module \
  --with-http_flv_module \
  --with-http_gunzip_module \
  --with-http_gzip_static_module \
  --with-http_random_index_module \
  --with-http_realip_module \
  --with-http_secure_link_module \
  --with-http_stub_status_module \
  --with-http_ssl_module \
  --with-http_v2_module \
  --with-stream \
  --with-stream_ssl_module \
  && make install \
  && make clean \
  && rm -rf /tmp \
  && apk del ${pkgs1} \
  && adduser -D www-data \
  && ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log
  
ADD contents /

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]