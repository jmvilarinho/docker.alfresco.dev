#
# Afresco
#

#
FROM 321006660882.dkr.ecr.eu-west-1.amazonaws.com/queres/base-alfresco-5.2-alpine:1.0
MAINTAINER Queres info@queres.com

ARG FILESERVER_USER=docker
ARG FILESERVER_PASSWORD
ARG ALFRESCO_VERSION

ENV ALFRESCO_VERSION ${ALFRESCO_VERSION}
ENV ALFRESCO_SOLR_HOST localhost
ENV ALFRESCO_SOLR_PORT 8080
ENV ALFRESCO_SOLR_PORT_SSL 8443

# Volumen para AMPS
VOLUME /amps.d
VOLUME /amps.share.d

# Volumen para persistir datos en Alfresco
VOLUME /opt/alf_data

ADD http://${FILESERVER_USER}:${FILESERVER_PASSWORD}@artifactory.queres.es/artifactory/images/com.mysql/mysql-connector-java/mysql-connector-java-5.1.42.jar $CATALINA_HOME/shared/lib/
ADD http://${FILESERVER_USER}:${FILESERVER_PASSWORD}@artifactory.queres.es/artifactory/images/com.oracle/ojdbc7/ojdbc7-12.1.0.2.0.jar $CATALINA_HOME/shared/lib/
ADD http://${FILESERVER_USER}:${FILESERVER_PASSWORD}@artifactory.queres.es/artifactory/images/org.alfresco/alfresco-mmt/alfresco-mmt-5.2.jar $CATALINA_HOME/alfresco-mmt.jar
ADD http://${FILESERVER_USER}:${FILESERVER_PASSWORD}@artifactory.queres.es/artifactory/images/org.alfresco.license/custom-license/custom-license-01.00.amp /tmp/
ADD http://${FILESERVER_USER}:${FILESERVER_PASSWORD}@artifactory.queres.es/artifactory/images/org.alfresco/alfresco/alfresco-${ALFRESCO_VERSION}.war $CATALINA_HOME/webapps/alfresco.war
ADD http://${FILESERVER_USER}:${FILESERVER_PASSWORD}@artifactory.queres.es/artifactory/images/org.alfresco/share/share-${ALFRESCO_VERSION}.war $CATALINA_HOME/webapps/share.war
ADD http://${FILESERVER_USER}:${FILESERVER_PASSWORD}@artifactory.queres.es/artifactory/images/org.alfresco/alfresco-share-services/alfresco-share-services-${ALFRESCO_VERSION}.amp /tmp/


COPY alfresco-global.properties $CATALINA_HOME/shared/classes/alfresco-global.properties
COPY tomcat-users.xml $CATALINA_HOME/conf
