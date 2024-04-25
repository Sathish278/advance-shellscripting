#!/bin/bash
source ./common.sh

Inst=$1 # which application has to install user has to give while executing the script
#validation or status function

#check root user or not
check_root

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

