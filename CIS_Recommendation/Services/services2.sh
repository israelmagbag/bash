#!/bin/bash
# Author: Israel Magbag
# Date: March 30, 2020

function package_remove {

local package="$1"

if [ $# -ne "1" ]
then
  echo "Usage: package_remove 'package_name'"
  echo "Aborting."
  exit 1
fi

if which dnf ; then
  if rpm -q --quiet "$package"; then
    dnf remove -y "$package"
  fi
elif which yum ; then
  if rpm -q --quiet "$package"; then
    yum remove -y "$package"
  fi
elif which apt-get ; then
  apt-get remove -y "$package"
else
  echo "Failed to detect available packaging system, tried dnf, yum and apt-get!"
  echo "Aborting."
  exit 1
fi

}

package_remove telnet
package_remove xorg-x11-server-common