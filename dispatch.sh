source common.sh

component=dispatch
schema_load=false

if [ -z "${roboshop_rabbitmq_password}" ]; then
  echo "Variable roboshop_rabbitmq_password is missing"
  exit 1
fi


GOLANG

