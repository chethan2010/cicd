#!/bin/bash
sudo wget -O /etc/yum.repos.d/jenkins.repo \ https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io-2023.key
sudo yum install fontconfig java-21-openjdk
systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins
mkdir -p /var/lib/jenkins/.ssh
echo -e "Host *\n\tStrictHostKeyChecking no\n\tUserKnownHostsFile=/dev/null" > /var/lib/jenkins/.ssh/config
chown -R ec2-user:ec2-user /var/lib/jenkins/.ssh
chmod 600 /var/lib/jenkins/.ssh/config