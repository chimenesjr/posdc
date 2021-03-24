
# some updates
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg

git config --global user.name "fulano"
git config --global user.email "fulano_igti@gmail.com"

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

# docker exec hadoop rm -rf /usr/local/hadoop/examples/

# build and execute app
docker exec hadoop ant -f /usr/local/hadoop/examples/ExemploIGTI/build_ExemploIGTI.xml makejar
docker exec hadoop mkdir /usr/local/hadoop/Dados
sleep 30
docker exec hadoop cp /usr/local/hadoop/examples/examples/arquivoBigData.txt /usr/local/hadoop/Dados
docker exec hadoop ./usr/local/hadoop/bin/hadoop jar /usr/local/hadoop-2.7.1/examples/ExemploIGTI/ExemploIGTI.jar IGTI.ExemploIGTI
docker exec hadoop /usr/local/hadoop/bin/hdfs dfs -cat /user/root/Saida/part-00000

