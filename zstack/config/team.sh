#!/bin/bash
yum -y install NetworkManager-team
modprobe team
systemctl enable NetworkManager-dispatcher.service
systemctl restart NetworkManager-dispatcher.service
systemctl enable NetworkManager.service
systemctl restart NetworkManager.service
echo -e "\033[31mThis host team include:\033[0m"
nmcli con show | grep team
echo ""
echo "========================================================="
echo "Warning=========This script in only for centos7=========="
echo "This host device include:"
for i in `ip a | grep "BROADCAST," | awk -F":" '{print $2}'`
do
	#cento6 需要 grep HWaddr
	mac=`ip addr show $i | grep ether | awk '{print $2}'`
	echo -e "\033[31mdevice:\033[0m$i \033[31mmac:\033[0m$mac"
done

read -p "Please Input team name (team0):" team
read -p "Please Input the first device:" dev1
read -p "Please Input the second device:" dev2
read -p "Create gateway ???(yes|no):" gw

if [ $gw == yes ];then

read -p "Open prio mode ??? (yes|no): " prim
if [ $prim == yes ];then
	read -p "Please Input the high prio device ($dev1 | $dev2 ): " primary
	test1=`ip a | grep -c $dev1`
	test2=`ip a | grep -c $dev2`
	test3=`ip a | grep -c $primary`
if [ $test1 != 0 -a $test2 != 0 -a $test3 != 0 ];then
	read -p "Please INput the IP address:" ipaddr
	read -p "Please INput the Gateway address:" gateway
	mv /etc/sysconfig/network-scripts/ifcfg-$dev1 /etc/sysconfig/network-scripts/bak.ifcfg-"$dev1"
	mv /etc/sysconfig/network-scripts/ifcfg-$dev2 /etc/sysconfig/network-scripts/bak.ifcfg-"$dev2"
	nmcli con add type team con-name $team ifname $team config '{"runner": {"name":"activebackup"},"link_watch": {"name": "ethtool","delay_up": 5000}}' ip4 $ipaddr/24 gw4 $gateway
	nmcli connection modify $team ipv4.method manual
	nmcli con add type team-slave con-name $team-$dev1 ifname $dev1 master $team
	nmcli con add type team-slave con-name $team-$dev2 ifname $dev2 master $team
	if [ $primary == $dev1 ];then
		echo TEAM_PORT_CONFIG='{"prio":100}' >> /etc/sysconfig/network-scripts/ifcfg-$team-$dev1
		echo TEAM_PORT_CONFIG='{"prio":50}' >> /etc/sysconfig/network-scripts/ifcfg-$team-$dev2
	else
		echo TEAM_PORT_CONFIG='{"prio":100}' >> /etc/sysconfig/network-scripts/ifcfg-$team-$dev2
		echo TEAM_PORT_CONFIG='{"prio":50}' >> /etc/sysconfig/network-scripts/ifcfg-$team-$dev1
	fi
#	systemctl restart network
	sleep 5


else
        echo "Warning device error!!!"

fi

elif [ $prim == no ];then
	test1=`ip a | grep -c $dev1`
	test2=`ip a | grep -c $dev2`
if [ $test1 != 0 -a $test2 != 0 ];then
        read -p "Please INput the IP address:" ipaddr
        read -p "Please INput the Gateway address:" gateway
	mv /etc/sysconfig/network-scripts/ifcfg-$dev1 /etc/sysconfig/network-scripts/bak.ifcfg-"$dev1"
	mv /etc/sysconfig/network-scripts/ifcfg-$dev2 /etc/sysconfig/network-scripts/bak.ifcfg-"$dev2"
	nmcli con add type team con-name $team ifname $team config '{"runner": {"name":"activebackup"},"link_watch": {"name": "ethtool","delay_up": 5000}}' ip4 $ipaddr/24 gw4 $gateway
	nmcli connection modify $team ipv4.method manual
	nmcli con add type team-slave con-name $team-$dev1 ifname $dev1 master $team
	nmcli con add type team-slave con-name $team-$dev2 ifname $dev2 master $team
#	systemctl restart network
	sleep 5
else
        echo "Warning device error!!!"
fi


else
	echo "wrong"
fi

else
read -p "Open prio mode ??? (yes|no): " prim
if [ $prim == yes ];then
	read -p "Please Input the high prio device ($dev1 | $dev2 ): " primary
	test1=`ip a | grep -c $dev1`
	test2=`ip a | grep -c $dev2`
	test3=`ip a | grep -c $primary`
if [ $test1 != 0 -a $test2 != 0 -a $test3 != 0 ];then
	read -p "Please Input the IP address:" ipaddr
	mv /etc/sysconfig/network-scripts/ifcfg-$dev1 /etc/sysconfig/network-scripts/bak.ifcfg-"$dev1"
	mv /etc/sysconfig/network-scripts/ifcfg-$dev2 /etc/sysconfig/network-scripts/bak.ifcfg-"$dev2"
	nmcli con add type team con-name $team ifname $team config '{"runner": {"name":"activebackup"},"link_watch": {"name": "ethtool","delay_up": 5000}}' ip4 $ipaddr/24
	nmcli connection modify $team ipv4.method manual
	nmcli con add type team-slave con-name $team-$dev1 ifname $dev1 master $team
	nmcli con add type team-slave con-name $team-$dev2 ifname $dev2 master $team
	if [ $primary == $dev1 ];then
		echo TEAM_PORT_CONFIG='{"prio":100}' >> /etc/sysconfig/network-scripts/ifcfg-$team-$dev1
		echo TEAM_PORT_CONFIG='{"prio":50}' >> /etc/sysconfig/network-scripts/ifcfg-$team-$dev2
	else
		echo TEAM_PORT_CONFIG='{"prio":100}' >> /etc/sysconfig/network-scripts/ifcfg-$team-$dev2
		echo TEAM_PORT_CONFIG='{"prio":50}' >> /etc/sysconfig/network-scripts/ifcfg-$team-$dev1
	fi
#	systemctl restart network
	sleep 5


echo -e "\033[31mThis script doesn't create gateway!!!\033[0m"
#service network restart
else
        echo "Warning device error!!!"

fi

elif [ $prim == no ];then
	test1=`ip a | grep -c $dev1`
	test2=`ip a | grep -c $dev2`
if [ $test1 != 0 -a $test2 != 0 ];then
	read -p "Please INput the IP address:" ipaddr
	mv /etc/sysconfig/network-scripts/ifcfg-$dev1 /etc/sysconfig/network-scripts/bak.ifcfg-"$dev1"
	mv /etc/sysconfig/network-scripts/ifcfg-$dev2 /etc/sysconfig/network-scripts/bak.ifcfg-"$dev2"
	nmcli con add type team con-name $team ifname $team config '{"runner": {"name":"activebackup"},"link_watch": {"name": "ethtool","delay_up": 5000}}' ip4 $ipaddr/24
	nmcli connection modify $team ipv4.method manual
	nmcli con add type team-slave con-name $team-$dev1 ifname $dev1 master $team
	nmcli con add type team-slave con-name $team-$dev2 ifname $dev2 master $team
##	systemctl restart network
	sleep 5
echo -e "\033[31mThis script doesn't create gateway!!!\033[0m"
#service network restart
else
        echo "Warning device error!!!"
fi


else
	echo "wrong"
fi
fi

#systemctl restart network
sleep 5
teamdctl $team state
#delete team
#nmcli con show
#nmcli con delete team0
#nmcli con delete team0-enp5s0f0
#nmcli con delete team0-enp5s0f1
# mv /etc/sysconfig/network-scripts/bak.ifcfg-enp5s0f0 /etc/sysconfig/network-scripts/ifcfg-enp5s0f0
# mv /etc/sysconfig/network-scripts/bak.ifcfg-enp5s0f1 /etc/sysconfig/network-scripts/ifcfg-enp5s0f1
#systemctl restart network
