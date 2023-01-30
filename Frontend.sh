script_location=$(pwd)
LOG=/tmp/roboshop.log

echo -e "\e[35m Install Nginx\e[0m"
yum install nginx -y
echo $?

echo -e "\e[35m Remove old content\e[0m"
rm -rf /usr/share/nginx/html/*
echo $?

echo -e "\e[35m Download Frontend content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
echo $?

cd /usr/share/nginx/html

echo -e "\e[35m extract Frontend content file\e[0m"
unzip /tmp/frontend.zip
echo $?

echo -e "\e[35m copy roboshop nginx config file\e[0m"
cp ${script_location}/Files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf
echo $?

echo -e "\e[35m enable Nginx\e[0m"
systemctl enable nginx
echo $?

echo -e "\e[35m restart Nginx\e[0m"
systemctl restart nginx
echo $?