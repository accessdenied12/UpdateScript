#!/bin/bash
#
# This will sync an already created local repo and find new files
#

rsync -az --progress rsync://mirror.atlantic.net/centos/7.3.1611/updates/x86_64/ /repos/CentOS/7/3
