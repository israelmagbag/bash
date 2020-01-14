#!/bin/bash
# Author: Israel Magbag
# Date: January 14, 2020

list=("/etc/crontab" "/etc/cron.hourly" "/etc/cron.daily" "/etc/cron.weekly" "/etc/cron.monthly" "/etc/cron.d" "/etc/ssh/sshd_config")

for item in ${list[*]}
do
    chown root:root $item
    chmod og-rwx $item
done

data=("/etc/passwd" "/etc/shadow" "/etc/group" "/etc/gshadow" "/etc/passwd-" "/etc/shadow-" "/etc/group-" "/etc/gshadow-")

for i in ${data[*]}
do
    chown root:root $i
done

files=("/etc/shadow" "/etc/gshadow" "/etc/shadow-" "/etc/gshadow-")

for f in ${files[*]}
do
   chmod 000 $f 
done

chmod 0600 /boot/grub2/grub.cfg
chmod 644 /etc/passwd
chmod 644 /etc/group
chmod u-x,go-wx /etc/passwd-
chmod u-x,go-wx /etc/group-
