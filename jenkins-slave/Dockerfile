FROM alpine:3.4 

MAINTAINER tomwillfixit 

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

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

ENV JENKINS_HOME /var/jenkins_home

RUN mkdir -p $JENKINS_HOME

# Jenkins is run with user `jenkins`, uid = 1000
# If you bind mount a volume from the host or a data container,
# ensure you use the same uid
RUN addgroup -g ${gid} ${group} \
    && adduser -h "$JENKINS_HOME" -u ${uid} -G ${group} -s /bin/bash -D ${user}

# Add swarm-client
RUN curl -o /bin/swarm-client.jar -k http://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/2.1/swarm-client-2.1-jar-with-dependencies.jar 

# Add start script
ADD start.sh /bin/start-agent.sh
RUN chmod +x /bin/start-agent.sh

# Login as jenkins
ENV HOME $JENKINS_HOME/worker
USER root 

# Start
CMD /bin/start-agent.sh
