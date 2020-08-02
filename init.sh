#init
URL=http://mirror.corbina.net/pub/Linux/centos/8.2.2004/isos/x86_64/CentOS-8.2.2004-x86_64-minimal.iso

ISO1=CentOS-Official.iso
ISO2=Centos-NetPing.iso

#Install soft
dnf install epel-release -y
dnf install ntfs-3g -y
dnf install wget -y

#Download linux
if [ ! -f "$ISO1" ]; then	
    echo "$ISO1 does not exists. Dowload..."
    wget -O $ISO1 $URL
else
    echo "$ISO1 exist."
fi
