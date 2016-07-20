import hudson.model.*;
import jenkins.model.*;


Thread.start {
      sleep 10000
      println "--> Setting agent port for jnlp"
      def env = System.getenv()
      int port = env['JENKINS_SLAVE_AGENT_PORT'].toInteger()
      Jenkins.instance.setSlaveAgentPort(port)
      println "--> Setting agent port for jnlp... done"
      println "--> Disabling master executors"
      Jenkins.instance.setNumExecutors(1)
}
