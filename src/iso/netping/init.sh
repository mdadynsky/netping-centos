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

exit 0
#MariaDB
tar -C /opt/mariadb -xf /netping/rpm/mariadb/mariadb.tar.gz
ln -s /opt/mariadb/mariadb-10.5.4-linux-x86_64 /opt/mariadb/mysql

groupadd mysql
useradd -g mysql mysql
chown -R mysql:mysql /opt/mariadb/mysql/

cp /netping/rpm/mariadb/my.cnf /etc/my.cnf
mkdir -p /var/lib/mysql

/opt/mariadb/mysql/scripts/mysql_install_db --user=mysql --basedir=/opt/mariadb/mysql

ln -s /opt/mariadb/mysql/support-files/mysql.server /etc/init.d/mysql
update-rc.d mysql defaults

exit 0 
