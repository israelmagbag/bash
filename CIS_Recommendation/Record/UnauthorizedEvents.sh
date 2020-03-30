#!/bin/bash
# Author: Israel Magbag
# Date: March 30, 2020

data=("truncate" "creat" "open" "open_by_handle_at" "ftruncate" "openat")

[ "$(getconf LONG_BIT)" = "32" ] && RULE_ARCHS=("b32") || RULE_ARCHS=("b32" "b64")

for item in ${data[*]}
do

    for ARCH in "${RULE_ARCHS[@]}"
    do
	    PATTERN="-a always,exit -F arch=$ARCH -S $item -F exit=-EACCES.*"
	    GROUP="access"
	    FULL_RULE="-a always,exit -F arch=$ARCH -S $item -F exit=-EACCES -F auid>=1000 -F auid!=unset -F key=access"

    function fix_audit_syscall_rule {

    local tool="$1"
    local pattern="$2"
    local group="$3"
    local arch="$4"
    local full_rule="$5"

    if [ $# -ne "5" ]
    then
	    echo "Usage: fix_audit_syscall_rule 'tool' 'pattern' 'group' 'arch' 'full rule'"
	    echo "Aborting."
	    exit 1
    fi

    declare -a files_to_inspect

    retval=0

    if [ "$tool" != 'auditctl' ] && [ "$tool" != 'augenrules' ]
    then
	    echo "Unknown audit rules loading tool: $1. Aborting."
	    echo "Use either 'auditctl' or 'augenrules'!"
	    return 1
    elif [ "$tool" == 'auditctl' ]
    then
	    files_to_inspect=("${files_to_inspect[@]}" '/etc/audit/audit.rules' )
    elif [ "$tool" == 'augenrules' ]
    then
	    key=$(expr "$full_rule" : '.*-k[[:space:]]\([^[:space:]]\+\)' '|' "$full_rule" : '.*-F[[:space:]]key=\([^[:space:]]\+\)')
	    IFS_BKP="$IFS"
	    IFS=$'\n'
	    matches=($(sed -s -n -e "\;${pattern};!d" -e "/${arch}/!d" -e "/${group}/!d;F" /etc/audit/rules.d/*.rules))
	    if [ $? -ne 0 ]
	    then
		    retval=1
	    fi
	    IFS="$IFS_BKP"
	    for match in "${matches[@]}"
	    do
		    files_to_inspect=("${files_to_inspect[@]}" "${match}")
	    done
	    if [ ${#files_to_inspect[@]} -eq "0" ]
	    then
		    files_to_inspect="/etc/audit/rules.d/$key.rules"
		    if [ ! -e "$files_to_inspect" ]
		    then
			    touch "$files_to_inspect"
			    chmod 0640 "$files_to_inspect"
		    fi
	    fi
    fi

    local append_expected_rule=0

    for audit_file in "${files_to_inspect[@]}"
    do

	    IFS_BKP="$IFS"
	    IFS=$'\n'
	    existing_rules=($(sed -e "\;${pattern};!d" -e "/${arch}/!d" -e "/${group}/!d"  "$audit_file"))
	    if [ $? -ne 0 ]
	    then
		    retval=1
	    fi
	    IFS="$IFS_BKP"

	    for rule in "${existing_rules[@]}"
	    do
		    if [ "${rule}" != "${full_rule}" ]
		    then
			    rule_syscalls=$(echo $rule | grep -o -P '(-S \w+ )+')
			    if grep -q -- "$rule_syscalls" <<< "$full_rule"
			    then
				    sed -i -e "\;${rule};d" "$audit_file"
				    if [ $? -ne 0 ]
				    then
					    retval=1
				    fi
				    existing_rules=("${existing_rules[@]//$rule/}")
			    else
				    sed -i -e "\;${rule};d" "$audit_file"
				    if [ $? -ne 0 ]
				    then
					    retval=1
				    fi
				    IFS_BKP="$IFS"
				    IFS=$'-S'
				    read -a rule_syscalls_as_array <<< "$rule_syscalls"
				    IFS="$IFS_BKP"
				    new_syscalls_for_rule=''
				    for syscall_arg in "${rule_syscalls_as_array[@]}"
				    do
					    if [ "$syscall_arg" == '' ]
					    then
						    continue
					    fi
					    if grep -q -v -- "$group" <<< "$syscall_arg"
					    then
						    new_syscalls_for_rule="$new_syscalls_for_rule -S $syscall_arg"
					    fi
				    done
				    updated_rule=${rule//$rule_syscalls/$new_syscalls_for_rule}
				    updated_rule=$(echo "$updated_rule" | tr -s '[:space:]')
				    if ! grep -q -- "$updated_rule" "$audit_file"
				    then
					    echo "$updated_rule" >> "$audit_file"
				    fi
			    fi
		    else
			    append_expected_rule=1
		    fi
	    done

	    if [[ ${append_expected_rule} -eq "0" ]]
	    then
		    echo "$full_rule" >> "$audit_file"
	    fi
    done

    return $retval

    }

	    fix_audit_syscall_rule "auditctl" "$PATTERN" "$GROUP" "$ARCH" "$FULL_RULE"
	    fix_audit_syscall_rule "augenrules" "$PATTERN" "$GROUP" "$ARCH" "$FULL_RULE"
    done
done