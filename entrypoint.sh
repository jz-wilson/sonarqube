#!/usr/bin/env bash

set -e

if [[ "${1:0:1}" != '-' ]]; then
  exec "$@"
fi

# Configure LDAP
if [[ -n ${LDAP_URL} ]] && [[ -n ${LDAP_PORT} ]]; then
    echo -e "ldap.url=$LDAP_URL:$LDAP_PORT" >> conf/sonar.properties
    echo -e "sonar.security.realm=LDAP" >> conf/sonar.properties
fi
if [[ -n ${LDAP_BIND_DN} ]]; then
    echo -e "ldap.bindDn=$LDAP_BIND_DN" >> conf/sonar.properties
fi
if [[ -n ${LDAP_PASSWORD} ]]; then
    echo -e "ldap.bindPassword=$LDAP_PASSWORD" >> conf/sonar.properties
fi
if [[ -n ${DOMAIN_NAME} ]]; then
    echo -e "ldap.realm=$DOMAIN_NAME" >> conf/sonar.properties
fi
if [[ -n ${LDAP_USER_BASE_DN} ]]; then
    echo -e "ldap.user.baseDn=$LDAP_USER_BASE_DN" >> conf/sonar.properties
fi
if [[ -n ${LDAP_USER_REQUEST} ]]; then
    echo -e "ldap.user.request=$LDAP_USER_REQUEST" >> conf/sonar.properties
fi
if [[ -n ${LDAP_GROUP_BASE_DN} ]]; then
    echo -e "ldap.group.baseDn=$LDAP_GROUP_BASE_DN" >> conf/sonar.properties
fi
if [[ -n ${LDAP_GROUP_REQUEST} ]]; then
    echo -e "ldap.group.request=$LDAP_GROUP_REQUEST" >> conf/sonar.properties
fi


# Parse Docker env vars to customize SonarQube
#
# e.g. Setting the env var sonar.jdbc.username=foo
#
# will cause SonarQube to be invoked with -Dsonar.jdbc.username=foo

declare -a sq_opts

while IFS='=' read -r envvar_key envvar_value
do
    if [[ "$envvar_key" =~ sonar.* ]]; then
        sq_opts+=("-D${envvar_key}=${envvar_value}")
    fi
done < <(env)"$SONAR_VERSION"

exec java -jar lib/sonar-application-"$SONAR_VERSION".jar \
  -Dsonar.log.console=true \
  -Dsonar.jdbc.username="$SONARQUBE_JDBC_USERNAME" \
  -Dsonar.jdbc.password="$SONARQUBE_JDBC_PASSWORD" \
  -Dsonar.jdbc.url="$SONARQUBE_JDBC_URL" \
  -Dsonar.web.javaAdditionalOpts="$SONARQUBE_WEB_JVM_OPTS -Dnode.store.allow_mmapfs=false -Djava.security.egd=file:/dev/./urandom" \
  "${sq_opts[@]}" \
  "$@"