#!/bin/bash
# Author: Israel Magbag
# Date: March 30, 2020

data=("rhnsd" "rpcbind" "cups" "avahi-daemon")
SYSTEMCTL_EXEC='/usr/bin/systemctl'

for item in ${data[*]}

do
    "$SYSTEMCTL_EXEC" stop '$item.service'
    "$SYSTEMCTL_EXEC" disable '$item.service'
    "$SYSTEMCTL_EXEC" list-unit-files | grep -q '^$item.socket\>' && "$SYSTEMCTL_EXEC" disable '$item.socket'
    "$SYSTEMCTL_EXEC" reset-failed '$item.service'
done
