source common.sh

print_head "copy mongoDB repo file"
cp ${script_location}/Files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
status_check

print_head "Install MongoDB"
yum install mongodb-org -y &>>${LOG}
status_check

print_head "Update mongoDB Listen Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${LOG}
status_check

print_head "enable mongoDB"
systemctl enable mongod &>>${LOG}
status_check

print_head "start mongoDB"
systemctl start mongod &>>${LOG}
status_check