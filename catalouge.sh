#!/bin/bash
ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "Sscript started executing $TIMESTAMP" &>> LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ] 
    then 
        echo -e "$2 ...$R Failed ..$N"
    else 
        echo -e "$2 ...$G SUCCESSSSS ..$N"
    fi
}

if [ $ID -ne 0 ]
then echo -e "$R ERROR: NOT A ROOT USER $N"
exit 1 #You can give other than zero, that will stop the programm if the pervious commans is a failure
else echo "You are ROOT"
fi 

dnf module disable nodejs -y

VALIDATE $? "Disabling current NodeJS" &>> $LOGFILE

dnf module enable nodejs:18 -y

VALIDATE $? "Enabling NodeJS 18" &>> $LOGFILE

dnf install nodejs -y

VALIDATE $? "Installing NodeJS 18" &>> $LOGFILE

useradd roboshop

VALIDATE $? "Creating ROBOSHOP user" &>> $LOGFILE

mkdir /app

VALIDATE $? "Creating App dir" &>> $LOGFILE

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip

VALIDATE $? "Downloading CATLOUGE application " &>> $LOGFILE

cd /app 
unzip /tmp/catalogue.zip

VALIDATE $? "UNZIPPING CATLOUGE application " &>> $LOGFILE

npm install 

VALIDATE $? "Installing dependecies " &>> $LOGFILE


cp /home/centos/roboshop-shell/catalouge.service /etc/systemd/system/catalogue.service &>> $LOGFILE

VALIDATE $? "Copying Catalouge service file" &>> $LOGFILE

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "Catalouge daemon reload " &>> $LOGFILE

systemctl enable catalogue &>> $LOGFILE

VALIDATE $? "Enabling CATLOUGE " &>> $LOGFILE

systemctl start catalogue &>> $LOGFILE

VALIDATE $? "STARTING CATALOUGE " &>> $LOGFILE

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

VALIDATE $? "Copying MONDO repo " &>> $LOGFILE

dnf install mongodb-org-shell -y

VALIDATE $? "Installing MONGODB clinet " &>> $LOGFILE

mongo --host mongodb.daws76s.online </app/schema/catalogue.js

VALIDATE $? " Loading catalouge data " &>> $LOGFILE


