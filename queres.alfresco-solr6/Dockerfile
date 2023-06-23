#
# Afresco Solr
#

#
FROM openjdk:8u131-alpine
MAINTAINER Queres info@queres.com

ARG FILESERVER_USER=docker
ARG FILESERVER_PASSWORD
ARG SEARCH_SERVICES_VERSION

ENV SEARCH_SERVICES_VERSION ${SEARCH_SERVICES_VERSION}
ENV INDEX_DIRECTORY /opt/index
ENV SOLR_HOME       /opt/alfresco-search-services/solrhome
ENV SOLR_ALFRESCO_HOST localhost
ENV SOLR_ALFRESCO_PORT 8080

ENV SOLR_DATA_DIR_ROOT ${INDEX_DIRECTORY}
ENV SOLR_SOLR_CONTENT_DIR ${SOLR_DATA_DIR_ROOT}/contentstore
ENV SOLR_SOLR_MODEL_DIR   ${SOLR_DATA_DIR_ROOT}/alfrescoModel

# Volumen para persistir indices
VOLUME ${INDEX_DIRECTORY}

WORKDIR /opt/alfresco-search-services

RUN apk add --no-cache \
        lsof \
        gnupg \
        procps \
        tar \
        bash \
        curl && \
	curl http://${FILESERVER_USER}:${FILESERVER_PASSWORD}@artifactory.queres.es/artifactory/images/org.alfresco/alfresco-search-services/alfresco-search-services-${SEARCH_SERVICES_VERSION}.zip -o /tmp/alfresco-search-services-${SEARCH_SERVICES_VERSION}.zip && \
	unzip /tmp/alfresco-search-services-${SEARCH_SERVICES_VERSION}.zip -d /opt && \
	rm /tmp/alfresco-search-services-${SEARCH_SERVICES_VERSION}.zip && \
	mkdir -p ${SOLR_DATA_DIR_ROOT}/contentstore ${SOLR_DATA_DIR_ROOT}/alfrescoModel

CMD ./solr/bin/solr start -a "-Dcreate.alfresco.defaults=alfresco,archive" -force && tail -f /opt/alfresco-search-services/logs/solr.log
#CMD exec /bin/bash -c "trap : TERM INT; while [ 1 ]; do sleep 15; done & wait"
