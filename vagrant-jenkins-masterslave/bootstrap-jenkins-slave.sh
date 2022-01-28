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

#setup timezone
sudo timedatectl set-timezone America/Los_Angeles
echo "--------Timezone has been set"
#slave setup...
sudo useradd --system -U -d /var/lib/jenkins -m -s /bin/bash jenkins
sudo -i su -c "ssh-keygen -t rsa -f /root/.ssh/id_rsa -q -N \"\"" -m "root"
sudo -i su -c "ssh-keygen -b 2048 -t rsa -f /var/lib/jenkins/.ssh/id_rsa -q -N \"\"" -m "jenkins"
sudo install -d -m 700 -o jenkins -g jenkins /var/lib/jenkins/.ssh
sudo touch /var/lib/jenkins/.ssh/authorized_keys
sudo chown jenkins.jenkins /var/lib/jenkins/.ssh/authorized_keys -R
sudo chmod 600 /var/lib/jenkins/.ssh/authorized_keys -R
echo "--------Jenkins slave user created and prepped for manual key entry from master"
echo "--------TODO: make sure you import keys from master into slave's authorized_keys file"
echo "--------TODO: /var/lib/jenkins-slave/.ssh/authorized_keys"
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
