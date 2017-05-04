FROM centos

MAINTAINER NGINX Docker Maintainers "280417314@qq.com"

#nginx install file
ENV NGINX_URL http://nginx.org/download/nginx-1.12.0.tar.gz

#nginx install file  dir
ENV NGINX_PACKAGE_PATH /usr/local/src/nginx

#nginx default install dir
ENV NGINX_PATH /usr/local/nginx

#nginx default depend
ENV NGINX_DEPEND pcre-devel \
		 zlib-devel \
		 gd-devel 

#nginx install confiure
ENV NGINX_CONFIGURE --with-stream \
		    --with-http_image_filter_module

ENV BIN_PATH /docker/bin

ENV BIN_FILE docker-entrypoint.sh

RUN yum update -y

RUN yum install -y gcc make wget \
	&& yum install -y $NGINX_DEPEND \
	&& wget $NGINX_URL -O nginx.tar.gz \ 
	&& mkdir -p $NGINX_PACKAGE_PATH \
	&& tar -xzvf nginx.tar.gz -C $NGINX_PACKAGE_PATH --strip-components=1 \
	&& rm -rf nginx.tar.gz \
	&& cd $NGINX_PACKAGE_PATH \
	&& ./configure $NGINX_CONFIGURE \
	&& make \
	&& make install \
	&& ln -s $NGINX_PATH/sbin/nginx /usr/local/bin

RUN mkdir -p $BIN_PATH

COPY $BIN_FILE $BIN_PATH

RUN ln -s $BIN_PATH/$BIN_FILE /usr/local/bin


ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 80

#CMD ["nginx","-g","daemon off;"]
