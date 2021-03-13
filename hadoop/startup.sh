
# some updates
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg


# Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# repository
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# install docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

#install Apache Ant
sudo apt install -y openjdk-11-jre
sudo apt install snapd
sudo snap install ant --classic
sudo apt update
sudo apt install ant
wget https://mirror-hk.koddos.net/apache//ant/binaries/apache-ant-1.10.9-bin.tar.gz
sudo tar -xf apache-ant-1.10.9-bin.tar.gz -C /usr/local
sudo ln -s /usr/local/apache-ant-1.10.9/ /usr/local/ant
# https://idroot.us/install-apache-ant-ubuntu-20-04/

# docker nginx
sudo docker run --name nginx -d -p 80:80 nginx

# docker hadoop
sudo docker run --name hadoop -d -p 8088:8088 -p 50070:50070 sequenceiq/hadoop-docker:2.7.1

#docker exec -it hadoop bash

# install docker-compose
#sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
#sudo chmod +x /usr/local/bin/docker-compose

# test hadoop
#git clone https://github.com/big-data-europe/docker-hadoop.git
#cd docker-hadoop
#sudo docker-compose up


# sources
# https://github.com/big-data-europe/docker-hadoop
# https://clubhouse.io/developer-how-to/how-to-set-up-a-hadoop-cluster-in-docker/
# https://hub.docker.com/r/sequenceiq/hadoop-docker/
# curl localhost:9870