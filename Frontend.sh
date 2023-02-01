source common.sh

print_head "Configuring nginx web server"
yum install nginx -y &>>${LOG}
status_check

print_head "Remove old content"
rm -rf /usr/share/nginx/html/* &>>${LOG}
status_check

print_head "Download Frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
status_check

cd /usr/share/nginx/html &>>${LOG}

print_head "extract Frontend content file"
unzip /tmp/frontend.zip &>>${LOG}
status_check

print_head "copy roboshop nginx config file"
cp ${script_location}/Files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}
status_check

print_head "enable Nginx"
systemctl enable nginx &>>${LOG}
status_check

print_head "restart Nginx"
systemctl restart nginx &>>${LOG}
status_check