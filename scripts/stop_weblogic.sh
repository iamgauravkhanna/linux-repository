#!/bin/sh
#
# Stopping all instances of weblogic servers

for i in `ps -ef |grep java | awk '{print $2}'`; do sudo kill -9 $i; done 
