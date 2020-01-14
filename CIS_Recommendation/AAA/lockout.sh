#!/usr/bin/bash

var_accounts_passwords_pam_faillock_unlock_time="never"
var_accounts_passwords_pam_faillock_deny="3"
var_accounts_passwords_pam_faillock_fail_interval="900"

AUTH_FILES[0]="/etc/pam.d/system-auth"
AUTH_FILES[1]="/etc/pam.d/password-auth"

for pamFile in "${AUTH_FILES[@]}"
do
	if grep -q "^auth.*pam_faillock.so.*" $pamFile; then
		if grep -q "^auth.*[default=die].*pam_faillock.so.*authfail.*unlock_time=" $pamFile; then
			sed -i --follow-symlinks "s/\(^auth.*required.*pam_faillock.so.*preauth.*silent.*\)\(unlock_time *= *\).*/\1\2$var_accounts_passwords_pam_faillock_unlock_time/" $pamFile
			sed -i --follow-symlinks "s/\(^auth.*[default=die].*pam_faillock.so.*authfail.*\)\(unlock_time *= *\).*/\1\2$var_accounts_passwords_pam_faillock_unlock_time/" $pamFile
		else
			sed -i --follow-symlinks "/^auth.*required.*pam_faillock.so.*preauth.*silent.*/ s/$/ unlock_time=$var_accounts_passwords_pam_faillock_unlock_time/" $pamFile
			sed -i --follow-symlinks "/^auth.*[default=die].*pam_faillock.so.*authfail.*/ s/$/ unlock_time=$var_accounts_passwords_pam_faillock_unlock_time/" $pamFile
		fi
	else
		sed -i --follow-symlinks "/^auth.*sufficient.*pam_unix.so.*/i auth        required      pam_faillock.so preauth silent unlock_time=$var_accounts_passwords_pam_faillock_unlock_time" $pamFile
		sed -i --follow-symlinks "/^auth.*sufficient.*pam_unix.so.*/a auth        [default=die] pam_faillock.so authfail unlock_time=$var_accounts_passwords_pam_faillock_unlock_time" $pamFile
		sed -i --follow-symlinks "/^account.*required.*pam_unix.so/i account     required      pam_faillock.so" $pamFile
	fi

	if grep -q "^auth.*pam_faillock.so.*" $pamFile; then
		if grep -q "^auth.*[default=die].*pam_faillock.so.*authfail.*deny=" $pamFile; then
			sed -i --follow-symlinks "s/\(^auth.*required.*pam_faillock.so.*preauth.*silent.*\)\(deny *= *\).*/\1\2$var_accounts_passwords_pam_faillock_deny/" $pamFile
			sed -i --follow-symlinks "s/\(^auth.*[default=die].*pam_faillock.so.*authfail.*\)\(deny *= *\).*/\1\2$var_accounts_passwords_pam_faillock_deny/" $pamFile
		else
			sed -i --follow-symlinks "/^auth.*required.*pam_faillock.so.*preauth.*silent.*/ s/$/ deny=$var_accounts_passwords_pam_faillock_deny/" $pamFile
			sed -i --follow-symlinks "/^auth.*[default=die].*pam_faillock.so.*authfail.*/ s/$/ deny=$var_accounts_passwords_pam_faillock_deny/" $pamFile
		fi
	else
		sed -i --follow-symlinks "/^auth.*pam_unix.so.*/i auth        required      pam_faillock.so preauth silent deny=$var_accounts_passwords_pam_faillock_deny" $pamFile
		sed -i --follow-symlinks "/^auth.*pam_deny.so.*/i auth        [default=die] pam_faillock.so authfail deny=$var_accounts_passwords_pam_faillock_deny" $pamFile
	fi
	if ! grep -q "^account.*required.*pam_faillock.so" $pamFile; then
		sed -i --follow-symlinks "/^account.*required.*pam_unix.so/i account     required      pam_faillock.so" $pamFile
	fi

	if grep -q "^auth.*pam_faillock.so.*" $pamFile; then
		if ! grep -q "^auth.*required.*pam_faillock.so.*preauth.*even_deny_root" $pamFile; then
			sed -i --follow-symlinks "s/\(^auth.*required.*pam_faillock.so.*preauth.*\).*/\1 even_deny_root/" $pamFile
		fi
		if ! grep -q "^auth.*\[default=die\].*pam_faillock.so.*authfail.*even_deny_root" $pamFile; then
			sed -i --follow-symlinks "s/\(^auth.*\[default=die\].*pam_faillock.so.*authfail.*silent.*\).*/\1 even_deny_root/" $pamFile
		fi
	else
		sed -i --follow-symlinks "/^auth.*pam_unix.so.*/i auth        required      pam_faillock.so preauth silent even_deny_root" $pamFile
		sed -i --follow-symlinks "/^auth.*pam_deny.so.*/i auth        [default=die] pam_faillock.so authfail silent even_deny_root" $pamFile
	fi

	if grep -q "^auth.*pam_faillock.so.*" $pamFile; then
		if grep -q "^auth.*[default=die].*pam_faillock.so.*authfail.*fail_interval=" $pamFile; then
			sed -i --follow-symlinks "s/\(^auth.*required.*pam_faillock.so.*preauth.*silent.*\)\(fail_interval *= *\).*/\1\2$var_accounts_passwords_pam_faillock_fail_interval/" $pamFile
			sed -i --follow-symlinks "s/\(^auth.*[default=die].*pam_faillock.so.*authfail.*\)\(fail_interval *= *\).*/\1\2$var_accounts_passwords_pam_faillock_fail_interval/" $pamFile
		else
			sed -i --follow-symlinks "/^auth.*required.*pam_faillock.so.*preauth.*silent.*/ s/$/ fail_interval=$var_accounts_passwords_pam_faillock_fail_interval/" $pamFile
			sed -i --follow-symlinks "/^auth.*[default=die].*pam_faillock.so.*authfail.*/ s/$/ fail_interval=$var_accounts_passwords_pam_faillock_fail_interval/" $pamFile
		fi
	else

		sed -i --follow-symlinks "/^auth.*sufficient.*pam_unix.so.*/i auth        required      pam_faillock.so preauth silent fail_interval=$var_accounts_passwords_pam_faillock_fail_interval" $pamFile
		sed -i --follow-symlinks "/^auth.*sufficient.*pam_unix.so.*/a auth        [default=die] pam_faillock.so authfail fail_interval=$var_accounts_passwords_pam_faillock_fail_interval" $pamFile
		sed -i --follow-symlinks "/^account.*required.*pam_unix.so/i account     required      pam_faillock.so" $pamFile
	fi
done