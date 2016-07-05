#!/bin/bash
MAX=5
PART=/dev/xvda1
USE=`df -h |grep $PART | awk '{ print $5 }' | cut -d'%' -f1`
if [ $USE -gt $MAX ]; then
  echo "Percent used: $USE" 
  echo "Running out of disk space"
fi

#Title : Check Disk Space
#Reference : http://www.tecmint.com/basic-shell-programming-part-ii/