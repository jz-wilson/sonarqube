FROM sonarqube:7.6-community

# Install Custom Plugins
RUN wget "https://github.com/sbaudoin/sonar-yaml/releases/download/v1.4.0/sonar-yaml-plugin-1.4.0.jar" && \
    wget "https://github.com/sbaudoin/sonar-ansible/releases/download/v2.0.0/sonar-ansible-plugin-2.0.0.jar" && \
    wget "https://github.com/QualInsight/qualinsight-plugins-sonarqube-smell/releases/download/qualinsight-plugins-sonarqube-smell-4.0.0/qualinsight-sonarqube-smell-plugin-4.0.0.jar" && \
    wget "https://github.com/sbaudoin/sonar-shellcheck/releases/download/v2.0.0/sonar-shellcheck-plugin-2.0.0.jar" && \
    wget "https://github.com/gabrie-allaigre/sonar-gitlab-plugin/files/2816503/sonar-gitlab-plugin-4.1.0-SNAPSHOT.zip" && \
    unzip "sonar-gitlab-plugin-4.1.0-SNAPSHOT.zip" && rm "sonar-gitlab-plugin-4.1.0-SNAPSHOT.zip"

# Replace Already Installed plugins with latest
RUN rm $SONARQUBE_HOME/extensions/plugins/sonar-java-plugin-* && \
    rm $SONARQUBE_HOME/extensions/plugins/sonar-python-plugin-* && \
    rm $SONARQUBE_HOME/extensions/plugins/sonar-php-plugin-* && \
    wget "https://binaries.sonarsource.com/Distribution/sonar-php-plugin/sonar-php-plugin-3.0.0.4537.jar" && \
    wget "https://binaries.sonarsource.com/Distribution/sonar-java-plugin/sonar-java-plugin-5.10.2.17019.jar" && \
    wget "https://binaries.sonarsource.com/Distribution/sonar-python-plugin/sonar-python-plugin-1.12.0.2726.jar"

# Move Plugins and list plugins
RUN mv *.jar $SONARQUBE_HOME/extensions/plugins && \
    ls -lah $SONARQUBE_HOME/extensions/plugins

# Configure LDAP via entrypoint script
COPY entrypoint.sh $SONARQUBE_HOME/bin/
USER sonarqube
ENTRYPOINT ["./bin/entrypoint.sh"]