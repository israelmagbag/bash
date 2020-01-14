#!/usr/bin/bash

var_password_pam_dcredit="-1"
var_password_pam_ucredit="-1"
var_password_pam_lcredit="-1"
var_password_pam_ocredit="-1"
var_password_pam_minlen="14"

function replace_or_append {
  local config_file=$1
  local key=$2
  local value=$3
  local cce=$4
  local format=$5

  if [ $# -lt "3" ]
  then
        echo "Usage: replace_or_append 'config_file_location' 'key_to_search' 'new_value'"
        echo
        echo "If symlinks need to be taken into account, add yes/no to the last argument"
        echo "to allow to 'follow_symlinks'."
        echo "Aborting."
        exit 1
  fi

  if test -L $config_file; then
    sed_command="sed -i --follow-symlinks"
  else
    sed_command="sed -i"
  fi

  if ! [ "x$cce" = x ] && [ "$cce" != '@CCENUM@' ]; then
    cce="CCE-${cce}"
  else
    cce="CCE"
  fi

  stripped_key=$(sed "s/[\^=\$,;+]*//g" <<< $key)

  if ! [ "x$format" = x ] ; then
    printf -v formatted_output "$format" "$stripped_key" "$value"
  else
    formatted_output="$stripped_key = $value"
  fi

  if `grep -qi $key $config_file` ; then
    eval $sed_command "s/$key.*/$formatted_output/g" $config_file
  else
    echo -e "\n# Per $cce: Set $formatted_output in $config_file" >> $config_file
    echo -e "$formatted_output" >> $config_file
  fi

}

replace_or_append '/etc/security/pwquality.conf' '^dcredit' $var_password_pam_dcredit 'CCE-27214-6' '%s = %s'
replace_or_append '/etc/security/pwquality.conf' '^ucredit' $var_password_pam_ucredit 'CCE-27200-5' '%s = %s'
replace_or_append '/etc/security/pwquality.conf' '^lcredit' $var_password_pam_lcredit 'CCE-27345-8' '%s = %s'
replace_or_append '/etc/security/pwquality.conf' '^ocredit' $var_password_pam_ocredit 'CCE-27360-7' '%s = %s'
replace_or_append '/etc/security/pwquality.conf' '^minlen' $var_password_pam_minlen 'CCE-27293-0' '%s = %s'