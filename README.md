
This repository contains the source and configuration used to build a Alpine Linux based Jenkins Master and Slave


## Dependencies

You will need docker 1.12 and docker-compose 1.7.0 or newer installed. 

Check which version you have : 
```
make version 
```

## Usage

### Build the Jenkins Master, NGINX and slave images

```
make build
```

### Start Jenkins Master
```
make start

Jenkins will be running at : http://localhost:80

Note : If you are using boot2docker or docker toolbox you may need to forward port 80 to the host. For more details on port forwarding please check the Docker website.
```

### Check Jenkins container status 
```
make status

Example output :

          Name                         Command               State                  Ports                
--------------------------------------------------------------------------------------------------------
jenkinsci_jenkinsdata_1     echo Data container for Je ...   Exit 0                                      
jenkinsci_jenkinsmaster_1   /usr/local/bin/jenkins.sh        Up       0.0.0.0:50000->50000/tcp, 8080/tcp 
jenkinsci_jenkinsnginx_1    nginx                            Up       0.0.0.0:80->80/tcp                 

Note : The jenkinsci_jenkinsdata_1 container will not be running. This is expected.  It only gets created once and then exits.  For more details on Data Volume containers please check the Docker website.

```

### Check service health
```
make health
```

### Stop Jenkins Master
```
make stop
```

### Remove Jenkins Master, NGINX and Backup containers
```
make clean
```

### Remove Jenkins Data Volume : WARNING : This will remove your build history and configuration
```
make clean-data
```
