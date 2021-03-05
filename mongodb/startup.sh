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

# add db user
sudo mongo --eval 'db.createUser({user:"sales", pwd:"12345", roles:[{role: "readWrite", db: "sales"}]})' sales

# allow remote access
sudo gsutil cp gs://igti-data-science/mongod.conf /etc

#add local ip to mongo
replace="$(hostname -I)"
echo "${replace}"
search="{ip}"
echo "${search}"

sudo sed -i "s/${search}/${replace}/g" /etc/mongod.conf 

# restart
sudo systemctl restart mongod;


# install telnet
sudo apt-get install telnet



# use sales
# db.sales.find()
# db.sales.findOne()
# mongo -u sales -p 12345 localhost/sales

