source common.sh

if [ -z "${root_mysql_password}" ]; then
  echo "variable root_mysql_password is missing"
  exit
fi

print_head "Disable my sql default module"
dnf module disable mysql -y &>>${LOG}

print_head "copy mysql repo file"
cp ${script_location}/Files/mysql.repo /etc/yum.repos.d/mysql.repo &>>${LOG}
status_check

print_head "Install MySQL Server"
yum install mysql-community-server -y &>>${LOG}
status_check

print_head "Enable MySQL D service"
systemctl enable mysqld &>>${LOG}
status_check

print_head "start MySQL D service"
systemctl start mysqld &>>${LOG}
status_check

print_head "Reset Default Database Password"
mysql_secure_installation --set-root-pass ${root_mysql_password} &>>${LOG}
status_check