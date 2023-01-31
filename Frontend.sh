script_location=$(pwd)
LOG=/tmp/roboshop.log

status_check() {
  if [ $? -eq 0 ]
  then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[32mFAILURE\e[0m"
    echo "Refer log file for more information, LOG - ${LOG}"
    exit
  fi
}

echo -e "\e[35m Install Nginx\e[0m"
yum install nginx -y &>>${LOG}
status_check

echo -e "\e[35m Remove old content\e[0m"
rm -rf /usr/share/nginx/html/* &>>${LOG}
status_check

echo -e "\e[35m Download Frontend content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
status_check

cd /usr/share/nginx/html &>>${LOG}

echo -e "\e[35m extract Frontend content file\e[0m"
unzip /tmp/frontend.zip &>>${LOG}
status_check

echo -e "\e[35m copy roboshop nginx config file\e[0m"
cp ${script_location}/Files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}
status_check

echo -e "\e[35m enable Nginx\e[0m"
systemctl enable nginx &>>${LOG}
status_check

echo -e "\e[35m restart Nginx\e[0m"
systemctl restart nginx &>>${LOG}
status_check