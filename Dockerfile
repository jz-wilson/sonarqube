FROM sonarqube:lts

ENV PHP_PLUGIN_VER=3.2.0.4868 \
    JAVA_PLUGIN_VER=5.12.0.17701 \
    PYTHON_PLUGIN_VER=1.14.1.3143

# Replace Already Installed plugins with latest
RUN rm $SONARQUBE_HOME/extensions/plugins/sonar-java-plugin-* && \
    rm $SONARQUBE_HOME/extensions/plugins/sonar-python-plugin-* && \
    rm $SONARQUBE_HOME/extensions/plugins/sonar-php-plugin-* && \
    curl -O "https://binaries.sonarsource.com/Distribution/sonar-php-plugin/sonar-php-plugin-$PHP_PLUGIN_VER.jar" && \
    curl -O "https://binaries.sonarsource.com/Distribution/sonar-java-plugin/sonar-java-plugin-$JAVA_PLUGIN_VER.jar" && \
    curl -O "https://binaries.sonarsource.com/Distribution/sonar-python-plugin/sonar-python-plugin-$PYTHON_PLUGIN_VER.jar"

COPY plugins.sh /plugins.sh

# Install Custom Plugins
RUN /plugins.sh && \
    curl -fLO "https://github.com/gabrie-allaigre/sonar-gitlab-plugin/releases/download/4.1.0-SNAPSHOT/sonar-gitlab-plugin-4.1.0-SNAPSHOT.jar"

# Move Plugins and list plugins
RUN mv *.jar $SONARQUBE_HOME/extensions/plugins && \
    ls -lah $SONARQUBE_HOME/extensions/plugins && \
    echo 'bootstrap.memory_lock: false' >> /opt/sonarqube/elasticsearch/config/elasticsearch.yml

# Configure LDAP via entrypoint script
COPY entrypoint.sh $SONARQUBE_HOME/bin/
USER sonarqube

ENTRYPOINT ["./bin/entrypoint.sh"]