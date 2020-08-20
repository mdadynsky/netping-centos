#/bin/sh
version=1.0
echo -e "\e[32m Vestion : $version \e[0m"

#Docer named parameters
while [ $# -gt 0 ]; do

   if [[ $1 == *"--"* ]]; then
        param="${1/--/}"
        declare $param="$2"
        echo $1 $2
   fi

  shift
done

#Install git
#dnf install git> /dev/null 2>&1

echo "Download: $repo"
rm -Rf ./conf
git clone $repo ./conf/
#> /dev/null 2>&1
echo "Done"

conf="./conf/$conf"

if [ ! -f "$conf" ]
then
	echo "Conf file $conf not found."
	exit;
fi	


if [  -f "$conf" ]
then
  echo "Getting parameters from conf file: $conf."

  while IFS='=' read -r key value
  do
    key=$(echo $key | tr '.' '_')
    eval ${key}=\${value}> /dev/null 2>&1
  done < "$conf"

  echo "ISO1 = " ${ISO1}
  echo "ISO2 = " ${ISO2}
  echo "ISO_ROOT" = ${iso_root}
else
  echo "$conf not found."
fi

echo $ISO_MASK

ISO1=$(curl $ISO_URL | awk '/"'$ISO_MASK'"/{print $0}' | awk -F"<" '{print $2}' | awk -F">" '{print $2}')
URL=$ISO_URL$ISO1

echo "Last ISO version "$URL

echo "Install soft"
dnf install epel-release -y> /dev/null 2>&1
dnf install ntfs-3g -y> /dev/null 2>&1
dnf install wget -y> /dev/null 2>&1
dnf install rsync -y> /dev/null 2>&1
dnf install genisoimage -y> /dev/null 2>&1
echo "Done"
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

echo "Uncompress $ISO1"
cp -aRf /mnt/* $BUILD/
umount /mnt/
echo "Done"


#Copy settings
echo "Copy settinds"
rsync -ah ./conf${iso_root}* iso/
echo "Done"

VOLUME=$(isoinfo -d -i $ISO1 | grep "Volume id" | sed -e 's/Volume id: //')

echo $VOLUME
 
sed -i 's/{{VOLUME}}/'$VOLUME'/' $BUILD/isolinux/isolinux.cfg
echo "Build new ISO : $ISO2"
mkisofs -quiet -J -T -o $ISO2 -b isolinux/isolinux.bin \
-c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table \
-R -m TRANS.TBL -graft-points -V "$VOLUME" \
$BUILD
echo "Done"
echo -e "\e[32m Finish\e[0m"
