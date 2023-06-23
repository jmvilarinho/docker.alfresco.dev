#
# Apache proxy para Alfresco y Solr
#
#
FROM httpd:2.4.28-alpine
MAINTAINER Queres info@queres.com

ARG FILESERVER_USER=docker
ARG FILESERVER_PASSWORD

ENV PROXY_TIMEOUT 300000
ENV ALFRESCO_PROTOCOL ajp
ENV ALFRESCO_PROTOCOL_PORT 8009
ENV SOLR_PROTOCOL ajp
ENV SOLR_PROTOCOL_PORT 8009

EXPOSE 443

VOLUME /usr/local/apache2/logs

ADD http://${FILESERVER_USER}:${FILESERVER_PASSWORD}@artifactory.queres.es/artifactory/images/com.queres.alfresco/keystore-solr/keystore-solr-1.1.tar.gz /tmp/keystore.tar.gz
COPY virtualhost-common.conf /usr/local/apache2/conf/extra
COPY httpd.sh /usr/local/bin
COPY make_config.sh /usr/local/bin

RUN	mkdir /opt && tar -zxvf /tmp/keystore.tar.gz -C /opt

CMD [ "/bin/sh","/usr/local/bin/httpd.sh"]

#CMD exec /bin/sh -c "trap : TERM INT; while [ 1 ]; do sleep 15; done & wait"
