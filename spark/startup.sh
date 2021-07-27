
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
gsutil cp gs://igti-data-science/spark-3.1.1-bin-hadoop3.2.tgz .
sudo mv spark-3.1.1-bin-hadoop3.2.tgz /usr/local/
cd /usr/local
sudo tar xvf spark-3.1.1-bin-hadoop3.2.tgz
sudo mv spark-3.1.1-bin-hadoop3.2 spark
echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | sudo tee /etc/apt/sources.list.d/sbt.list
echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | sudo tee /etc/apt/sources.list.d/sbt_old.list
curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo apt-key add
sudo apt-get update
sudo apt-get install sbt

# execute apps
git clone -b main https://github.com/chimenesjr/HadoopDataAnalysis.git
cd HadoopDataAnalysis/Spark
gsutil cp gs://igti-data-science/PPR-ALL.csv /usr/local

# # # # # scala
# sbt clean
# sbt package
# /usr/local/spark/bin/spark-submit --master local --class ReportJobs.ReportJobs target/scala-2.10/report-jobs_2.10-0.0.1.jar

# execute python
cd ..
/usr/local/spark/bin/spark-submit --master local Python/main.py
gsutil cp /usr/local/jobmedia/part-00000 gs://igti-data-science/result/JobMedia.csv
gsutil cp /usr/local/final/part-00000 gs://igti-data-science/result/JobMediaFinal.csv


# clean
# rm /usr/local/jobmedia/part-00000
# rm -r /usr/local/jobmedia
# rm /usr/local/final/part-00000
# rm -r /usr/local/final

