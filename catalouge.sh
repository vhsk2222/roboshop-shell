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
        exit 1
    else 
        echo -e "$2 ...$G SUCCESSSSS ..$N"
    fi
}

if [ $ID -ne 0 ]
then echo -e "$R ERROR: NOT A ROOT USER $N"
exit 1 #You can give other than zero, that will stop the programm if the pervious commans is a failure
else echo "You are ROOT"
fi 

dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "Disabling current NodeJS" 

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "Enabling NodeJS 18" 

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "Installing NodeJS 18" 

id roboshop
if [ $? -ne 0 ]
then 
    useradd roboshop &>> $LOGFILE
    VALIDATE $? "Creating ROBOSHOP user"
else
    echo "roboshop user leardy exist .. SKIPPING.."
fi

mkdir -p /app &>> $LOGFILE

VALIDATE $? "Creating App dir" 

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip

VALIDATE $? "Downloading CATLOUGE application " 

cd /app &>> $LOGFILE
unzip -o /tmp/catalogue.zip &>> $LOGFILE

VALIDATE $? "UNZIPPING CATLOUGE application " 

npm install &>> $LOGFILE

VALIDATE $? "Installing dependecies " 


cp /home/centos/roboshop-shell/catalouge.service /etc/systemd/system/catalogue.service &>> $LOGFILE

VALIDATE $? "Copying Catalouge service file" 

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "Catalouge daemon reload " 

systemctl enable catalogue &>> $LOGFILE

VALIDATE $? "Enabling CATLOUGE " 

systemctl start catalogue &>> $LOGFILE

VALIDATE $? "STARTING CATALOUGE " 

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

VALIDATE $? "Copying MONDO repo " 

dnf install mongodb-org-shell -y

VALIDATE $? "Installing MONGODB clinet " 

mongo --host mongodb.daws76s.online </app/schema/catalogue.js

VALIDATE $? " Loading catalouge data " 


