#!groovy

import jenkins.model.Jenkins
import com.cloudbees.plugins.credentials.domains.Domain
import com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey
import com.cloudbees.plugins.credentials.CredentialsScope

// Add deploy key for the centrally shared pipeline and configuration repository
def env = System.getenv()
def domain = Domain.global()
def store = Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()
def keyFileContents = new File("$env.JENKINS_HOME/.ssh/github-key").text
def privateKey = new BasicSSHUserPrivateKey(
  CredentialsScope.GLOBAL,
  "github-key",
  "jenkins",
  new BasicSSHUserPrivateKey.DirectEntryPrivateKeySource(keyFileContents),
  "",
  "SSH key for shared-library"
)
store.addCredentials(domain, privateKey)

