#
# Base para Alfresco 5.1
#
#
FROM  ubuntu:trusty
MAINTAINER Queres info@queres.com

ARG FILESERVER_USER=docker
ARG FILESERVER_PASSWORD

EXPOSE 8080
EXPOSE 8443
EXPOSE 8009
EXPOSE 8000
EXPOSE 9000

ENV JAVA_HOME /usr/lib/jvm/java-6-openjdk-amd64
ENV CATALINA_HOME /usr/local/tomcat

RUN apt-get update && apt-get install -y --no-install-recommends  \
	openjdk-6-jdk \
	imagemagick \
	swftools \
	gnupg \
	curl \
	libjpeg62 \
	libgif4 \
	libart-2.0-2 \
	&& \
	curl http://${FILESERVER_USER}:${FILESERVER_PASSWORD}@artifactory.queres.es/artifactory/images/org.swftools/swftools/swftools-0.9.0-0ubuntu2_amd64.deb -o /tmp/swftools_0.9.0-0ubuntu2_amd64.deb &&\
	dpkg -i /tmp/swftools_0.9.0-0ubuntu2_amd64.deb && \
	rm /tmp/swftools_0.9.0-0ubuntu2_amd64.deb && \
	rm -rf /var/lib/apt/lists/*

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

# let "Tomcat Native" live somewhere isolated
ENV TOMCAT_NATIVE_LIBDIR $CATALINA_HOME/native-jni-lib
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$TOMCAT_NATIVE_LIBDIR

# see https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/KEYS
# see also "update.sh" (https://github.com/docker-library/tomcat/blob/master/update.sh)
ENV GPG_KEYS 05AB33110949707C93A279E3D3EFE6B686867BA6 07E48665A34DCAFAE522E5E6266191C37C037D42 47309207D818FFD8DCD3F83F1931D684307A10A5 541FBE7D8F78B25E055DDEE13C370389288584E7 61B832AC2F1C5A90F0F9B00A1C506407564C17A3 713DA88BE50911535FE716F5208B0AB1D63011C7 79F7026C690BAA50B92CD8B66A3AD3F4F22C4FED 9BA44C2621385CB966EBA586F72C284D731FABEE A27677289986DB50844682F8ACB77FC2E86E29AC A9C5DF4D22E99998D9875A5110C01C5A2F6059E7 DCFD35E0BF8CA7344752DE8B6FB21E8933C60243 F3A04C595DB5B6A5F1ECA43E3B7BBB100D811BBE F7DA48BB64BCB84ECBA7EE6935CD23C10D498E23
RUN set -ex; \
	for key in $GPG_KEYS; do \
		gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
	done

ENV TOMCAT_MAJOR 6
ENV TOMCAT_VERSION 6.0.43
ENV TOMCAT_SHA1 455d9aabb7fa0372623dce43b403166379c820c6

ENV TOMCAT_TGZ_URLS \
# https://issues.apache.org/jira/browse/INFRA-8753?focusedCommentId=14735394#comment-14735394
	https://www.apache.org/dyn/closer.cgi?action=download&filename=tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz \
# if the version is outdated, we might have to pull from the dist/archive :/
	https://www-us.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz \
	https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz \
	https://archive.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

ENV TOMCAT_ASC_URLS \
	https://www.apache.org/dyn/closer.cgi?action=download&filename=tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz.asc \
# not all the mirrors actually carry the .asc files :'(
	https://www-us.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz.asc \
	https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz.asc \
	https://archive.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz.asc

WORKDIR $CATALINA_HOME

RUN set -eux; \
	apt-get update && apt-get install -y --no-install-recommends \
		openssl \
		ca-certificates \
		wget \
		libapr1-dev \
		coreutils \
		dpkg-dev dpkg \
		gcc \
		libc-dev \
		make \
		libssl-dev \
	; \
	\
	success=; \
	for url in $TOMCAT_TGZ_URLS; do \
		if wget -O tomcat.tar.gz "$url"; then \
			success=1; \
			break; \
		fi; \
	done; \
	[ -n "$success" ]; \
	\
	echo "$TOMCAT_SHA1 *tomcat.tar.gz" | sha1sum -c -; \
	\
	success=; \
	for url in $TOMCAT_ASC_URLS; do \
		if wget -O tomcat.tar.gz.asc "$url"; then \
			success=1; \
			break; \
		fi; \
	done; \
	[ -n "$success" ]; \
	\
	gpg --batch --verify tomcat.tar.gz.asc tomcat.tar.gz; \
	tar -xvf tomcat.tar.gz --strip-components=1; \
	rm bin/*.bat; \
	rm tomcat.tar.gz* ; \
	\
	nativeBuildDir="$(mktemp -d)"; \
	tar -xvf bin/tomcat-native.tar.gz -C "$nativeBuildDir" --strip-components=1; \
	( \
		export CATALINA_HOME="$PWD"; \
		cd "$nativeBuildDir/jni/native"; \
		gnuArch="$(dpkg-architecture -qDEB_BUILD_GNU_TYPE)"; \
		./configure \
			--build="$gnuArch" \
			--libdir="$TOMCAT_NATIVE_LIBDIR" \
			--prefix="$CATALINA_HOME" \
			--with-apr="$(which apr-1-config)" \
			--with-java-home="$(echo $JAVA_HOME)" \
			--with-ssl=yes; \
		make -j "$(nproc)"; \
		make install; \
	);\
	runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive "$TOMCAT_NATIVE_LIBDIR" \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	rm -rf /var/lib/apt/lists/* ; \
	rm -rf "$nativeBuildDir"; \
	rm bin/tomcat-native.tar.gz; \
	\
	find ./bin/ -name '*.sh' -exec sed -ri 's|^#!/bin/sh$|#!/usr/bin/env bash|' '{}' +

ADD http://${FILESERVER_USER}:${FILESERVER_PASSWORD}@artifactory.queres.es/artifactory/images/com.queres.alfresco/tomcat.rc/tomcat.rc-1.0.rc $CATALINA_HOME/tomcat.rc
COPY entorno.conf $CATALINA_HOME/entorno.conf

RUN sed -i "s,^shared.loader=.*,shared.loader=\${catalina.base}/shared/classes\,\${catalina.base}/shared/lib/*.jar,g" $CATALINA_HOME/conf/catalina.properties && \
	mkdir -p $CATALINA_HOME/shared/classes && \
	mkdir -p $CATALINA_HOME/shared/lib && \
	chmod +x $CATALINA_HOME/tomcat.rc && \
	curl http://${FILESERVER_USER}:${FILESERVER_PASSWORD}@artifactory.queres.es/artifactory/images/com.queres.alfresco/keystore-solr/keystore-solr-1.1.tar.gz -o /tmp/keystore.tar.gz && \
	tar -zxvf /tmp/keystore.tar.gz -C /opt && \
	rm /tmp/keystore.tar.gz

VOLUME /usr/local/tomcat/logs

CMD ["/usr/local/tomcat/tomcat.rc", "start"]
#CMD exec /bin/bash -c "trap : TERM INT; while [ 1 ]; do sleep 15; done & wait"
