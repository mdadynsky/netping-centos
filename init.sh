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

wget -O $BUILD/netping/rpm/tar.rpm http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/tar-1.30-4.el8.x86_64.rpm

VOLUME=$(isoinfo -d -i $ISO1 | grep "Volume id" | sed -e 's/Volume id: //')

echo $VOLUME
 
sed -i 's/{{VOLUME}}/'$VOLUME'/' $BUILD/isolinux/isolinux.cfg

mkisofs -J -T -o $ISO2 -b isolinux/isolinux.bin \
-c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table \
-R -m TRANS.TBL -graft-points -V "$VOLUME" \
$BUILD
