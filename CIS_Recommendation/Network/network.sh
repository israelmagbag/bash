#!/usr/bin/bash
# Author: Israel Magbag
# Date: January 20, 2020

/sbin/sysctl -q -n -w net.ipv4.ip_forward=0
/sbin/sysctl -q -n -w net.ipv4.conf.all.send_redirects=0
/sbin/sysctl -q -n -w net.ipv4.conf.default.send_redirects=0
sysctl_net_ipv4_conf_all_accept_redirects_value="0"
/sbin/sysctl -q -n -w net.ipv4.conf.all.accept_redirects=$sysctl_net_ipv4_conf_all_accept_redirects_value
sysctl_net_ipv4_conf_default_accept_redirects_value="0"
/sbin/sysctl -q -n -w net.ipv4.conf.default.accept_redirects=$sysctl_net_ipv4_conf_default_accept_redirects_value
sysctl_net_ipv4_conf_all_secure_redirects_value="0"
/sbin/sysctl -q -n -w net.ipv4.conf.all.secure_redirects=$sysctl_net_ipv4_conf_all_secure_redirects_value
sysctl_net_ipv4_conf_default_secure_redirects_value="0"
/sbin/sysctl -q -n -w net.ipv4.conf.default.secure_redirects=$sysctl_net_ipv4_conf_default_secure_redirects_value
sysctl_net_ipv4_conf_default_log_martians_value="1"
/sbin/sysctl -q -n -w net.ipv4.conf.default.log_martians=$sysctl_net_ipv4_conf_default_log_martians_value
sysctl_net_ipv4_conf_all_log_martians_value="1"
/sbin/sysctl -q -n -w net.ipv4.conf.all.log_martians=$sysctl_net_ipv4_conf_all_log_martians_value
sysctl_net_ipv4_icmp_echo_ignore_broadcasts_value="1"
/sbin/sysctl -q -n -w net.ipv4.icmp_echo_ignore_broadcasts=$sysctl_net_ipv4_icmp_echo_ignore_broadcasts_value
sysctl_net_ipv4_icmp_ignore_bogus_error_responses_value="1"
/sbin/sysctl -q -n -w net.ipv4.icmp_ignore_bogus_error_responses=$sysctl_net_ipv4_icmp_ignore_bogus_error_responses_value
sysctl_net_ipv4_tcp_syncookies_value="1"
/sbin/sysctl -q -n -w net.ipv4.tcp_syncookies=$sysctl_net_ipv4_tcp_syncookies_value
sysctl_net_ipv6_conf_default_accept_ra_value="0"
/sbin/sysctl -q -n -w net.ipv6.conf.default.accept_ra=$sysctl_net_ipv6_conf_default_accept_ra_value
sysctl_net_ipv6_conf_all_accept_ra_value="0"
/sbin/sysctl -q -n -w net.ipv6.conf.all.accept_ra=$sysctl_net_ipv6_conf_all_accept_ra_value
sysctl_net_ipv6_conf_all_accept_redirects_value="0"
/sbin/sysctl -q -n -w net.ipv6.conf.all.accept_redirects=$sysctl_net_ipv6_conf_all_accept_redirects_value
sysctl_net_ipv6_conf_default_accept_redirects_value="0"
/sbin/sysctl -q -n -w net.ipv6.conf.default.accept_redirects=$sysctl_net_ipv6_conf_default_accept_redirects_value
/sbin/sysctl -q -n -w net.ipv6.conf.all.disable_ipv6=1

function replace_or_append {
  local default_format='%s = %s' case_insensitive_mode=yes sed_case_insensitive_option='' grep_case_insensitive_option=''
  local config_file=$1
  local key=$2
  local value=$3
  local cce=$4
  local format=$5

  if [ "$case_insensitive_mode" = yes ]; then
    sed_case_insensitive_option="i"
    grep_case_insensitive_option="-i"
  fi
  [ -n "$format" ] || format="$default_format"
  [ $# -ge "3" ] || { echo "Usage: replace_or_append <config_file_location> <key_to_search> <new_value> [<CCE number or literal '@CCENUM@' if unknown>] [printf-like format, default is '$default_format']" >&2; exit 1; }

  sed_command=('sed' '-i')
  if test -L "$config_file"; then
    sed_command+=('--follow-symlinks')
  fi

  if [ -n "$cce" ] && [ "$cce" != '@CCENUM@' ]; then
    cce="CCE-${cce}"
  else
    cce="CCE"
  fi

  stripped_key=$(sed 's/[\^=\$,;+]*//g' <<< "$key")

  printf -v formatted_output "$format" "$stripped_key" "$value"


  if LC_ALL=C grep -q -m 1 $grep_case_insensitive_option -e "${key}\\>" "$config_file"; then
    "${sed_command[@]}" "s/${key}\\>.*/$formatted_output/g$sed_case_insensitive_option" "$config_file"
  else
    printf '\n# Per %s: Set %s in %s\n' "$cce" "$formatted_output" "$config_file" >> "$config_file"
    printf '%s\n' "$formatted_output" >> "$config_file"
  fi
}

replace_or_append '/etc/sysctl.conf' '^net.ipv4.ip_forward' "0" 'CCE-80157-1'
replace_or_append '/etc/sysctl.conf' '^net.ipv4.conf.all.send_redirects' "0" 'CCE-80156-3'
replace_or_append '/etc/sysctl.conf' '^net.ipv4.conf.default.send_redirects' "0" 'CCE-80999-6'
replace_or_append '/etc/sysctl.conf' '^net.ipv4.conf.all.accept_redirects' "$sysctl_net_ipv4_conf_all_accept_redirects_value" 'CCE-80158-9'
replace_or_append '/etc/sysctl.conf' '^net.ipv4.conf.default.accept_redirects' "$sysctl_net_ipv4_conf_default_accept_redirects_value" 'CCE-80163-9'
replace_or_append '/etc/sysctl.conf' '^net.ipv4.conf.all.secure_redirects' "$sysctl_net_ipv4_conf_all_secure_redirects_value" 'CCE-80159-7'
replace_or_append '/etc/sysctl.conf' '^net.ipv4.conf.default.secure_redirects' "$sysctl_net_ipv4_conf_default_secure_redirects_value" 'CCE-80164-7'
replace_or_append '/etc/sysctl.conf' '^net.ipv4.conf.default.log_martians' "$sysctl_net_ipv4_conf_default_log_martians_value" 'CCE-80161-3'
replace_or_append '/etc/sysctl.conf' '^net.ipv4.conf.all.log_martians' "$sysctl_net_ipv4_conf_all_log_martians_value" 'CCE-80160-5'
replace_or_append '/etc/sysctl.conf' '^net.ipv4.icmp_echo_ignore_broadcasts' "$sysctl_net_ipv4_icmp_echo_ignore_broadcasts_value" 'CCE-80165-4'
replace_or_append '/etc/sysctl.conf' '^net.ipv4.icmp_ignore_bogus_error_responses' "$sysctl_net_ipv4_icmp_ignore_bogus_error_responses_value" 'CCE-80166-2'
replace_or_append '/etc/sysctl.conf' '^net.ipv4.tcp_syncookies' "$sysctl_net_ipv4_tcp_syncookies_value" 'CCE-27495-1'
replace_or_append '/etc/sysctl.conf' '^net.ipv6.conf.default.accept_ra' "$sysctl_net_ipv6_conf_default_accept_ra_value" 'CCE-80181-1'
replace_or_append '/etc/sysctl.conf' '^net.ipv6.conf.all.accept_ra' "$sysctl_net_ipv6_conf_all_accept_ra_value" 'CCE-80180-3'
replace_or_append '/etc/sysctl.conf' '^net.ipv6.conf.all.accept_redirects' "$sysctl_net_ipv6_conf_all_accept_redirects_value" 'CCE-80182-9'
replace_or_append '/etc/sysctl.conf' '^net.ipv6.conf.default.accept_redirects' "$sysctl_net_ipv6_conf_default_accept_redirects_value" 'CCE-80183-7'
replace_or_append '/etc/sysctl.conf' '^net.ipv6.conf.all.disable_ipv6' "1" 'CCE-80175-3'