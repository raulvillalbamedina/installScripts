#!/bin/bash 
sudo /etc/init.d/tomcat7 stop
PID=`ps aux|grep [YOURWARNAME]| grep -v grep| awk '{print $2}'`
kill -9 $PID
echo " Tomcat stopped . Review the sql scripts and update de database now. Press CRL+C to cancel process. Press [Enter] key to continue"
if [ -n "$1"]
then
  warName="[YOURWARNAME]"
else
 warName="$1"
fi
cd ..
echo " **** Deleting work/Catalina/localhost/$warName ..."
rm -r work/Catalina/localhost/$warName
echo " **** work/Catalina/localhost/$warName deleted"
echo " **** Deleting logs/ ..."
rm -r logs/*
echo " **** logs/ deleted"
echo " **** Deleting temp/ ..."
rm -r temp/*
echo " **** temp/... deleted"
echo " **** Deleting old $warName webApp ... ****"
rm -r webapps/$warName
rm webapps/$warName.war
echo " **** old webApp deleted **** "
cd bin
echo "Cleanup finish!"
echo $(pwd)
mv ../../tmp/[YOURWARNAME]*.war ../webapps/[YOURWARNAME].war
sudo /etc/init.d/tomcat7 start
echo "Tomcat startup success"
cd ../..