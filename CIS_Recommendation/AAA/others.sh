#!/usr/bin/bash
# Author: Israel Magbag
# Date: January 20, 2020

var_accounts_user_umask="027"

grep -q umask /etc/bashrc && \
  sed -i "s/umask.*/umask $var_accounts_user_umask/g" /etc/bashrc
if ! [ $? -eq 0 ]; then
    echo "umask $var_accounts_user_umask" >> /etc/bashrc
fi

var_accounts_user_umask="027"

grep -q umask /etc/profile && \
  sed -i "s/umask.*/umask $var_accounts_user_umask/g" /etc/profile
if ! [ $? -eq 0 ]; then
    echo "umask $var_accounts_user_umask" >> /etc/profile
fi

echo > /etc/securetty