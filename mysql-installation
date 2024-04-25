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

Inst=$1 # which application has to install user has to give while executing the script
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

dnf list installed | grep -i $Inst &>>$Logfile
if [ $? -eq 0 ]; then
    echo -e "$G $Inst $NC already installed"
    systemctl enable mysqld &>>$Logfile
status $? "Enabling....$Inst"

systemctl start mysqld &>>$Logfile
status $? "Starting....$Inst"

#sudo mysql_secure_installation --set-root-pass ExpenseApp@1 &>>"$Logfile"
#status $? "Securing MySQL installation"
echo -e "$R Please enter db passowrd... $NC"
read -s mysql_root_password
#Below code will be work as idempotent nature
 mysql -h db.sathishreddy.online -uroot -p${mysql_root_password} -e 'SHOW DATABASES;' &>>$Logfile

 if [ $? -ne 0 ]; then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$Logfile
    status $? "Securing MySQL installation"
else 
    echo -e " password already setup...$Y skipping $NC"

fi
    exit 1
else
    echo -e "$R $Inst $NC need to be install"
    dnf install $Inst -y &>>$Logfile
    status $? "$Inst...installing"
fi

