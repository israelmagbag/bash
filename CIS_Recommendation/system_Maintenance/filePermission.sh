#!/bin/bash
# Author: Israel Magbag
# Date: January 14, 2020

list=("/etc/crontab" "/etc/cron.hourly" "/etc/cron.daily" "/etc/cron.weekly" "/etc/cron.monthly" "/etc/cron.d" "/etc/ssh/sshd_config")

chmod 0600 /boot/grub2/grub.cfg

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

chmod 644 /etc/passwd
chmod 000 /etc/shadow
chmod 644 /etc/group
chmod 000 /etc/gshadow
chmod u-x,go-wx /etc/passwd-
chmod 000 /etc/shadow-
chmod u-x,go-wx /etc/group-
chmod 000 /etc/gshadow-