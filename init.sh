#init
URL=http://mirror.corbina.net/pub/Linux/centos/8.2.2004/isos/x86_64/CentOS-8.2.2004-x86_64-minimal.iso
SRC=CentOS-8.2.2004-x86_64-minimal.iso

#Install soft
dnf install epel-release -y
dnf install ntfs-3g -y
dnf install wget -y

#Download linux
wget -O Centos-Official.iso $URL
