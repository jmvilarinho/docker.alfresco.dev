#
# Base para Alfresco 5.1
#
#
FROM tomcat:7.0.82-jre8-alpine
MAINTAINER Queres info@queres.com

ARG FILESERVER_USER=docker
ARG FILESERVER_PASSWORD

EXPOSE 8080
EXPOSE 8443
EXPOSE 8009
EXPOSE 8000
EXPOSE 9000

VOLUME /usr/local/tomcat/logs

RUN apk update && apk add \
	imagemagick \
	curl \
	fontconfig \
	ttf-dejavu && \
	rm -rf /var/cache/apk/*

ADD http://${FILESERVER_USER}:${FILESERVER_PASSWORD}@artifactory.queres.es/artifactory/images/com.queres.alfresco/tomcat.rc/tomcat.rc-1.0.rc $CATALINA_HOME/tomcat.rc
COPY entorno.conf $CATALINA_HOME/entorno.conf

RUN sed -i "s,^shared.loader=.*,shared.loader=\${catalina.base}/shared/classes\,\${catalina.base}/shared/lib/*.jar,g" $CATALINA_HOME/conf/catalina.properties && \
	mkdir -p $CATALINA_HOME/shared/classes && \
	mkdir -p $CATALINA_HOME/shared/lib && \
	chmod +x $CATALINA_HOME/tomcat.rc && \
	mkdir /opt && \
	curl http://${FILESERVER_USER}:${FILESERVER_PASSWORD}@artifactory.queres.es/artifactory/images/com.queres.alfresco/keystore-solr/keystore-solr-1.1.tar.gz -o /tmp/keystore.tar.gz && \
	tar -zxvf /tmp/keystore.tar.gz -C /opt && \
	rm /tmp/keystore.tar.gz

ENV PS1 "\[\e]0;\u@\h: \w\a\]\u@\h:\w\$ "
ENV LC_ALL "en_US"

CMD ["/usr/local/tomcat/tomcat.rc", "start"]
#CMD exec /bin/sh -c "trap : TERM INT; while [ 1 ]; do sleep 15; done & wait"
