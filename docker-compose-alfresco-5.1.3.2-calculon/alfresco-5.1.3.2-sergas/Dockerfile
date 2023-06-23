#
# Afresco
#

#
FROM 321006660882.dkr.ecr.eu-west-1.amazonaws.com/queres/alfresco-5.1:5.1.3.2
MAINTAINER Queres info@queres.com

RUN apk --update add bash shadow && rm -rf /var/cache/apk/*

RUN groupadd -g 5000 tomcat && \
	useradd -u 5000 -g 5000 tomcat && \
	sed -i "s,^TOMCAT_USER=root.*,TOMCAT_USER=tomcat,g" /usr/local/tomcat/entorno.conf && \
	sed -i "s,^TOMCAT_GROUP=root.*,TOMCAT_GROUP=tomcat,g" /usr/local/tomcat/entorno.conf && \
	chown -R tomcat. /usr/local/tomcat
