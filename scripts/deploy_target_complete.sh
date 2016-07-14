#!/bin/sh
###############################################################################################################
##  deploy_pbex.sh: Script will be used to deploy public exchange modules on weblogic and tomcat servers      #
##  Author - Pardeep Chahal                                                                                   #
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
                    home_dir=/mnt
                    upload_dir=$home_dir/upload/$server_name
                    upload_current_dir=$upload_dir/pbex_current
					weblogic_dir=$home_dir/Oracle/Middleware/user_projects/domains/base_domain
					logs_dir=/home/ubuntu/logs
					artifact_dir=$upload_dir/temp
                    apps_dir=/usr/local/applications
                    logname=deployment_$server_name_`date '+%d-%m-%Y'`.log
                    code_base=`ls -ltr $upload_current_dir | awk '{print $8}' | cut -d '_' -f3`
                    revision_number=`ls -ltr $upload_current_dir | awk '{print $8}' | cut -d '_' -f4 | cut -d '.' -f1`

# DB Name assignment start
                if [ "$host_name" = "EXQA.demo.hcentive.com" ];then
                    dbname=exqa_new
                fi
                if [ "$host_name" = "ec2-107-20-72-245.compute-1.amazonaws.com" ];then
                    dbname=test_xchange
                fi

# DB Name assignment finish

restart ()

{


        if [ "$server_name" = "tomcat" ];then
					echo " Starting tomcat server"
                    sudo /etc/init.d/tomcat start
                if [ $? -ne 0 ];then
                    echo " There are some issues in server restart, please check logs for more details \n"
                else
                    echo " Server started successfully \n"

	            echo " Please execute Batch Jobs manually \n"

                fi
		elif [ "$server_name" = "weblogic" ];then
			
			echo " Server is starting  \n"
			exit 4
		
       
		fi


}

dbcreation ()
{

		if [ "$server_name" = "tomcat" ];then
			echo " DB $dbname creation for tomcat server - $host_name, code_base - $code_base is in progress  \n"
			cd $apps_dir
            cp $upload_current_dir/*.tar.gz .
            tar -xzf *.tar.gz
			cd $apps_dir/mysql
            mysql -u root -phc2nt1v2 -e "drop database if exists $dbname;create database $dbname;use $dbname;set autocommit=0;source createpublicdb.sql;" >> $logs_dir/$logname 2>&1
        if [ $? -ne 0 ];then
                    echo " There are some problems in DB creation, please check logs for more details \n"
                    exit 1
        fi
		    deploy
		elif [ "$server_name" = "weblogic" ];then
			
			echo " DB $dbname creation for weblogic server - $host_name, code_base - $code_base is in progress  \n"
			exit 4
		
		fi


}

deploy ()
{


    if [ "$server_name" = "tomcat" ];then
                    echo " ###########  Deployment begins for tomcat server - $host_name, code_base - $code_base and revision - $revision_number  ########### \n "
                    cd $apps_dir
                    mv agent-hix-portal* agent
                    mv individual-webapp-public* individual
                    mv employer-public* employer
                    sudo chmod -R 777 *
					restart         
            elif [ "$server_name" = "weblogic" ];then
					echo "###########   DB $dbname creation for weblogic server - $host_name, code_base - $code_base is in progress ###########    \n"
					echo " Deployment is in progress\n"
					cd $apps_dir/abs-build-scripts
					ant -f deploy_weblogic.xml -Dhost_name=$host_name $logs_dir/$logname 2>&1
                    
        fi
}

undeploy ()
{
	            echo " Undeploying existing application \n\n"
    if [ "$server_name" = "tomcat" ];then
					echo " ###########  Undeploying application from tomcat ###########   \n"
                    echo "###########   Stopping all instances of $host_name ###########  \n"
                    for i in `ps -ef |grep java | awk '{print $2}'`; do sudo kill -9 $i; done >> $logs_dir/$logname 2>&1
                    cd $apps_dir
                if [ $? -ne 0 ];then
                    echo " Directory doesn't exist, please check manually and execute script again \n"
                    exit 1
                else
                    rm -rf individual employer agent config mysql shop-jobs individual-hix-jobs *.tar.gz
                    dbcreation
                fi
        elif [ "$server_name" = "weblogic" ];then
                    echo " Automation is in progress, please proceed with manual deployment for the time being ...\n "
					cd $upload_dir/pbex_current/
					ant -f undeploy_weblogic.xml -Dhost_name=$host_name $logs_dir/$logname 2>&1
				if [ $? -ne 0 ];then
                    			echo " undeployment failed, please check logs at $logs_dir/$logname and fix the problem \n"
                   			 exit 1
				fi
				
				echo "###########   Stopping all instances of $host_name ###########  \n"
                   for i in `ps -ef |grep java | awk '{print $2}'`; do sudo kill -9 $i; done >> $logs_dir/$logname 2>&1

					cd $apps_dir
                if [ $? -ne 0 ];then
                   		 	echo " Directory doesn't exist, please check manually and execute script again \n"
                   		 	exit 1
                else
                   			 rm -rf individual employer agent oracle config shop-jobs individual-hix-jobs *.tar.gz

	                dbcreation
        fi
}
backup ()
{

		   echo " You are inside backup "
	           echo " Taking backup of existing artifacts on $host_name\n"
        if [ ! -d $upload_dir ];then
	           echo " Directory does not exist, please create required directory structure on this server and try again !!! \n"
	           exit 2
        else
	           cd $upload_dir/pbex_backup
	           mv $upload_dir/pbex_current/* .
                   cd $upload_dir/pbex_current
                #       rm -rf *.tar.gz
	           mv $upload_dir/temp/* $upload_dir/pbex_current
	           echo " Calling undeploy function "
		   undeploy
        fi
}


#echo "\n*******************************  AUTOMATION PROGRAM START  *****************************\n\n"

					backup



