#!/bin/bash
# Author: Israel Magbag
# Date: January 10, 2020

function include_mount_options_functions {
	:
}

# $1: type of filesystem
# $2: new mount point option
function ensure_mount_option_for_vfstype {
        local _vfstype="$1" _new_opt="$2" _vfstype_points=()
        _vfstype_points=($(grep -E "[[:space:]]$_vfstype[[:space:]]" /etc/fstab | awk '{print $2}'))

        for _vfstype_point in "${_vfstype_points[@]}"
        do
                ensure_mount_option_in_fstab "$_vfstype_point" "$_new_opt"
        done
}

# $1: mount point
# $2: new mount point option
function ensure_mount_option_in_fstab {
	local _mount_point="$1" _new_opt="$2" _mount_point_match_regexp="" _previous_mount_opts=""
	_mount_point_match_regexp="$(get_mount_point_regexp "$_mount_point")"

	if [ $(grep "$_mount_point_match_regexp" /etc/fstab | grep -c "$_new_opt" ) -eq 0 ]; then
		_previous_mount_opts=$(grep "$_mount_point_match_regexp" /etc/fstab | awk '{print $4}')
		sed -i "s|\(${_mount_point_match_regexp}.*${_previous_mount_opts}\)|\1,${_new_opt}|" /etc/fstab
	fi
}

# $1: mount point
function get_mount_point_regexp {
		printf "[[:space:]]%s[[:space:]]" "$1"
}

# $1: mount point
function assert_mount_point_in_fstab {
	local _mount_point_match_regexp
	_mount_point_match_regexp="$(get_mount_point_regexp "$1")"
	grep "$_mount_point_match_regexp" -q /etc/fstab \
		|| { echo "The mount point '$1' is not even in /etc/fstab, so we can't set up mount options" >&2; return 1; }
}

# $1: mount point
function remove_defaults_from_fstab_if_overriden {
	local _mount_point_match_regexp
	_mount_point_match_regexp="$(get_mount_point_regexp "$1")"
	if $(grep "$_mount_point_match_regexp" /etc/fstab | grep -q "defaults,")
	then
		sed -i "s|\(${_mount_point_match_regexp}.*\)defaults,|\1|" /etc/fstab
	fi
}

# $1: mount point
function ensure_partition_is_mounted {
	local _mount_point="$1"
	mkdir -p "$_mount_point" || return 1
	if mountpoint -q "$_mount_point"; then
		mount -o remount --target "$_mount_point"
	else
		mount --target "$_mount_point"
	fi
}

include_mount_options_functions

function perform_remediation {
	# test "$mount_has_to_exist" = 'yes'
	if test "yes" = 'yes'; then
		assert_mount_point_in_fstab /tmp || { echo "Not remediating, because there is no record of /tmp in /etc/fstab" >&2; return 1; }
	fi

	ensure_mount_option_in_fstab "/tmp" "nodev"

	ensure_partition_is_mounted "/tmp"

    ensure_mount_option_in_fstab "/tmp" "nosuid"

	ensure_partition_is_mounted "/tmp"

    ensure_mount_option_in_fstab "/tmp" "noexec"

	ensure_partition_is_mounted "/tmp"

    ensure_mount_option_in_fstab "/var/tmp" "nodev"

	ensure_partition_is_mounted "/var/tmp"

    ensure_mount_option_in_fstab "/var/tmp" "nosuid"

	ensure_partition_is_mounted "/var/tmp"

    ensure_mount_option_in_fstab "/var/tmp" "noexec"

	ensure_partition_is_mounted "/var/tmp"

    ensure_mount_option_in_fstab "/home" "nodev"

	ensure_partition_is_mounted "/home"

    ensure_mount_option_in_fstab "/dev/shm" "nodev"

	ensure_partition_is_mounted "/dev/shm"

    ensure_mount_option_in_fstab "/dev/shm" "nosuid"

	ensure_partition_is_mounted "/dev/shm"

    ensure_mount_option_in_fstab "/dev/shm" "noexec"

	ensure_partition_is_mounted "/dev/shm"
    
}

perform_remediation