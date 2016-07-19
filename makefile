JENKINS_VERSION ?= 2.14
JAVA_OPTS ?= "-Xmx2048m -Djenkins.install.runSetupWizard=false"

version:
	@docker --version
	@docker-compose --version

health:
	@echo "Jenkins Master : `/usr/bin/docker inspect --format '{{ .State.Health.Status }}' jenkins-master`"
	@echo "Nginx : `/usr/bin/docker inspect --format '{{ .State.Health.Status }}' jenkins-nginx`"
#########################
# Build and Start Jenkins 
#########################

build:

	@echo "Building Jenkins Containers : Jenkins Version=${JENKINS_VERSION} : Java Opts=${JAVA_OPTS}"
	export JENKINS_VERSION=${JENKINS_VERSION} ; export JAVA_OPTS=${JAVA_OPTS} ; /usr/local/bin/docker-compose build 

start:
	@docker-compose up -d

stop:
	@docker-compose stop

status:
	@docker-compose ps

logs:
	@docker-compose logs
###################
# Cleanup
###################

clean:	stop
	@docker-compose rm -f jenkinsmaster jenkinsnginx

clean-data: clean
	@docker-compose rm -fv jenkinsdata

clean-images:
	@docker images -qf "dangling=true" |xargs docker rmi

clean-volumes:
	@docker volume ls -qf "dangling=true" |xargs docker volume rm
###################
# Test
###################

test: health build start status clean clean-data

