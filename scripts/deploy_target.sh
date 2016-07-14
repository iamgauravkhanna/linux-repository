#!/bin/sh
###############################################################################################################
##  deploy_pbex.sh: Script will be used to deploy public exchange modules on weblogic and tomcat servers      #
##                                                                                   #
###############################################################################################################


		if [ $# -lt 2 ];then
					echo " \n wrong number of arguments passed, please pass correct arguments, For example: \n"
					echo " Select one of below formats to execute this script: \n"
					echo " sh deploy_target.sh server_name hostname \n"
					echo " Select below format to deploy on weblogic and host xyz \n"
					echo " sh deploy_target.sh weblogic xyz \n"
					exit 1
		fi
					server_name=$1
                    host_name=$2
					apps_dir=$3
					port_number=$4
					dbname=$5
                    home_dir=/mnt
                    upload_dir=$home_dir/upload/$server_name
                    upload_current_dir=$upload_dir/current
					weblogic_dir=$home_dir/Oracle/Middleware/user_projects/domains/base_domain
					logs_dir=/home/ubuntu/logs
					artifact_dir=$upload_dir/temp
					tomcat_home=/usr/local/tomcat
                    #apps_dir=/usr/local/applications
					
                    logname=deployment_$server_name_`date '+%d-%m-%Y'`.log
                    code_base=`ls -ltr $upload_current_dir | awk '{print $8}' | cut -d '_' -f3`
                    revision_number=`ls -ltr $upload_current_dir | awk '{print $8}' | cut -d '_' -f4 | cut -d '.' -f1`
					undeploy_command=com.oracle.weblogic:weblogic-maven-plugin:undeploy



restart ()

{


        if [ "$server_name" = "tomcat" ];then
					echo " Starting tomcat server"
                    sudo /etc/init.d/tomcat start
                if [ $? -ne 0 ];then
					echo " There are some issues in server restart, please check logs for more details \n"
                else
					sleep 120
                    echo " Server started successfully \n"

					echo " Please execute Batch Jobs manually \n"
				testdeployment

                fi
		elif [ "$server_name" = "weblogic" ];then
			
					echo " Server is starting  \n"
					exit 4
		
       
		fi


}


testdeployment ()
{

					flag=`cat $tomcat_home/logs/catalina.out |grep SEVERE | grep employer`
					flag=`echo $?`
		if [ $flag = 0 ];then
					echo " deployment of employer failed \n, please check logs manually and take appropriate action \n"
					exit 5
		else
					echo " deployment of employer was successful \n"
		fi
						flag=`cat $tomcat_home/logs/catalina.out |grep SEVERE | grep individual`
						flag=`echo $?`
		if [ $flag = 0 ];then
					echo " deployment of individual failed \n, please check logs manually and take appropriate action \n"
					exit 6
		else
					echo " deployment of individual was successful \n"
		fi
						flag=`cat $tomcat_home/logs/catalina.out |grep SEVERE | grep agent`
						flag=`echo $?`
		if [ $flag = 0 ];then
					echo " deployment of agent failed \n, please check logs manually and take appropriate action \n"
					exit 7
		else
					echo " deployment of agent was successful \n"
		fi

}


dbcreation ()
{

		if [ "$server_name" = "tomcat" ];then
					echo " DB $dbname creation for tomcat server - $host_name, code_base - $code_base is in progress  \n"
					cd $apps_dir
					cp $upload_current_dir/*.tar.gz .
					tar -xzf *.tar.gz
		if [ $? -ne 0 ];then
                    echo " There are some problems in tar extraction, please check logs for more details \n"
                    exit 1
        fi
					cd $apps_dir/mysql
					#mysql -u root -phc2nt1v2 -e "tee db_log.txt;drop database if exists $dbname;create database $dbname;use $dbname;set autocommit=0;source createpublicdb.sql;"
        if [ $? -ne 0 ];then
                    echo " There are some problems in DB creation, please check logs for more details \n"
                    exit 1
        fi
					deploy
		elif [ "$server_name" = "weblogic" ];then
					cd $apps_dir
					cp $upload_current_dir/*.tar.gz .
					tar -xzf *.tar.gz
			if [ $? -ne 0 ];then
                    echo " There are some problems in tar extraction, please check logs for more details \n"
                    exit 1
			fi
					mv agent-hix-portal* agent
			if [ $? -ne 0 ];then
                    echo " There are some problems in agent-hix-portal deployment, please check logs for more details \n"
                    exit 1
			fi
					mv individual-webapp-public* individual
			if [ $? -ne 0 ];then
                    echo " There are some problems in individual-hix-portal deployment, please check logs for more details \n"
                    exit 2
			fi
					mv employer-public* employer
			if [ $? -ne 0 ];then
                    echo " There are some problems in employer-hix-portal deployment, please check logs for more details \n"
                    exit 3
			fi
					sudo chmod -R 777 *
					echo " DB $dbname creation for weblogic server - $host_name, code_base - $code_base is in progress  \n"
		
		fi


}

deploy ()
{


    if [ "$server_name" = "tomcat" ];then
                    echo " ###########  Deployment begins for tomcat server - $host_name, code_base - $code_base and revision - $revision_number  ########### \n "
                    cd $apps_dir
                    mv agent-hix-portal* agent
		if [ $? -ne 0 ];then
                    echo " There are some problems in agent-hix-portal deployment, please check logs for more details \n"
                    exit 1
        fi
                    mv individual-webapp-public* individual
		if [ $? -ne 0 ];then
                    echo " There are some problems in individual-hix-portal deployment, please check logs for more details \n"
                    exit 2
        fi
                    mv employer-public* employer
		if [ $? -ne 0 ];then
                    echo " There are some problems in employer-hix-portal deployment, please check logs for more details \n"
                    exit 3
        fi
                    sudo chmod -R 777 *
		    restart         
                    
        fi
}

undeploy ()
{
					echo " Undeploying existing application \n\n"
    if [ "$server_name" = "tomcat" ];then
					echo " ###########  Undeploying application from tomcat ###########   \n"
                    echo "###########   Stopping all instances of $host_name ###########  \n"
                    for i in `ps -ef |grep java | awk '{print $2}'`; do sudo kill -9 $i; done
					cd $tomcat_home
				if [ $? -ne 0 ];then
                    echo " Directory doesn't exist, please check manually and execute script again \n"
                    exit 8
                else
					cd $tomcat_home/logs 
					sudo rm -rf *
					cd $tomcat_home
					sudo rm -rf work
				fi
					
                    cd $apps_dir
				if [ ! -d $apps_dir/individual ];then
					echo " dir doesn't exist"
				else
					sudo rm -rf individual
				fi
				if [ ! -d $apps_dir/employer ];then
					echo " dir doesn't exist"
				else
					sudo rm -rf employer
				fi
				if [ ! -d $apps_dir/agent ];then
					echo " dir doesn't exist"
				else
					sudo rm -rf agent
				fi
				if [ ! -d $apps_dir/config ];then
					echo " dir doesn't exist"
				else
					sudo rm -rf config
				fi
				if [ ! -d $apps_dir/mysql ];then
					echo " dir doesn't exist"
				else
					sudo rm -rf mysql
				fi
				if [ ! -d $apps_dir/shop-jobs ];then
					echo " dir doesn't exist"
				else
					sudo rm -rf shop-jobs
				fi
				if [ ! -d $apps_dir/individual-hix-jobs ];then
					echo " dir doesn't exist"
				else
					sudo rm -rf individual-hix-jobs
				fi
				if [ ! -f *.tar.gz ];then
					echo " tar files exist "
				else
					sudo rm *.tar.gz
				fi
                    dbcreation
        elif [ "$server_name" = "weblogic" ];then
                    echo " Undeploying Existing application ...\n "
					cd $apps_dir
					mvn $undeploy_command -Dadminurl=t3://$host_name:$port_number -Duser=weblogic -Dpassword=Asdf1234 -Dtargets=AdminServer -Dname=agent
			
					mvn $undeploy_command -Dadminurl=t3://$host_name:$port_number -Duser=weblogic -Dpassword=Asdf1234 -Dtargets=AdminServer -Dname=employer
			
					mvn $undeploy_command -Dadminurl=t3://$host_name:$port_number -Duser=weblogic -Dpassword=Asdf1234 -Dtargets=AdminServer -Dname=individual
					
				
				echo "###########   Stopping all instances of $host_name ###########  \n"
					for i in `ps -ef |grep java | awk '{print $2}'`; do sudo kill -9 $i; done 

    cd $apps_dir
				if [ ! -d $apps_dir/individual ];then
					echo " dir doesn't exist"
				else
					sudo rm -rf individual
				fi
				if [ ! -d $apps_dir/employer ];then
					echo " dir doesn't exist"
				else
					sudo rm -rf employer
				fi
				if [ ! -d $apps_dir/agent ];then
					echo " dir doesn't exist"
				else
					sudo rm -rf agent
				fi
				if [ ! -d $apps_dir/config ];then
					echo " dir doesn't exist"
				else
					sudo rm -rf config
				fi
				if [ ! -d $apps_dir/oracle ];then
					echo " dir doesn't exist"
				else
					sudo rm -rf oracle
				fi
				if [ ! -d $apps_dir/shop-jobs ];then
					echo " dir doesn't exist"
				else
					sudo rm -rf shop-jobs
				fi
				if [ ! -d $apps_dir/individual-hix-jobs ];then
					echo " dir doesn't exist"
				else
					sudo rm -rf individual-hix-jobs
				fi
				if [ ! -f *.tar.gz ];then
					echo " tar files exist "
				else
					sudo rm *.tar.gz
				fi
	                dbcreation
  fi
}
backup ()
{

	
					echo " Taking backup of existing artifacts on $host_name\n"
        if [ ! -d $upload_dir ];then
					echo " Directory does not exist, please create required directory structure on this server and try again !!! \n"
					exit 4
        else
					cd $upload_dir/backup
                    cp $upload_dir/current/*.tar.gz $upload_dir/backup
                    cd $upload_dir/current
                    rm $upload_dir/current/*.tar.gz
                    mv $upload_dir/temp/* $upload_dir/current
				if [ $? -ne 0 ];then
                    echo " copy of tar in current failed, please check manually and execute script again \n"
                    exit 1
				fi
                    echo " Calling undeploy function "
					undeploy
        fi
}

validation ()
{

					echo " Checking whether staging directory does exist \n"
				if [ ! -d $apps_dir ];then
					echo " Staging directory doesn't exist, creating staging directory first \n"
					sudo mkdir -p $apps_dir
					sudo chmod -R 777 $apps_dir
					backup
				else
					sudo chmod -R 777 $apps_dir
					backup
				fi

}


#echo "\n*******************************  AUTOMATION PROGRAM START  *****************************\n\n"

				validation	



