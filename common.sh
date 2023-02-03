script_location=$(pwd)
LOG=/tmp/roboshop.log

status_check() {
  if [ $? -eq 0 ]
  then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    echo "Refer log file for more information, LOG - ${LOG}"
    exit 1
  fi
}


print_head() {
  echo -e "\e[1m $1 \e[0m"
}

NODEJS() {
print_head "configuring nodejs repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

print_head "Install Nodejs"
yum install nodejs -y &>>${LOG}
status_check

print_head "Adding Application user"
id roboshop &>>${LOG}
if [ $? -ne 0 ]; then
  useradd roboshop &>>${LOG}
fi
status_check

mkdir -p /app

print_head "Downloading App content"
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${LOG}
status_check

print_head "remove the old content"
rm -rf /app/* &>>${LOG}
status_check

print_head "extracting App content"
cd /app
unzip /tmp/${component}.zip &>>${LOG}
status_check

print_head "Installing nodejs dependencies"
cd /app &>>${LOG}
npm install &>>${LOG}
status_check

print_head "configuring ${component} service file"
cp ${script_location}/Files/${component}.service /etc/systemd/system/${component}.service &>>${LOG}
status_check

print_head "reload systemd"
systemctl daemon-reload &>>${LOG}
status_check

print_head "enable ${component}"
systemctl enable ${component} &>>${LOG}
status_check

print_head "start ${component} service"
systemctl start ${component} &>>${LOG}
status_check

if [ ${schema_load} == "True" ]; then
  print_head "configuring mongo repo"
  cp ${script_location}/Files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}

  print_head "Install mongodb client"
  yum install mongodb-org-shell -y &>>${LOG}
  status_check

  print_head "load schema"
  mongo --host mongodb-dev.kakarla.store </app/schema/${component}.js &>>${LOG}
  status_check
fi

}