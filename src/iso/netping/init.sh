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

cd /netping/rpm

#MariaDB
rpm -ihv  mariadb-server-10.3.17-1.module_el8.1.0+257+48736ea6.x86_64.rpm mariadb-10.3.17-1.module_el8.1.0+257+48736ea6.x86_64.rpm mariadb-common-10.3.17-1.module_el8.1.0+257+48736ea6.x86_64.rpm mariadb-errmsg-10.3.17-1.module_el8.1.0+257+48736ea6.x86_64.rpm psmisc-23.1-4.el8.x86_64.rpm mariadb-connector-c-3.0.7-1.el8.x86_64.rpm

rpm -ihv  zabbix-apache-conf-5.0.2-1.el8.noarch.rpm zabbix-server-mysql-5.0.2-1.el8.x86_64.rpm zabbix-agent-5.0.2-1.el8.x86_64.rpm zabbix-release-5.0-1.el8.noarch.rpm zabbix-web-mysql-5.0.2-1.el8.noarch.rpm

exit 0 
