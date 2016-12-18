#!/bin/bash
host="$(hostname)"
new_string="workgroup = SUYATITECH\npassword server = suycokdc01.suyatitech.local SUYCOKDC02\nidmap config * : range = 16777216-33554431\nrealm = SUYATITECH.LOCAL\nsecurity = ads\ntemplate homedir = \/home\/%U0\ntemplate shell = \/bin\/bash\nwinbind use default domain = true\nwinbind offline logon = false"
echo $host
while true;
do
        read -p "Correct hostname? [Y/n] " -n 1 -r

        case $REPLY in
            [yY][eE][sS]|[yY])
                apt-get -y install vim aptitude samba samba-common winbind
                echo "127.0.0.1       localhost
127.0.1.1       $host $host.SUYATITECH.LOCAL
192.168.68.30 suycokdc01.suyatitech.local
192.168.68.31 suycokdc02.suyatitech.local
The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters" > /etc/hosts
echo "# interfaces(5) file used by ifup(8) and ifdown(8)
auto lo
iface lo inet loopback
dns-nameservers 192.168.68.30
dns-nameservers 192.168.68.31" > /etc/network/interfaces
aptitude -y install winbind libpam-winbind libnss-winbind krb5-config
apt-get -y install vim aptitude samba* samba-common winbind
sed -i "s/workgroup = WORKGROUP/$new_string/" /etc/samba/smb.conf
sed -i.bak "s/compat/compat winbind/g" /etc/nsswitch.conf
echo "session optional        pam_mkhomedir.so skel=/etc/skel umask=077" > /etc/pam.d/common-session
service networking restart
net ads join -U itsupport
service winbind restart
wbinfo -u
touch /etc/lightdm/lightdm.conf
echo "[SeatDefaults]
greeter-session=unity-greeter
user-session=ubuntu
greeter-show-manual-login=true
" >> /etc/lightdm/lightdm.conf
clear
echo "successful
Please restart and try login"
exit 0
       ;;
            [nN][oO]|[nN])

                        clear
                        exit 1                  ;;

            *)
                echo "Invalid input..."
                ;;
        esac
done
