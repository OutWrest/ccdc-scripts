#! /bin/bash
#This is a basic script for deploying Splunk Forwarders on Linux machines and values will
#have to be input to match local setup. This requires that you have the forwarder downloaded
#and this script in the same directory.
#####################################################
#set your variables for the script or it wont work!!!
ip=x.x.x.x
port=x
username=x
password=x
#####################################################
#Forwarder retrieving section
cd /opt
echo "downloading the universal forwarder..."
wget -O splunk.tgz http://download.splunk.com/products/universalforwarder/releases/8.1.2/linux/splunkforwarder-8.1.2-545206cc9f70-Linux-x86_64.tgz
echo "uncompressing the univeral forwarder..."
tar -xzvf /opt/splunk.tgz
#####################################################
#Forwarder deployment section

#adding forward server based on IP and port number
echo "adding forward server..."
./splunk add forward-server <$ip>:<$port>
#adding basic monitor, more can be added if necesarry
echo "adding monitor(s)..."
./splunk add monitor /var/log
#restart to apply settings
echo "restarting"
./splunk restart &
#####################################################
#iptables configuration section

#opening ports for forwarder to talk to server
echo "opening ports to commuicate with server..."
-A INPUT -i eth0 -p tcp --dport $port -m state --state NEW,ESTABLISHED -j ACCEPT &
-A OUTPUT -o eth0 -p tcp --sport $port -m state --state NEW,ESTABLISHED -j ACCEPT &
