#!/bin/bash

USERID=$(id -u) # to find the user id / -u for user

#Timestamp
Timestamp=$(date +%F-%H-%M-%S)
FileName=$(echo $0 | cut -d "." -f1)
Logfile=/tmp/$FileName-$Timestamp.log
#colour
R='\e[0;31m'
G='\e[0;32m'
Y='\e[0;33m'
Bl='\e[0;34m'
NC='\e[0m'

#validation or status function
status() {
    if [ $1 -ne 0 ]; then
        echo -e "$bl $2 $NC installation.... $R failed $NC"
        exit 1
    else
        echo -e " $bl $2 $NC installation..... $G sucessed $NC"
    fi

}

#check root user or not
if [ $USERID -ne 0 ]; then
    echo -e "$R Please run with sudo user $NC"
    exit 1 #manually exiting from the script
else
    echo -e "$G You are the super user $NC ...continuing to remaining steps"
fi

dnf module disable nodejs -y &>>$Logfile
status $? "Disbaled nodejs"

dnf module enable nodejs:20 -y &>>$Logfile
status $? "enable nodejs-20"

dnf install nodejs -y &>>$Logfile
status $? "installing nodejs-20"

id expense &>>$Logfile
if [ $? -ne 0 ]; then
    useradd expense &>>$Logfile
    status $? "creating expense user"
else
    echo -e "Expense user already created.... $Y skipping $NC"
fi

mkdir -p /app &>>$Logfile
status $? "creating app ditrectory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$Logfile
status $? "Downloading backend code"

cd /app &>>$Logfile
rm -rf /app/*

unzip /tmp/backend.zip &>>$Logfile
status $? "Excracted backend code"

npm install &>>$Logfile
status $? "Installing nodejs dependencies"

cp /home/ec2-user/practice/backend.service /etc/systemd/system/backend.service &>>$Logfile
status $? "coppied backend service"

systemctl daemon-reload &>>$Logfile
status $? "Daemon Reload"

systemctl start backend &>>$Logfile
status $? "Start backend"

systemctl enable backend &>>$Logfile
status $? "Enable backend service"

dnf install mysql -y &>>$Logfile
status $? "Installing mysql-client"

echo -e "$R Please enter db passowrd... $NC"
read -s mysql_root_password

mysql -h db.sathishreddy.online -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$Logfile
status $? "Schema loading"

systemctl restart backend&>>$Logfile
status $? "Restarting backend"

