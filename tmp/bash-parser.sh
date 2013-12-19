#!/bin/bash
## A sample shell script to demo concept of shell parameter expansion
## Usage: backup.bash /path/to/backup.tar.gz
## Author: nixCraft <www.cyberciti.biz> under GPL v2.x+
## -------------------------------------------------------------------

## Get our script name ##
_me="${0##*/}"

## get filename from cmd arg $1
_backuppath="$1"

## Failsafe
[[ $# -ne 1 ]] && { echo -en "Usage:\t$_me /path/to/file.tar\n\t$_me /path/to/file.tgz\n"; exit 1; }

## Get dirname
_dirname="${_backuppath%/*}"

# Get filename
_filename="${_backuppath##*/}"

# Get file extension
_extesion="${_filename##*.}"

## Okay log data to syslog
logger "$_me backup job started at $(date)@${HOSTNAME}"

echo ${_dirname}
echo ${_filename}
echo ${_extesion}

logger "$_me backup job ended at $(date)@${HOSTNAME}"
