#!/bin/bash
# Author: Israel Magbag
# Date: January 09, 2020

list=("cramfs" "freevxfs" "jffs2" "hfs" "hfsplus" "squashfs" "udf" "vfat")

for item in ${list[*]}

do
    if LC_ALL=C grep -q -m 1 "^install $item" /etc/modprobe.d/$item.conf ; then
	    sed -i 's/^install ' + $item + '.*/install ' + $item + ' /bin/true/g' /etc/modprobe.d/$item.conf
    else
	    echo -e "\n# Disable per security requirements" >> /etc/modprobe.d/$item.conf
	    echo "install $item /bin/true" >> /etc/modprobe.d/$item.conf
    fi
    sleep(1)
done