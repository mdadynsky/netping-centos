#init
URL=http://mirror.corbina.net/pub/Linux/centos/8.2.2004/isos/x86_64/CentOS-8.2.2004-x86_64-minimal.iso

ISO1=CentOS-Official.iso
ISO2=CentOS-NetPing.iso

#Install soft
dnf install epel-release -y
dnf install ntfs-3g -y
dnf install wget -y
dnf install rsync -y
dnf install genisoimage -y

#Download linux
if [ ! -f "$ISO1" ]; then	
    echo "$ISO1 does not exists. Dowload..."
    wget -O $ISO1 $URL
else
    echo "$ISO1 exist."
fi

mount -o loop $ISO1 /mnt/

BUILD=iso

rm -rf $BUILD/
mkdir $BUILD/

shopt -s dotglob

cp -avRf /mnt/* $BUILD/
umount /mnt/

#Copy settings
rsync -avh src/iso/* iso/

VOLUME=$(isoinfo -d -i $ISO1 | grep "Volume id" | sed -e 's/Volume id: //')

echo $VOLUME
 
sed -i 's/{{VOLUME}}/'$VOLUME'/' $BUILD/isolinux/isolinux.cfg
