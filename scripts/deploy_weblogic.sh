#!/bin/sh
###############################################################################################################
#  deploy_weblogic.sh: Script will be used to restart and deploy public exchange modules on weblogic          #
#  Author - Pardeep Chahal                                                                                    #
###############################################################################################################
	
			weblogic_home=/home/ubuntu/Oracle/Middleware/user_projects/domains/base_domain
			host_name=$1
			apps_dir=$2
			port_number=$3
			deploy_command=com.oracle.weblogic:weblogic-maven-plugin:deploy

			echo " Restart weblogic instance "
			cd $apps_dir
			sh start_weblogic.sh start
			sleep 120
			cd $apps_dir
			mvn $deploy_command -Dadminurl=t3://$host_name:$port_number -Duser=weblogic -Dpassword=Asdf1234 -Dtargets=AdminServer -Dsource=$apps_dir/agent
		if [ $? -ne 0 ];then
			echo " There is some issue in deployment, please check logs manually and take appropriate action \n"
			exit 1
		fi
			mvn $deploy_command -Dadminurl=t3://$host_name:$port_number -Duser=weblogic -Dpassword=Asdf1234 -Dtargets=AdminServer -Dsource=$apps_dir/employer
		if [ $? -ne 0 ];then
			echo " There is some issue in deployment, please check logs manually and take appropriate action \n"
			exit 2
		fi
			mvn $deploy_command -Dadminurl=t3://$host_name:$port_number -Duser=weblogic -Dpassword=Asdf1234 -Dtargets=AdminServer -Dsource=$apps_dir/individual
		if [ $? -ne 0 ];then
			echo " There is some issue in deployment, please check logs manually and take appropriate action \n"
			exit 3
		fi
			echo " Deployment on $1 server is completed successfully "
			exit 0
			
			






