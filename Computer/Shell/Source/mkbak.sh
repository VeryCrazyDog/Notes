#!/bin/bash

# Enable exit on error
set -e
# Enable exit on undefined variables
set -u

# Configuration
dest_root_dir_path=$(realpath ~/"Backup/$(hostname)")

# Constants
readonly backup_suffix='.bak'
readonly original_suffix='.ori'

# Set default options
use_ori_suffix=0
src_path=

# Parse arguments
while [ $# -gt 0 ]; do
	case "$1" in
		-*)
			case "$1" in
				-o) use_ori_suffix=1;;
				--)
					shift
					break
					;;
				*)
					echo >&2 "Unknown option '${1}'"
					exit 1
					;;
			esac
			;;
		*)
			if [ -z "$src_path" ]; then
				src_path="$1"
			fi
		 	;;
	esac
	shift
done

while [ $# -gt 0 ]; do
	case "$1" in
		*)
			if [ -z "$src_path" ]; then
				src_path="$1"
			fi
		 	;;
	esac
	shift
done

# Check arguments
if [ -z "$src_path" ]; then
	echo >&2 "${0}: missing file operand"
	exit 1
fi

# Determinate path
src_path=$(realpath -- "${src_path}")
dest_path="${dest_root_dir_path}${src_path}"
dest_dir_path=$(dirname "${dest_path}")

# Determinate filename suffix
filename_suffix="$backup_suffix"
if [ $use_ori_suffix -eq 1 ]; then
	filename_suffix="${original_suffix}${filename_suffix}"
fi

# Prepare directory
if [ ! -d "$dest_dir_path" ]; then
	echo "Creating directory '${dest_dir_path}'"
	mkdir -p "${dest_dir_path}"
fi

# Perform copy
sudo cp -pv "${src_path}" "${dest_path}.$(date +"%Y%m%d%H%M%S")${filename_suffix}"
