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

cp /home/ec2-user/practice/expense.conf /etc/nginx/default.d/expense.conf &>>$Logfile
status $? "coppied backend service"

unzip /tmp/frontend.zip &>>$Logfile
status $? "extracting frontend"

systemctl restart nginx &>>$Logfile
status $? "restarting nginx"
