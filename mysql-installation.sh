#!/bin/bash

source ./common.sh

check_root

echo "Please enter DB password:"
read  mysql_root_password
echo "$mysql_root_password"

dnf install mysql-server -y &>>$Logfile
echo "1"

systemctl enable mysqld &>>$Logfile
echo "2"

systemctl start mysqld &>>$Logfile
echo "2"

mysql -h db.daws78s.online -uroot -p${mysql_root_password} -e 'show databases;' &>>$Logfile
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$Logfile
else
    echo -e "MySQL Root password is already setup...$Y SKIPPING $N"
fi