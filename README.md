# Dishout Jenkins server

This repository contans the terraform configuration for bringing up the Jenkins instance in GCP as well described within the `terraform` directory. The instance image is currently defined using packer described with the `packer` folder, although this is likely to change to using docker containers.

The role of this Jenkins server is to provide CI/CD capabilities for the Dishout webapp code to be able to build, test and deploy **(WIP)**.

This repository does not contain the definition of jobs used by Jenkins, these are defined in a separate repository

* Job definitions: https://github.com/Dishout-project/job-definitions

## How it works

### Github Actions

Since Jenkins is required by the rest of the Dishout project it requires bootstrapping through an additional 'pipeline', to do this several GitHub actions workflows are setup to terraform apply, destroy and packer build/apply in GCP. These worflows are defined in `.github/workflows`.

The workflows require the GCP account credentials, these are stored as an organisation secret, which would be able to be used by any repository within the Dishout organisation but currently is only used by the workflows in this repository. The secret is placed into a file during the workflow in order to allow terraform to manage infrastructure in the Dishout account. Below is the logic used during the workflow to setup the credential:

```
    - name: Terraform create credential
      env:
        GOOGLE_APPLICATION_CREDENTIALS: ${{ secrets.GCP_TERRAFORM }}
      run: |
        mkdir credential
        echo $GOOGLE_APPLICATION_CREDENTIALS > credential/gcp_credentials.json
```

### Packer

Packer is responsible for defining the image used to bring up the Jenkins instance. The installation of Jenkins is done during this stage as well as pre-configuring Jenkins to contain credentials and a **seed job** to populate Jenkins with the jobs defined in the job defintions repo.

The installation procedure is detailed within `Packerfile.json` in the *provisioners* block. The `install.sh` script within the `jenkins-setup` directory is responsible for installing Jenkins using the latest .war file from jenkins.io. The script also installs plugins defined in the `plugins.txt` file using the script `jenkins-setup/files/install-plugins.sh`. This script originates from here https://github.com/jenkinsci/docker/blob/master/install-plugins.sh. The upstream method has changed to using the `jenkins-plugin-cli` script to fetch plugins, the installation method will be changed in this repository to follow upstream.

#### Dishout user ssh key
Jenkins will authenticate with Github using the dishbot user (member of the Dishout organisation) via ssh. The dishbot user is configured with a public key and the corresponding private key is stored as a repository secret passed through to the packer build workflow with the purpose of transporting this credential to the packer build instance to be stored as a Jenkins secret.

The ssh key is placed in the jenkins service user's home directory during install, after which Jenkins is pointed to the private key to be stored as secret. This process occurs during Jenkins' initial startup using the `init.groovy.d/init.groovy` script (this directory and script is placed in the Jenkins home directory as part of the main install script).

#### Configuration as Code (CASC) plugin
The CASC plugin is used to confgure Jenkins with our users and to set up the seed job. The configuration is defined in the `casc.yaml` file in the `jenkins-setup/files` directory. The seed job points to the `initSeedJob.groovy` a job DSL script (used to define jenkins jobs). The seed job is defined as follows:

```
    definition {
        cpsScm {
            scm {
                git{
                    remote {
                        github("Dishout-project/job-definitions", "ssh")
                        credentials("github-key")
                    }
                    branch('$branch')
                }
        }
            scriptPath('resources/init/seedJob.groovy')
        }
```

The definition block shows that whilst this script definesthe behaviour and parameters used by the job such as the branch, the actual pipeline logic is fetched from the `job-definitions` repository with the repo being checked out using ssh and the path to the pipeline logic being the `seedJob.groovy` script.

This logic will go on to process additional DSL scripts used to define jobs for other components of the Dishout webapp, stored in the job-definitions repo with the pipeline logic being in the respective repositories of the webapp components in a file named `Jenkinsfile`.

### Terraform