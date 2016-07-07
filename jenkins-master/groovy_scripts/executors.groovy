import jenkins.model.*;

println "--> Disabling executors by default"
Jenkins.instance.setNumExecutors(0)
