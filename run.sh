#!/bin/bash 

: ${LDAP_URI:?"Missing variable LDAP_URI"}
: ${PROXY_URI:?"Missing variable PROXY_URI"}
: ${SERVERNAME:?"Missing variable SERVERNAME"}
: ${HTTPS_CERT_PEM:?"Missing variable PEM_CERT"}
: ${HTTPS_KEY_PEM:?"Missing variable PEM_KEY"}

: ${BASIC_AUTH_STRING:="LDAP authentication"}
: ${REQUIRE_COND:="Require valid-user"}
: ${LISTEN_PORT:=443}

echo -e "$HTTPS_CERT_PEM" > /usr/local/apache2/conf/proxy_ldap.cert.pem
echo -e "$HTTPS_KEY_PEM" > /usr/local/apache2/conf/proxy_ldap.key.pem
[[ -v DHPARAM_PEM ]] && {
  echo "$DHPARAM_PEM" >> /usr/local/apache2/conf/proxy_ldap.cert.pem
}

[[ -v LDAPS_CACERT_PEM ]] && {
  echo "$LDAPS_CACERT_PEM" > /ldap_cacert.pem
}



eval "cat >> /usr/local/apache2/conf/proxy_ldap.conf << EOF
$(cat /proxy_ldap.conf.template)
EOF"

# base image CMD
httpd-foreground
