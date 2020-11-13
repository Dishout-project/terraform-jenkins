#!/bin/bash

function install_docker {
    sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88

    sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io

    sudo groupadd docker
    sudo usermod -aG docker jenkins
}

function install_terraform {
    tf_version="0.13.2"

    wget https://releases.hashicorp.com/terraform/"$tf_version"/terraform_"$tf_version"_linux_amd64.zip
    sudo unzip terraform_"$tf_version"_linux_amd64.zip -d /usr/local/bin
}

install_docker
install_terraform