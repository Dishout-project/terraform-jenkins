#!groovy

import jenkins.model.Jenkins
import com.cloudbees.plugins.credentials.domains.Domain
import com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey
import com.cloudbees.plugins.credentials.CredentialsScope
import org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl
import hudson.util.Secret

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

// Add GCP credential for terraform jenkins jobs
instance = Jenkins.instance
domain = Domain.global()
store = instance.getExtensionList(
  "com.cloudbees.plugins.credentials.SystemCredentialsProvider")[0].getStore()
def gcpFileContents = new File("$env.JENKINS_HOME/gcp_credentials.json").text
def gcpCredential = new StringCredentialsImpl(
  CredentialsScope.GLOBAL,
  "gcp-credential",
  "GCP credential for use with terraform",
  Secret.fromString(gcpFileContents)
)
store.addCredentials(domain, gcpCredential)