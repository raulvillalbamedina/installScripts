#!/bin/sh
if [[ "${1}" == "help" || "${1}" == "" ]]
 then
  echo "Usage: ./remoteInstall.sh [ENVIRONMENT1],[ENVIRONMENT]...."
  echo "***************"
  echo "****ENVIRONMENTS "
  echo "[YOURENVIRONMENT1]"
  echo "[YOURENVIRONMENT1]"
  exit 1;
fi
ENVIRONMENTS=$1
SERVERS=""
echo "ENVIRONMENTS: $ENVIRONMENTS"
if [[ "${ENVIRONMENTS}" == *"[YOURENVIRONMENT1]"* ]]
 then
  SERVERS=$SERVERS' [YOURENVIRONMENT1].com'
fi
if [[ "${ENVIRONMENTS}" == *"[YOURENVIRONMENT2]"* ]]
 then
  SERVERS=$SERVERS' [YOURENVIRONMENT2].com'
fi
if [ "${SERVERS}" == "" ]
 then
  echo "Need one Environment"
  exit 1;
fi
echo "************************************"
echo "*             [YOURAPPNAME         *"
echo "************************************"
echo "*"
echo "ENVIRONMENTS:$ENVIRONMENTS"
echo "SERVERS:$SERVERS"
echo "------------------------------------"
echo "*"
cd ../../..
echo "Init install in this servers $SERVERS"
for SERVER in $SERVERS
do
  echo "Deploy to server ${SERVER}"
  BASEDIR="/home/[YOURUSERINYOURSERVERS]/"
  hostname
  echo "Copying files to remote server..." 
  scp -i /home/[YOURPUBLICKEYDIRECTORY]/id_rsa resources/remoteCommands.sh [YOURREMOTEDIRECTORY]/[YOURJARNAME]-*.jar echo [YOURUSERINYOURSERVERS]@${SERVER}:${BASEDIR}tmp
  echo "Done copying files to remote server."
  ssh -i /home/[YOURPUBLICKEYDIRECTORY]/id_rsa YOURUSERINYOURSERVERS@${SERVER} '
  cd tmpapi
  echo "Running remoteCommands..."
  sh remoteCommands.sh
  echo "Done running remote commands."
  '

  echo "Checking if app is running, if we get 401 it's ok, we are not authorized..."
  ssh -i /home/[YOURPUBLICKEYDIRECTORY]/id_rsa [YOURUSERINYOURSERVERS]@${SERVER} '
    REQ_STATUS=$(curl -s --head http://localhost:8081 | head -n 1 | grep -c "HTTP/1.1 401")
    if [ $REQ_STATUS -eq 1 ]
    then
     exit 0
    else
     exit 1
    fi
  '
  RESULT=$?
  echo "RESULT: $RESULT"
  if [[ "${RESULT}" == "0" ]]
  then
   echo " Finish ok!"
   exit 0
  else
   echo " Not running, something is wrong..."
   exit 1
  fi
done