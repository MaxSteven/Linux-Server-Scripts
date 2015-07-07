#!/bin/bash

PathOrig="${PATH}"
PATH="/sbin:/usr/sbin:/bin:/usr/bin:${PATH}"
export PATH

# define interfaces
dev1=eth0.10
dev2=eth0.11

# define gateways
gate1=`ifconfig $dev1 | awk -F'[ :]' '/inet/{sub(/^ +/, ""); print substr($6, 1, length($6)-1)}'`4
gate2=192.168.10.1

# mail address for error message
mailto=user@example.com

# set to default Internet Connection
if [ `date +"%H"` -ge 22 ] && [ `ip route | awk -F' ' '/default/{print $NF}'` == $dev2 ]; then
  # change default gateway
  ip route del default dev $dev2
  ip route add default via $gate1 dev $dev1
fi

# check if Internet is working

# first ping hosteurope.de
ping -c 1 176.28.38.168 > /dev/null
if [ "$?" == "0" ]; then exit; fi

# maybe hosteurpe.de is down, so lets ping google
ping -c 1 8.8.8.8 > /dev/null
if [ "$?" == "0" ]; then exit; fi

# maybe google is down, so lets ping yahoo
ping -c 1 www.yahoo.de > /dev/null
if [ "$?" == "0" ]; then exit; fi

# check if default gateway is on $dev1 (Kabel Deutschland)
if [ `ip route | awk -F' ' '/default/{print $NF}'` == $dev1 ]; then

        # change default gateway
        ip route del default dev $dev1
        ip route add default via $gate2 dev $dev2

        # send status to email
        echo "Kabel Deutschland is down, change to Telekom `date +'%Y-%m-%d %H:%M'`" | mailx -s "Internet Connnection has change" $mailto
else
        # change default gateway
        ip route del default dev $dev2
        ip route add default via $gate1 dev $dev1

        echo "Telekom is down, change to Kabel Deutschland `date +'%Y-%m-%d %H:%M'`" | mailx -s "Internet Connnection has change" $mailto
fi

#reset PATH to old variable
PATH="${PathOrig}"
export PATH

exit
