#
# Afresco Solr
#

#
FROM queres/base-alfresco-4.2:latest
MAINTAINER Queres info@queres.com

ARG FILESERVER_USER=docker
ARG FILESERVER_PASSWORD
ARG ALFRESCO_VERSION

ENV ALFRESCO_VERSION ${ALFRESCO_VERSION}
ENV SOLR_HOME       /opt/solr
ENV INDEX_DIRECTORY /opt/index
ENV SOLR_ALFRESCO_HOST localhost
ENV SOLR_ALFRESCO_PORT 8080
ENV SOLR_ALFRESCO_PORT_SSL 8443

# Volumen para persistir indices
VOLUME ${INDEX_DIRECTORY}

COPY server.xml $CATALINA_HOME/conf
COPY tomcat-users.xml $CATALINA_HOME/conf

RUN apt-get update && apt-get install -y --no-install-recommends unzip && \
	curl http://${FILESERVER_USER}:${FILESERVER_PASSWORD}@artifactory.queres.es/artifactory/images/org.alfresco/solr/solr-${ALFRESCO_VERSION}.zip -o /tmp/solr.zip && \
	unzip -d ${SOLR_HOME} /tmp/solr.zip && \
	rm /tmp/solr.zip && \
	cp ${SOLR_HOME}/apache-solr-1.4.1.war $CATALINA_HOME/webapps/solr.war && \
	echo "CATALINA_OPTS=\"\${CATALINA_OPTS} -Dsolr.solr.home=${SOLR_HOME}\"" >> $CATALINA_HOME/custom-entorno.conf && \
	apt-get remove -y unzip && \
	rm -rf /var/lib/apt/lists/*
