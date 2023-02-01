source common.sh

print_head "configuring nodejs repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

print_head "Install Nodejs"
yum install nodejs -y &>>${LOG}
status_check

print_head "Adding Application user"
#useradd roboshop &>>${LOG}
status_check

mkdir -p /app
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
rm -rf /app/*

cd /app
unzip /tmp/catalogue.zip
cd /app
npm install

cp ${script_location}/Files/catalogue.service /etc/systemd/system/catalogue.service
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue

cp ${script_location}/Files/mongodb.repo /etc/yum.repos.d/mongodb.repo
yum install mongodb-org-shell -y

mongo --host mongodb-dev.kakarla.store </app/schema/catalogue.js
