#!/bin/bash

case "$1" in 
start)
   ;;
stop)
   ;;
restart)
   $0 stop
   $0 start
   ;;
status)
   if [ -e /var/run/hit.pid ]; then
      echo hit.sh is running, pid=`cat /var/run/hit.pid`
   else
      echo hit.sh is NOT running
      exit 1
   fi
   ;;
*)

esac
	
echo "init Ok Centos 8" > /root/ok.txt
exit 0 
