#!/bin/bash

# Global variables
interface1=eth0.10
interface2=eth0.11
interface3=eth0.12
interface4=eth0.13
interface5=eth1

line1=$( cat /proc/net/dev | grep $interface1 | cut -d ':' -f 2 | awk '{print "do_B1="$1, "up_B1="$9}' )
line2=$( cat /proc/net/dev | grep $interface2 | cut -d ':' -f 2 | awk '{print "do_B2="$1, "up_B2="$9}' )
line3=$( cat /proc/net/dev | grep $interface3 | cut -d ':' -f 2 | awk '{print "do_B3="$1, "up_B3="$9}' )
line4=$( cat /proc/net/dev | grep $interface4 | cut -d ':' -f 2 | awk '{print "do_B4="$1, "up_B4="$9}' )
line5=$( cat /proc/net/dev | grep $interface5 | cut -d ':' -f 2 | awk '{print "do_B5="$1, "up_B5="$9}' )

eval $line1 $line2 $line3 $line4 $line5

old_do1=$do_B1
old_up1=$up_B1
old_do2=$do_B2
old_up2=$up_B2
old_do3=$do_B3
old_up3=$up_B3
old_do4=$do_B4
old_up4=$up_B4
old_do5=$do_B5
old_up5=$up_B5

sleep 1
line1=$( cat /proc/net/dev | grep $interface1 | cut -d ':' -f 2 | awk '{print "do_B1="$1, "up_B1="$9}' )
line2=$( cat /proc/net/dev | grep $interface2 | cut -d ':' -f 2 | awk '{print "do_B2="$1, "up_B2="$9}' )
line3=$( cat /proc/net/dev | grep $interface3 | cut -d ':' -f 2 | awk '{print "do_B3="$1, "up_B3="$9}' )
line4=$( cat /proc/net/dev | grep $interface4 | cut -d ':' -f 2 | awk '{print "do_B4="$1, "up_B4="$9}' )
line5=$( cat /proc/net/dev | grep $interface5 | cut -d ':' -f 2 | awk '{print "do_B5="$1, "up_B5="$9}' )

eval $line1 $line2 $line3 $line4 $line5

let do1=($do_B1-$old_do1)/1000*8
let up1=($up_B1-$old_up1)/1000*8
let do2=($do_B2-$old_do2)/1000*8
let up2=($up_B2-$old_up2)/1000*8
let do3=($do_B3-$old_do3)/1000*8
let up3=($up_B3-$old_up3)/1000*8
let do4=($do_B4-$old_do4)/1000*8
let up4=($up_B4-$old_up4)/1000*8
let do5=($do_B5-$old_do5)/1000*8
let up5=($up_B5-$old_up5)/1000*8

printf "%s \t | DOWN: %s \t | UP: %s \n" "$interface1 (wan)" "${do1}kbit/s" "${up1}kbit/s"
printf "%s \t | DOWN: %s \t | UP: %s \n" "$interface2 (wan)" "${do2}kbit/s" "${up2}kbit/s"
printf "%s \t | DOWN: %s \t | UP: %s \n" "$interface3 (wlan)" "${up3}kbit/s" "${do3}kbit/s"
printf "%s \t | DOWN: %s \t | UP: %s \n" "$interface4 (tv)" "${up4}kbit/s" "${do4}kbit/s"
printf "%s    \t | DOWN: %s \t | UP: %s \n" "$interface5 (lan)" "${up5}kbit/s" "${do5}kbit/s"
