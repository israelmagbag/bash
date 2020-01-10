#!/bin/bash
# Author: Israel Magbag
# Date: January 10, 2020

list=( "xinetd" "avahi-daemon" "cups" "dhcpd" "slapd" "nfs" "nfs-server" "rpcbind" "named" "vsftpd" "httpd" "dovecot" "smb" "squid" "snmpd" "ypserv" "rsh.socket" "rlogin.socket" "rexec.socket" "ntalk" "telnet.socket" "tftp.socket" "rsyncd")
data=("ypbind" "rsh" "talk" "telnet" "openldap-clients")
srv=("chargen-dgram" "chargen-stream" "daytime-dgram" "daytime-stream" "discard-dgram" "discard-stream" "echo-dgram" "echo-stream" "time-dgram" "time-stream" "tftp")

for item in ${list[*]}

do
    systemctl disable $item
    sleep(1)
done

for i in ${data[*]}

do
    systemctl disable $i
    sleep(1)
done

for s in ${srv[*]}

do
    chkconfig $s off
    sleep(1)
done