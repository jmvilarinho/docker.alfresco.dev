#
# Base para Alfresco 5.1
#
#
FROM 321006660882.dkr.ecr.eu-west-1.amazonaws.com/queres/base-alfresco-5.1-alpine:1.0
MAINTAINER Queres info@queres.com

ARG FILESERVER_USER=docker
ARG FILESERVER_PASSWORD

ENV GLIBC_VERSION 2.26-r0

# Download and install glibc
RUN apk add --update curl && \
  curl -Lo /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
  curl -Lo glibc.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" && \
  curl -Lo glibc-bin.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk" && \
  apk add glibc-bin.apk glibc.apk && \
  /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
  echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
	rm -rf glibc.apk glibc-bin.apk /var/cache/apk/* &&\
	curl http://${FILESERVER_USER}:${FILESERVER_PASSWORD}@artifactory.queres.es/artifactory/images/org.alfresco/alfresco-pdf-renderer/alfresco-pdf-renderer-1.0-linux.tgz -o /tmp/alfresco-pdf-renderer-1.0-linux.tgz && \
	mkdir /opt/alfresco-pdf-renderer &&\
	tar -zxvf /tmp/alfresco-pdf-renderer-1.0-linux.tgz -C /opt/alfresco-pdf-renderer && \
	rm /tmp/alfresco-pdf-renderer-1.0-linux.tgz