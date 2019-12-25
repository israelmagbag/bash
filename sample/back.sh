#!/bin/bash
# Author: Israel Magbag
# Date: December 25, 2019
# Description: Backup /etc and /var filesystem

tar cvf /tmp/backup.tar /etc /var

gzip /tmp/backup.tar

find backup.tar.gz -mtime -1 -type f -print &> /dev/null

if [ $? -eq 0 ]
    then
    echo "Backup was created"
    echo
    echo "Archiving Backup"
    scp /tmp/backup.tar.gz root@192.168.1.1:/path
    else
    echo "Backup failed"
fi