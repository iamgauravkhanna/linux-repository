#!/bin/sh
#
# Start weblogic application

PROJECT_HOME=/home/ubuntu/Oracle/Middleware/user_projects/domains/base_domain

# Kill all processes matching a certain name

case "$1" in
start)
cd ${PROJECT_HOME}/bin

sudo nohup ./startWebLogic.sh >/dev/null 2>/dev/null &
echo "weblogic application started.";
exit 
;;

*)
echo "Usage: $0 { start | stop }"
exit 1
;;
esac

exit 0

