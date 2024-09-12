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

cp mongo.repo /etc/yum.repos.d &>> $LOGFILE

VALIDATE $? "Copied MongoDB REPO"