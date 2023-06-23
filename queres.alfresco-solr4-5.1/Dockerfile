#
# Afresco Solr
#

#
FROM queres/base-alfresco-5.1-alpine:latest
MAINTAINER Queres info@queres.com

ARG FILESERVER_USER=docker
ARG FILESERVER_PASSWORD
ARG ALFRESCO_VERSION

ENV ALFRESCO_VERSION ${ALFRESCO_VERSION}
ENV SOLR_HOME       /opt/solr4
ENV INDEX_DIRECTORY /opt/index
ENV SOLR_ALFRESCO_HOST localhost
ENV SOLR_ALFRESCO_PORT 8080
ENV SOLR_ALFRESCO_PORT_SSL 8443

# Volumen para persistir indices
VOLUME ${INDEX_DIRECTORY}

ADD http://${FILESERVER_USER}:${FILESERVER_PASSWORD}@artifactory.queres.es/artifactory/images/org.alfresco/solr4/solr4-${ALFRESCO_VERSION}.zip /opt/solr4.zip
ADD http://${FILESERVER_USER}:${FILESERVER_PASSWORD}@artifactory.queres.es/artifactory/images/org.alfresco/solr4/solr4-${ALFRESCO_VERSION}.war $CATALINA_HOME/webapps/solr4.war

COPY server.xml $CATALINA_HOME/conf
COPY tomcat-users.xml $CATALINA_HOME/conf

RUN unzip -d /opt /opt/solr4.zip && \
	mkdir -p ${INDEX_DIRECTORY}/model && mkdir -p ${INDEX_DIRECTORY}/content && \
	echo "CATALINA_OPTS=\"\${CATALINA_OPTS} -Dsolr.allow.unsafe.resourceloading=true\"" >> $CATALINA_HOME/custom-entorno.conf && \
	echo "CATALINA_OPTS=\"\${CATALINA_OPTS} -Dsolr.solr.home=${SOLR_HOME}\"" >> $CATALINA_HOME/custom-entorno.conf && \
	echo "CATALINA_OPTS=\"\${CATALINA_OPTS} -Dsolr.solr.model.dir=${INDEX_DIRECTORY}/model\"" >> $CATALINA_HOME/custom-entorno.conf && \
	echo "CATALINA_OPTS=\"\${CATALINA_OPTS} -Dsolr.solr.content.dir=${INDEX_DIRECTORY}/content\"" >> $CATALINA_HOME/custom-entorno.conf
	
