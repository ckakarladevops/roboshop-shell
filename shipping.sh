source common.sh

if [ -z "${root_mysql_password}" ]; then
  echo "variable root_mysql_password is needed"
  exit
fi

component=shipping
schema_load=True
schema_type=mysql
MAVEN