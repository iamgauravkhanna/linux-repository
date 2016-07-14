tart tomcat servers

 apps_dir=/usr/local/applications
 tomcat=/var/lib/tomcat7/logs
 app_log=/usr/local/applications/app_log/logs

 sudo service tomcat7 stop
 sleep 20

echo "Removing tomcat logs"
 sudo rm -rf $tomcat/*

echo "Removing application logs"
 sudo rm -rf $app_log/*

echo "Cleaning portal logs"
 sudo rm -rf $apps_dir/employer/cache $apps_dir/employer/logs $apps_dir/employer/repositories $apps_dir/employer/templates
 sudo rm -rf $apps_dir/employee/cache $apps_dir/employee/logs $apps_dir/employee/repositories $apps_dir/employee/templates
 sudo rm -rf $apps_dir/individual/cache $apps_dir/individual/logs $apps_dir/individual/repositories $apps_dir/individual/templates
 sudo rm -rf $apps_dir/broker/cache $apps_dir/broker/logs $apps_dir/broker/repositories $apps_dir/broker/templates

 sleep 30

echo "Restarting server"
 sudo service tomcat7 start
 sleep 20

cd /var/lib/tomcat7/logs
# tail -f $tomcat/catalina.out


