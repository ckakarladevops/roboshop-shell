source common.sh

print_head "configuring nodejs repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

print_head "Install Nodejs"
yum install nodejs -y &>>${LOG}
status_check

print_head "Adding Application user"
useradd roboshop &>>${LOG}
status_check

mkdir -p /app

print_head "Downloading App content"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
status_check

print_head "remove the old content"
rm -rf /app/* &>>${LOG}
status_check

print_head "extracting App content"
cd /app
unzip /tmp/catalogue.zip &>>${LOG}
status_check

print_head "Installing nodejs dependencies"
cd /app &>>${LOG}
npm install &>>${LOG}
status_check

print_head "configuring catalogue service file"
cp ${script_location}/Files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}
status_check

print_head "reload systemd"
systemctl daemon-reload &>>${LOG}
status_check

print_head "enable catalogue"
systemctl enable catalogue &>>${LOG}
status_check

print_head "start catalogue service"
systemctl start catalogue &>>${LOG}
status_check

print_head "configuring mongo repo"
cp ${script_location}/Files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}

print_head "Install mongodb client"
yum install mongodb-org-shell -y &>>${LOG}
status_check

print_head "load schema"
mongo --host mongodb-dev.kakarla.store </app/schema/catalogue.js &>>${LOG}
status_check

echo [ $? ]
