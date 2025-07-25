#!/bin/bash
sudo wget -O /etc/yum.repos.d/jenkins.repo \ https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io-2023.key
sudo yum install fontconfig java-21-openjdk
systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins
