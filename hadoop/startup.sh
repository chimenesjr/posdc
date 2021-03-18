
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

# docker nginx
# sudo docker run --name nginx -d -p 80:80 nginx

# # docker hadoop
sudo docker run --name hadoop -d \
    -p 8088:8088 \
    -p 50070:50070 \
    -e CLASSPATH=":/usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-client-core-2.7.1.jar:/usr/local/hadoop/share/hadoop/common/hadoop-common-2.7.1.jar" \
    sequenceiq/hadoop-docker:2.7.1

# docker exec -it hadoop bash


# copy source files
git clone https://github.com/chimenesjr/posdc.git
docker cp posdc/hadoop/. hadoop:/usr/local/hadoop/examples/

#install Apache Ant (https://www.unixmen.com/install-apache-ant-maven-tomcat-centos-76-5/)
wget https://downloads.apache.org//ant/binaries/apache-ant-1.9.15-bin.zip
docker cp apache-ant-1.9.15-bin.zip hadoop:/usr/local/hadoop/examples/apache-ant-1.9.15-bin.zip
docker exec hadoop unzip /usr/local/hadoop/examples/apache-ant-1.9.15-bin.zip
docker exec hadoop mv /apache-ant-1.9.15 /opt/ant
docker exec hadoop ln -s /opt/ant/bin/ant /usr/bin/ant
gsutil cp gs://igti-data-science/hadoop/ant.sh .
docker cp ant.sh hadoop:/etc/profile.d/ant.sh
docker exec hadoop chmod +x /etc/profile.d/ant.sh
docker exec hadoop source /etc/profile.d/ant.sh


# build and execute app
docker exec hadoop ant -f /usr/local/hadoop/examples/ExemploIGTI/build_ExemploIGTI.xml makejar
docker exec hadoop mkdir /usr/local/hadoop/Dados
sleep 30
docker exec hadoop cp /usr/local/hadoop/examples/examples/arquivoBigData.txt /usr/local/hadoop/Dados
docker exec hadoop ./usr/local/hadoop/bin/hadoop jar /usr/local/hadoop-2.7.1/examples/ExemploIGTI/ExemploIGTI.jar IGTI.ExemploIGTI
docker exec hadoop /usr/local/hadoop/bin/hdfs dfs -cat /user/root/Saida/part-00000


# test inside
# docker exec hadoop mkdir /usr/local/hadoop/examples/ExemploIGTI2
# docker cp /usr/local/posdc/hadoop/ExemploIGTI2/. hadoop:/usr/local/hadoop/examples/ExemploIGTI2
# docker exec hadoop ls -l /usr/local/hadoop/examples/ExemploIGTI2
# docker exec hadoop ant -f /usr/local/hadoop/examples/ExemploIGTI2/build_ExemploIGTI.xml makejar
# docker exec hadoop ./usr/local/hadoop/bin/hadoop jar /usr/local/hadoop-2.7.1/examples/ExemploIGTI2/ExemploIGTI.jar IGTI.ExemploIGTI


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