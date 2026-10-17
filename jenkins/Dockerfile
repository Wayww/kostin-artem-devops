FROM jenkins/jenkins:lts-jdk21

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl docker-cli git python3 \
    && rm -rf /var/lib/apt/lists/*

COPY jenkins/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

COPY jenkins/init.groovy.d/ /usr/share/jenkins/ref/init.groovy.d/

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
