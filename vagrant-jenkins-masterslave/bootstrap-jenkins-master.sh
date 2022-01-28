#!/bin/bash
set -e

sudo yum update -y
sudo yum install epel-release telnet bind-utils nano git -y
sudo yum -y install wget net-tools python3 daemonize java-1.8.0-openjdk
sudo yum update -y 
curl -O https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py --user
ls -a ~
export PATH=~/.local/bin:$PATH
source ~/.bash_profile
pip3 --version
pip3 install awscli --upgrade --user

# install jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum -y install jenkins -y
echo "--------Jenkins,Java installed"
sudo systemctl enable jenkins
sudo systemctl start jenkins

# install nexus
yum install -y maven
mkdir /opt/nexus && cd /opt/nexus
cd /opt/nexus
wget http://www.sonatype.org/downloads/nexus-latest-bundle.tar.gz
tar -xzvf nexus-latest-bundle.tar.gz && version=$(ls | grep -v latest | grep 'nexus-' | cut -f'2,3' -d'-') && ln -s nexus-$version nexus
cp /opt/nexus/nexus/bin/nexus /etc/init.d/
sed -i.bak -e 's/NEXUS_HOME=\"..\"/NEXUS_HOME=\"\/opt\/nexus\/nexus\"/' /etc/init.d/nexus
sed -i.bak -e 's|nexus-webapp-context-path=/nexus|nexus-webapp-context-path=/|' /opt/nexus/nexus/conf/nexus.properties
useradd nexus
chown -R nexus:nexus /opt/nexus/ && sudo chown nexus:nexus /etc/init.d/nexus
sed -i.bak -e 's/#RUN_AS_USER=/RUN_AS_USER=nexus/' /etc/init.d/nexus
systemctl stop firewalld && sudo systemctl disable firewalld
echo 'RUN_AS_USER=nexus' >> /etc/environment && export RUN_AS_USER=nexus
systemctl daemon-reload
/etc/init.d/nexus start && chkconfig nexus on

## Login to http://serverIP:8091
## Login: admin , Password: admin123

#setup timezone
sudo timedatectl set-timezone America/Los_Angeles
echo "--------Timezone has been set"
sudo -i su -c "ssh-keygen -t rsa -f /root/.ssh/id_rsa -q -N \"\"" -m "root"
sudo -i su -c "ssh-keygen -b 2048 -t rsa -f /var/lib/jenkins/.ssh/id_rsa -q -N \"\"" -m "jenkins"
echo "--------Jenkins user ssh keys generated"
sudo sh -c "echo \"jenkins ALL=(ALL)       NOPASSWD:ALL\" >> /etc/sudoers"
sudo sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
sudo service sshd restart
sudo cat >> /etc/hosts <<EOF
#jenkins servers - forced since no DNS
10.0.15.12      jenkins
10.0.15.13	jenkins-slave1
10.0.15.14	jenkins-slave2
EOF
echo "--------Added jenkins master/slave to hosts file"
