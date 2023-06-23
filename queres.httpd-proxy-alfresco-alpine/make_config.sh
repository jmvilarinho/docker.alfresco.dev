#/bin/bash

[ ! -e /usr/local/apache2/htdocs/alfresco ] && touch /usr/local/apache2/htdocs/alfresco
[ ! -e /usr/local/apache2/htdocs/share ] && touch /usr/local/apache2/htdocs/share
[ ! -e /usr/local/apache2/htdocs/solr ] && touch /usr/local/apache2/htdocs/solr
[ ! -h /usr/local/apache2/htdocs/logs ] && ln -s /usr/local/apache2/logs /usr/local/apache2/htdocs/logs
[ ! -h /usr/local/apache2/htdocs/keystore ] && ln -s /opt/keystore /usr/local/apache2/htdocs/keystore

if ! grep -q "virtualhost-base.conf" "/usr/local/apache2/conf/httpd.conf"; then
	echo "Include conf/extra/virtualhost-base.conf" >> /usr/local/apache2/conf/httpd.conf
fi
		
echo '
ServerName localhost

LoadModule ssl_module modules/mod_ssl.so
LoadModule slotmem_shm_module modules/mod_slotmem_shm.so
LoadModule socache_shmcb_module modules/mod_socache_shmcb.so

LoadModule proxy_module modules/mod_proxy.so
LoadModule lbmethod_bybusyness_module modules/mod_lbmethod_bybusyness.so
LoadModule lbmethod_byrequests_module modules/mod_lbmethod_byrequests.so
LoadModule lbmethod_bytraffic_module modules/mod_lbmethod_bytraffic.so
LoadModule proxy_ajp_module modules/mod_proxy_ajp.so
LoadModule proxy_balancer_module modules/mod_proxy_balancer.so
LoadModule proxy_connect_module modules/mod_proxy_connect.so
LoadModule proxy_express_module modules/mod_proxy_express.so
LoadModule proxy_fcgi_module modules/mod_proxy_fcgi.so
LoadModule proxy_fdpass_module modules/mod_proxy_fdpass.so
LoadModule proxy_ftp_module modules/mod_proxy_ftp.so
LoadModule proxy_http_module modules/mod_proxy_http.so
LoadModule proxy_scgi_module modules/mod_proxy_scgi.so
LoadModule proxy_wstunnel_module modules/mod_proxy_wstunnel.so

Include conf/extra/000-default.conf
Include conf/extra/000-default.ssl.conf

' > /usr/local/apache2/conf/extra/virtualhost-base.conf

echo "   ProxyTimeout ${PROXY_TIMEOUT}" >/usr/local/apache2/conf/extra/virtualhost-proxy-members.conf

if [ ! -z "$ALFRESCO_MEMBERS" ]; then
	echo "   <Proxy balancer://balancerAlfresco>" >>/usr/local/apache2/conf/extra/virtualhost-proxy-members.conf
	echo "      ProxySet lbmethod=byrequests stickysession=JSESSIONID|jsessionid nofailover=On" >>/usr/local/apache2/conf/extra/virtualhost-proxy-members.conf
	for i in $(echo $ALFRESCO_MEMBERS | sed "s/,/ /g"); do
    echo "New Alfresco balancer node $i"
		echo "      BalancerMember ${ALFRESCO_PROTOCOL}://$i:${ALFRESCO_PROTOCOL_PORT} route=$i" >>/usr/local/apache2/conf/extra/virtualhost-proxy-members.conf
	done
	echo "   </Proxy>" >>/usr/local/apache2/conf/extra/virtualhost-proxy-members.conf
fi
if [ ! -z "$SOLR_MEMBERS" ]; then	
	echo "   <Proxy balancer://balancerSolr>" >>/usr/local/apache2/conf/extra/virtualhost-proxy-members.conf
	echo "      ProxySet lbmethod=byrequests stickysession=JSESSIONID|jsessionid nofailover=On" >>/usr/local/apache2/conf/extra/virtualhost-proxy-members.conf
	for i in $(echo $SOLR_MEMBERS | sed "s/,/ /g"); do
    echo "New Solr balancer node $i"
		echo "      BalancerMember ${SOLR_PROTOCOL}://$i:${SOLR_PROTOCOL_PORT} route=$i" >>/usr/local/apache2/conf/extra/virtualhost-proxy-members.conf
	done
	echo "   </Proxy>" >>/usr/local/apache2/conf/extra/virtualhost-proxy-members.conf
fi

echo '
<VirtualHost *:80>
   Include /usr/local/apache2/conf/extra/virtualhost-common.conf

   CustomLog /usr/local/apache2/logs/proxy_access.log combined-tomcat
   ErrorLog  /usr/local/apache2/logs/proxy_error.log

   Include /usr/local/apache2/conf/extra/virtualhost-proxy-members.conf
</VirtualHost>
' > /usr/local/apache2/conf/extra/000-default.conf

echo '
Listen 443

SSLCipherSuite HIGH:MEDIUM:!MD5:!RC4:!3DES
SSLProxyCipherSuite HIGH:MEDIUM:!MD5:!RC4:!3DES
SSLHonorCipherOrder on
SSLProtocol all -SSLv3
SSLProxyProtocol all -SSLv3
SSLPassPhraseDialog  builtin
SSLSessionCache   "shmcb:/usr/local/apache2/logs/ssl_scache(512000)"
SSLSessionCacheTimeout  300

<VirtualHost _default_:443>
   Include /usr/local/apache2/conf/extra/virtualhost-common.conf

   SSLEngine on
   SSLCertificateFile    /opt/keystore/apache/apache_docker.crt
   SSLCertificateKeyFile /opt/keystore/apache/apache_docker.key
   SSLCACertificateFile  /opt/keystore/apache/ca_docker.crt
   SSLVerifyClient require
   SSLVerifyDepth 2

   # enviar certificado a Tomcat
   SSLOptions +ExportCertData
   
   BrowserMatch "MSIE [2-5]" nokeepalive ssl-unclean-shutdown downgrade-1.0 force-response-1.0

   CustomLog /usr/local/apache2/logs/proxy_access.ssl.log combined-tomcat
   ErrorLog  /usr/local/apache2/logs/proxy_error.ssl.log

   Include /usr/local/apache2/conf/extra/virtualhost-proxy-members.conf
</VirtualHost>

' > /usr/local/apache2/conf/extra/000-default.ssl.conf

# Reemplazar en cualquier archivo
for var in $(env); do
	if [ "$(echo \"$var\"|grep 'REPLACE_TEXT_IN_FILE_')" != "" ]; then
		varname=$(echo $var|cut -d= -f1)
		value=$(eval "echo \"\$$varname\"")

		filename=$(echo $value|cut -d\| -f1)
		search=$(echo $value|cut -d\| -f2)
		replace=$(echo $value|cut -d\| -f3)
		
		if [ -f $filename ]; then
			echo "Replace '${search}' to '${replace}' into '${filename}'"
			sed -i "s,${search},${replace},g" ${filename}
		else
			echo "${filename} not found to replace '${search}' "
		fi
	fi
done

echo
echo "Proxy config :"
grep ProxyPass /usr/local/apache2/conf/extra/virtualhost-common.conf
echo

