
FROM alpine:3.4
MAINTAINER verbruggenalex@gmail.com

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && apk add --update \
    git \
    openssh-client \
    curl \
    openjdk8 \
    zip \
    bash \
    ttf-dejavu \
 && rm /var/cache/apk/*

# Set Jenkins Environment Variables
ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT 50000

ARG JENKINS_VERSION
ENV JENKINS_VERSION ${JENKINS_VERSION:-2.14}

ENV JENKINS_UC https://updates.jenkins-ci.org
ENV COPY_REFERENCE_FILE_LOG $JENKINS_HOME/copy_reference_file.log

ARG JAVA_OPTS
ENV JAVA_OPTS ${JAVA_OPTS:--Xmx2048m -Djenkins.install.runSetupWizard=false}
ENV JENKINS_OPTS="--handlerCountMax=300 --logfile=/var/log/jenkins/jenkins.log  --webroot=/var/cache/jenkins/war"

RUN echo "JENKINS_VERSION=$JENKINS_VERSION" ; echo "JAVA_OPTS=$JAVA_OPTS"

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

# Jenkins is run with user `jenkins`, uid = 1000
# If you bind mount a volume from the host or a data container, 
# ensure you use the same uid
RUN addgroup -g ${gid} ${group} \
    && adduser -h "$JENKINS_HOME" -u ${uid} -G ${group} -s /bin/bash -D ${user}

# Jenkins home directory is a volume, so configuration and build history
# can be persisted and survive image upgrades
VOLUME /var/jenkins_home

# `/usr/share/jenkins/ref/` contains all reference configuration we want
# to set on a fresh new installation. Use it to bundle additional plugins
# or config file with your custom jenkins Docker image.
RUN mkdir -p /usr/share/jenkins/ref/init.groovy.d

# Install Jenkins
RUN echo $JENKINS_VERSION ; curl -fL http://mirrors.jenkins-ci.org/war/$JENKINS_VERSION/jenkins.war -o /usr/share/jenkins/jenkins.war

# Install tini. Tini is a zombie reaper used at riot games to keep the Jenkins Master healthy.
RUN curl -fL https://github.com/krallin/tini/releases/download/v0.5.0/tini-static -o /bin/tini && chmod +x /bin/tini

# Prep Jenkins Directories
RUN chown -R jenkins "$JENKINS_HOME" /usr/share/jenkins/ref
RUN mkdir /var/log/jenkins
RUN mkdir /var/cache/jenkins
RUN chown -R jenkins:jenkins /var/log/jenkins
RUN chown -R jenkins:jenkins /var/cache/jenkins

# Install Plugins
COPY plugins.sh /usr/local/bin/plugins.sh
COPY plugins.list /usr/share/jenkins/plugins.list
RUN chmod +x  /usr/local/bin/plugins.sh
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.list

# Add groovy scripts to config master on start
# Note : If you add scripts in here they will be run everytime the container is restarted
# This can cause your existing config.xml to be overwritten.
# Groovy scripts will be copied to /var/jenkins_home/init.groovy.d at initialization 

#ADD groovy_scripts/ec2.groovy /usr/share/jenkins/ref/init.groovy.d/ec2.groovy
ADD groovy_scripts/init.groovy /usr/share/jenkins/ref/init.groovy.d/init.groovy
COPY jenkins.sh /usr/local/bin/jenkins.sh

# jenkins.sh will start the jenkins master 
RUN chmod +x /usr/local/bin/jenkins.sh

# Expose Ports for web and slave agents
EXPOSE 8080
EXPOSE 50000

#New to docker 1.12
HEALTHCHECK --interval=5s --timeout=3s --retries=3 \
      CMD curl -f http://localhost:8080 || exit 1

# Switch to the jenkins user
USER jenkins

ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins.sh"]

