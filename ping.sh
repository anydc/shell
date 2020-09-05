#!/bin/bash

PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin"
export PATH

while getopts "c:i:" opt; do
    case $opt in
        c)
            count=$OPTARG
            ;;
        i)
            ips=$OPTARG
            ;;
        \?)
            ;;
    esac
done

tmp_fifofile="/tmp/ping.fifo"
mkfifo $tmp_fifofile
exec 6<>$tmp_fifofile
rm $tmp_fifofile

for ((i=0;i<20;i++));do
    echo
done >&6

for ip in `echo $ips |awk -F'|' '{  for(i=1;i<=NF;i++) {print $i} }'`
do
read -u 6
{
    rtt=`ping -c $count $ip |grep rtt |awk '{print $4}' |awk -F'/' '{print $2}'`
    rtt=${rtt:-'0'}
    echo  $rtt
}&
echo >&6
done

wait
exec 6>&-
