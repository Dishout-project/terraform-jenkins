#!/bin/bash

# update apt and install java
sudo apt-get update 
sudo apt-get install -y wget vim openjdk-8-jdk openjdk-8-jre

#create a user - jenkins and create a home directory for it
sudo useradd --create-home jenkins

# set jenkins default shell to bash
sudo usermod --shell /bin/bash jenkins

# deletes jenkins WAR file, if any
sudo rm -r /home/jenkins/jenkins.war

# briefly carries a task on user - jenkins to obtain the jenkins WAR file.
sudo su - jenkins -c "wget http://updates.jenkins-ci.org/latest/jenkins.war"

# copy jenkins-service file to systemd
sudo cp ../jenkins.service /etc/systemd/system

# new service added, systemd needs to be reloaded
sudo systemctl daemon-reload

# enable jenkins 
sudo systemctl enable jenkins

# start jenkins
sudo systemctl start jenkins
