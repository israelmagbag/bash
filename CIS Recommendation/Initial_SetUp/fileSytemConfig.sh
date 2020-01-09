#!/bin/bash
# Author: Israel Magbag
# Date: January 09, 2020

if LC_ALL=C grep -q -m 1 "^install cramfs" /etc/modprobe.d/cramfs.conf ; then
	sed -i 's/^install cramfs.*/install cramfs /bin/true/g' /etc/modprobe.d/cramfs.conf
else
	echo -e "\n# Disable per security requirements" >> /etc/modprobe.d/cramfs.conf
	echo "install cramfs /bin/true" >> /etc/modprobe.d/cramfs.conf
fi

sleep(1)

if LC_ALL=C grep -q -m 1 "^install freevxfs" /etc/modprobe.d/freevxfs.conf ; then
	sed -i 's/^install freevxfs.*/install freevxfs /bin/true/g' /etc/modprobe.d/freevxfs.conf
else
	echo -e "\n# Disable per security requirements" >> /etc/modprobe.d/freevxfs.conf
	echo "install freevxfs /bin/true" >> /etc/modprobe.d/freevxfs.conf
fi

sleep(1)

if LC_ALL=C grep -q -m 1 "^install jffs2" /etc/modprobe.d/jffs2.conf ; then
	sed -i 's/^install jffs2.*/install jffs2 /bin/true/g' /etc/modprobe.d/jffs2.conf
else
	echo -e "\n# Disable per security requirements" >> /etc/modprobe.d/jffs2.conf
	echo "install jffs2 /bin/true" >> /etc/modprobe.d/jffs2.conf
fi

sleep(1)

