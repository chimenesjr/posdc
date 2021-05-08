
# some updates
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg

git config --global user.name "fulano"
git config --global user.email "fulano_igti@gmail.com"


# SPARK Instalation

# install java
sudo apt install -y default-jre
# install scala
sudo apt-get -y install scala
# install spark
sudo curl -O https://archive.apache.org/dist/spark/spark-3.1.1/spark-3.1.1-bin-hadoop3.2.tgz
sudo mv spark-3.1.1-bin-hadoop3.2.tgz /usr/local/
cd /usr/local
sudo tar xvf spark-3.1.1-bin-hadoop3.2.tgz
sudo mv spark-3.1.1-bin-hadoop3.2 spark
export PATH=$PATH:/usr/local/spark/bin
source ~/.bashrc
echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | sudo tee /etc/apt/sources.list.d/sbt.list
echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | sudo tee /etc/apt/sources.list.d/sbt_old.list
curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo apt-key add
sudo apt-get update
sudo apt-get install sbt

# execute apps
git clone https://github.com/chimenesjr/HadoopDataAnalysis.git
cd HadoopDataAnalysis/spark-igti
sbt clean
sbt package
gsutil cp gs://igti-data-science/PPR-ALL.csv .
/usr/local/spark/bin/spark-submit --master local --class IGTI.MPRApp target/scala-2.10/igti-mprapp_2.10-0.13.5.jar
gsutil cp /usr/local/HadoopDataAnalysis/spark-igti/resultado/part-00000 gs://igti-data-science/