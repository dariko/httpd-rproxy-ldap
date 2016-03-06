# httpd-ldap-rproxy

Apache reverse proxy ([mod_proxy](https://httpd.apache.org/docs/2.4/mod/mod_proxy.html)) with Basic authentication via LDAP ([mod_authnz_ldap](https://httpd.apache.org/docs/2.4/mod/mod_authnz_ldap.html))

### Running 
```
docker build -t httpd-ldap-rproxy
docker run -p 443:443 -e LDAP_URI="ldap://ldap.example.com/dc=example,dc=com?uid?sub?(objectClass=*)" \
           -e PROXY_URI="http://www.example.com" -e SERVERNAME="ldap-protected.www.example.com" \
           -e HTTPS_PEM_CERT="$(cat $TLS_CERTIFICATE)" -e  HTTPS_PEM_KEY="$(cat $TLS_CERTIFICATE_KEY)" \
           httpd-ldap-rproxy
```

### Environment variables
| Variable | Mandatory | Default | Description |
|:--|:--|:-----------|:------------|
|`LISTEN_PORT`|yes |`443`| Specifies the port the apache server will listen to.| 
|`PROXY_URI`|yes |    | Specifies the parameter for apache's [ProxyPass](https://httpd.apache.org/docs/2.4/mod/mod_proxy.html#proxypass "Apache docs") and [ProxyPassReverse](https://httpd.apache.org/docs/2.4/mod/mod_proxy.html#proxypassreverse "Apache Docs") directives.| 
|`SERVERNAME`|yes |  | Specifies the parameter for apache's [ServerName](https://httpd.apache.org/docs/2.4/mod/core.html#servername "Apache docs") directive. Must match HTTPS_PEM_CERT cn| 
|`BASIC_AUTH_STRING`|no|`LDAP Authentication`| Specifies the parameter for apache's [AuthName](https://httpd.apache.org/docs/2.4/mod/mod_authn_core.html#authname "Apache docs") directive.| 
|`HTTPS_CERT_PEM`|yes|| Apache's SSL/TLS PEM certificate text."
|`HTTPS_KEY_PEM`|yes|| Apache's SSL/TLS PEM certificate key text."
|`DHPARAM_PEM`|yes|| Apache's SSL/TLS PEM DHParameter."
|`CUSTOM_APACHE_CONFIG`|no||Specifies custom parameters to be appended to the apache virtualhost configuration.|
|`LDAP_URI`|yes||Specifies the URI of the LDAP server, as documented [here](<https://httpd.apache.org/docs/2.4/mod/mod_authnz_ldap.html#authldapurl> "Apache docs").|
|`LDAPS_CACERT_PEM`|no||LDAP CA Certificate.|
|`LDAP_BIND_USER_PATTERN`|no||Specifies the parameter for apache's [AuthLDAPInitialBindPattern](https://httpd.apache.org/docs/2.4/mod/mod_authnz_ldap.html#authldapinitialbindpattern). Also sets [AuthLDAPInitialBindAsUser](https://httpd.apache.org/docs/2.4/mod/mod_authnz_ldap.html#authldapinitialbindasuser), [AuthLDAPSearchAsUser](https://httpd.apache.org/docs/2.4/mod/mod_authnz_ldap.html#authldapsearchasuser) and [AuthLDAPCompareAsUser](https://httpd.apache.org/docs/2.4/mod/mod_authnz_ldap.html#authldapcompareasuser) to "on"|
|`PROXY_URI`|yes||Specifies the parameter for apache's [ProxyPass](https://httpd.apache.org/docs/2.4/mod/mod_proxy.html#proxypass "Apache docs") and [ProxyPassReverse](https://httpd.apache.org/docs/2.4/mod/mod_proxy.html#proxypassreverse "Apache Docs") directives.|
|`REQUIRE_COND`|no|`Require valid-user`|Apache Require directives, will be enclosed in a <RequireAll>.|
|`LOGLEVEL`|no|`warn`|Specifies the parameter for apache's [LogLevel](https://httpd.apache.org/docs/2.4/mod/core.html#loglevel).|
|`DISPLAY_CONFIG`|no||If set display the templated configuration before starting apache|

### PEM Certificates/keys
The variables requiring PEM certificates/keys must contain the certificate text including the newlines.

If invoking docker via command line:

```bash
-e LDAPS_CACERT_PEM="-----BEGIN CERTIFICATE-----\n...\n..."
-e LDAPS_CACERT_PEM="$(cat $TLS_CERTIFICATE_FILE)"
```

If using [docker-compose](https://docs.docker.com/compose/), in the `docker-compose.yml` file:

```yaml
environment:
  LDAPS_CACERT_PEM: |
    -----BEGIN CERTIFICATE-----
    ...
    ...
    -----END CERTIFICATE-----
```
