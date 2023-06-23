#
# Afresco 4.2.4.20
#

#
FROM 321006660882.dkr.ecr.eu-west-1.amazonaws.com/queres/alfresco-4.2:4.2.4.20
MAINTAINER Queres info@queres.com

ADD custom-log4j.properties $CATALINA_HOME/shared/classes/alfresco/extension/custom-log4j.properties
ADD xuntalog.properties $CATALINA_HOME/shared/classes/es/xunta/xuntalog.properties
ADD share-config-custom.xml $CATALINA_HOME/shared/classes/alfresco/web-extension/share-config-custom.xml
ADD server.xml $CATALINA_HOME/conf/server.xml
RUN rm -rf  $CATALINA_HOME/webapps/ROOT
