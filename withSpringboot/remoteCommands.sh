#!/bin/bash 
echo "Trying to stop old instance.."
PID=`ps aux|grep [YOURJARNAME]| grep -v grep| awk '{print $2}'`
if [ -n "${PID}" ]
then
 kill -9 $PID
 echo "Old instance stopped."
else
 echo "No instance found."
fi

echo "Deleting old files..."
rm -r ../[YOURREMOTEDIRECTORY]/*
echo "Old files deleted."
echo "Copying jar.."
mv [YOURJARNAME]*.jar ../[YOURREMOTEDIRECTORY]
echo "Jar copyied."
echo "Running jar..."
cd ../[YOURREMOTEDIRECTORY]
nohup java -jar -Dspring.profiles.active=[YOURENVIRONMENTPROFILE] [YOURJARNAME]-*.jar > /dev/null 2>&1 &
sleep 60s
echo "Done running jar."