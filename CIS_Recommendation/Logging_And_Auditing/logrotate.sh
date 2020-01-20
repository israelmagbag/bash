#!/usr/bin/bash
# Author: Israel Magbag
# Date: January 20, 2020

LOGROTATE_CONF_FILE="/etc/logrotate.conf"
CRON_DAILY_LOGROTATE_FILE="/etc/cron.daily/logrotate"

grep -q "^daily$" $LOGROTATE_CONF_FILE|| echo "daily" >> $LOGROTATE_CONF_FILE

sed -i -r "/^(weekly|monthly|yearly)$/d" $LOGROTATE_CONF_FILE

if ! grep -q "^[[:space:]]*/usr/sbin/logrotate[[:alnum:][:blank:][:punct:]]*$LOGROTATE_CONF_FILE$" $CRON_DAILY_LOGROTATE_FILE; then
	echo "#!/bin/sh" > $CRON_DAILY_LOGROTATE_FILE
	echo "/usr/sbin/logrotate $LOGROTATE_CONF_FILE" >> $CRON_DAILY_LOGROTATE_FILE
fi