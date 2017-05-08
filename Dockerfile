FROM centos

MAINTAINER NGINX Docker Maintainers "280417314@qq.com"

#nginx config git
ENV NGINX_GIT https://github.com/mypjb/nginx-docker.git

#nginx install file
ENV NGINX_URL http://nginx.org/download/nginx-1.12.0.tar.gz

#nginx install file  dir
ENV NGINX_PACKAGE_PATH /usr/local/package/nginx

#nginx default install dir
ENV NGINX_PATH /usr/local/nginx

#nginx default depend
ENV NGINX_DEPEND pcre-devel \
		 zlib-devel \
		 gd-devel 

#nginx install confiure
ENV NGINX_CONFIGURE --with-stream

RUN yum update -y

RUN yum install -y gcc make wget net-tools git \
	&& yum install -y $NGINX_DEPEND \
	&& wget $NGINX_URL -O nginx.tar.gz \ 
	&& mkdir -p $NGINX_PACKAGE_PATH \
	&& tar -xzvf nginx.tar.gz -C $NGINX_PACKAGE_PATH --strip-components=1 \
	&& rm -rf nginx.tar.gz \
	&& cd $NGINX_PACKAGE_PATH \
	&& ./configure $NGINX_CONFIGURE \
	&& make \
	&& make install \
	&& ln -s $NGINX_PATH/sbin/nginx /usr/local/bin \
	&& mkdir nginx_git \
	&& git clone $NGINX_GIT nginx_git \
	&& cp -rf nginx_git/conf/* $NGINX_PATH/conf


EXPOSE 80

CMD nginx ; /bin/bash;
