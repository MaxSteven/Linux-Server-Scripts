#!/bin/sh

# environment
DEV1=eth0.10
DEV2=eth0.11
TC=/sbin/tc

### ------------------- Internet Connection 1 ------------------------ ###

# delete old rules
$TC qdisc del dev $DEV1 ingress > /dev/null 2>&1
$TC qdisc del dev $DEV1 root > /dev/null 2>&1
$TC qdisc del dev lo root > /dev/null 2>&1

# default rule
$TC qdisc add dev $DEV1 root handle 1:0 htb default 12 r2q 6

# distribute bandwidth
$TC class add dev $DEV1 parent 1:0 classid 1:1  htb rate 12000kbit ceil 12000kbit
$TC class add dev $DEV1 parent 1:1 classid 1:10 htb rate 500kbit ceil 12000kbit prio 0
$TC class add dev $DEV1 parent 1:1 classid 1:11 htb rate 3500kbit ceil 12000kbit prio 1
$TC class add dev $DEV1 parent 1:1 classid 1:12 htb rate 1000kbit ceil 12000kbit prio 2
$TC class add dev $DEV1 parent 1:1 classid 1:13 htb rate 7000kbit ceil 12000kbit prio 3

# management
$TC filter add dev $DEV1 parent 1:0 prio 0 protocol ip handle 10 fw flowid 1:10
$TC filter add dev $DEV1 parent 1:0 prio 0 protocol ip handle 11 fw flowid 1:11
$TC filter add dev $DEV1 parent 1:0 prio 0 protocol ip handle 13 fw flowid 1:13

$TC qdisc add dev $DEV1 parent 1:10 handle 10: sfq perturb 10
$TC qdisc add dev $DEV1 parent 1:11 handle 11: sfq perturb 10
$TC qdisc add dev $DEV1 parent 1:12 handle 12: sfq perturb 10
$TC qdisc add dev $DEV1 parent 1:13 handle 13: sfq perturb 10


### ------------------- Internet Connection 2 ------------------------ ###

# delete old rules
$TC qdisc del dev $DEV2 ingress > /dev/null 2>&1
$TC qdisc del dev $DEV2 root > /dev/null 2>&1

# default rule
$TC qdisc add dev $DEV2 root handle 1:0 htb default 17 r2q 6

# distribute bandwidth
$TC class add dev $DEV2 parent 1:0 classid 1:1  htb rate 1000kbit ceil 1000kbit
$TC class add dev $DEV2 parent 1:1 classid 1:15 htb rate 10kbit ceil 1000kbit prio 0
$TC class add dev $DEV2 parent 1:1 classid 1:16 htb rate 900kbit ceil 1000kbit prio 1
$TC class add dev $DEV2 parent 1:1 classid 1:17 htb rate 20kbit ceil 1000kbit prio 2
$TC class add dev $DEV2 parent 1:1 classid 1:18 htb rate 70kbit ceil 1000kbit prio 3

# management
$TC filter add dev $DEV2 parent 1:0 prio 0 protocol ip handle 15 fw flowid 1:15
$TC filter add dev $DEV2 parent 1:0 prio 0 protocol ip handle 16 fw flowid 1:16
$TC filter add dev $DEV2 parent 1:0 prio 0 protocol ip handle 18 fw flowid 1:18

$TC qdisc add dev $DEV2 parent 1:15 handle 15: sfq perturb 10
$TC qdisc add dev $DEV2 parent 1:16 handle 16: sfq perturb 10
$TC qdisc add dev $DEV2 parent 1:17 handle 17: sfq perturb 10
$TC qdisc add dev $DEV2 parent 1:18 handle 18: sfq perturb 10
