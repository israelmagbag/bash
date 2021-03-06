#!/bin/bash

# Author: Israel Magbag
# Date: December 25, 2019
# Description: Monitor multiple server's status via ICMP

hosts="/workspace/bash/sample/file.txt"

for ip in $(cat $hosts)

do 
    ping -c1 $ip &> /dev/null
    if [ $? -eq 0 ]
    then
    echo $ip "is ACTIVE"
    else
    echo $ip "is NOT ACTIVE"
    fi
done