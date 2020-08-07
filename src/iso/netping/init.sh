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

#Install soft
rpm -Uvh /netping/zabbix/*.rpm

systemctl start mariadb
systemctl enable mariadb

mysql -e "CREATE DATABASE zabbix character set utf8 collate utf8_bin;"
mysql -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'netping'"
echo "Import zabbix database"
cat /netping/zabbix/netping-zabbix.sql | mysql -uzabbix -pnetping zabbix

mysqladmin --user=root password "npingzbxdb"

cp -r /netping/usr/* /usr/

firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload

systemctl start httpd
systemctl enable httpd

exit 0 
