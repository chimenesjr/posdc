sudo apt-get -y update; 
sudo apt-get -y dist-upgrade;    
sudo apt-get -y install nginx;

# mongo db
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -;
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list;
sudo apt-get update;
sudo apt-get install -y mongodb-org;
sudo systemctl restart mongod;

# download csv file
gsutil cp gs://igti-data-science/PPR-ALL.csv .

#import
mongoimport --type csv -d sales -c sales --headerline --drop PPR-ALL.csv


# use sales
# db.sales.find()

