#!/bin/bash

docker rm -f openldap || true
docker run -d \
    --volume $(pwd)/tests:/tests \
    --name openldap \
    --env INIT_CONFIG=y \
    --env LOGLEVEL=256 \
    --net host \
    dariko/docker-openldap-centos
sleep 0.5
for schema in core cosine inetorgperson
do
docker exec -it openldap \
    /usr/local/openldap/bin/ldapadd \
        -H ldap://localhost \
        -D cn=config \
        -w password \
        -f  /usr/local/openldap/etc/openldap/schema/$schema.ldif
done

docker exec -it openldap \
    /usr/local/openldap/bin/ldapadd \
        -H ldap://localhost \
        -D cn=config \
        -w password \
        -f /tests/ldap_init.ldif
