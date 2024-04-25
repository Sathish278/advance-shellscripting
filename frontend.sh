#!/bin/bash

source ./common.sh

check_root

dnf install nginx -y  &>>$Logfile
status $? "Installing nginx"

systemctl enable nginx &>>$Logfile
status $? "enabling nginx"

systemctl start nginx &>>$Logfile
status $? "start nginx"

rm -rf /usr/share/nginx/html/* &>>$Logfile
status $? "removing nginx html files"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$Logfile
status $? "downloading frontend"

cd /usr/share/nginx/html &>>$Logfile

cp /home/ec2-user/advance-shellscripting/expense.conf /etc/nginx/default.d/expense.conf &>>$Logfile
status $? "coppied backend service"

unzip /tmp/frontend.zip &>>$Logfile
status $? "extracting frontend"

systemctl restart nginx &>>$Logfile
status $? "restarting nginx"
