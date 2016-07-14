#!/bin/sh
#####################################################################################################################
##  pre-build.sh: Script will be used to create datbase and execute pre-build tasks for hix	                        #
##                                                                                                  		        #
#####################################################################################################################

		if [ $# -lt 5 ] ;then
			echo "\n Wrong number of arguments passed, please pass correct arguments, For example: \n"
			echo " Select one of below formats to execute this script:\n "
			echo " sh build.sh branches/tags/trunk branchname/tagname/trunkname weblogic/tomcat revision_number/head\n"
			echo " Select below command to build code of branch 3.0.20-HixCSC from head revision for weblogic server and hostname - hix.dev.demo.hcentive.com:\n"
			echo " sh build.sh branches 3.0.20-HixCSC weblogic head hix.dev.demo.hcentive.com\n"
			echo " Select below command to build code of trunk from revison 48740 for tomcat server:\n"
			echo " sh build.sh trunk private-exchange tomcat 48740 hix.dev.demo.hcentive.com\n"
			exit 1
	fi
			module=$6

			echo " $1 and $2 and $3 and $4 and $5 and $6"
			current_dir=/var/jenkins/projects/prd-hix/bin/abs-build-scripts
			cd $current_dir
			svn update
			cd $current_dir/properties
			. ./setbuild.env
			echo " Branch specified is $stream_name and Release is $revision_number " 
			echo $artifact_name
			echo $src_dir
			echo $oracle_artifact_name
			
			if [ "$host_name" = "EXQA.demo.hcentive.com" ];then
				if [ "$module" = "application" ];then
                    dbname=hix_qa1
				elif [ "$module" = "shop_jobs" ];then
					dbname=hix_job_shop
				elif [ "$module" = "indv_jobs" ];then
					dbname=hix_job_indv
				fi
					rds=hixqa1.cq66g54vnu5m.us-east-1.rds.amazonaws.com:1521:hixqa1
					dbms=hixqa1
            fi
            if [ "$host_name" = "hix.dev.demo.hcentive.com" ];then
                if [ "$module" = "application" ];then
                    dbname=hix_dev1
				elif [ "$module" = "shop_jobs" ];then
					dbname=hix_job_shop1
				elif [ "$module" = "indv_jobs" ];then
					dbname=hix_job_indv1
				fi
					rds=product.cq66g54vnu5m.us-east-1.rds.amazonaws.com:1521:product
					dbms=product
            fi
				
				if [ "$host_name" = "ex1.demo.hcentive.com" ];then
                    dbname=PBEX_EX1
					rds=product.cq66g54vnu5m.us-east-1.rds.amazonaws.com:1521:product
					dbms=product
                fi
				
				if [ "$host_name" = "54.225.235.219" ];then
                    dbname=exqa_new
					rds=product.cq66g54vnu5m.us-east-1.rds.amazonaws.com:1521:product
					dbms=product
                fi
				
			if [ "$host_name" = "54.225.90.208" ];then
			
				if [ "$module" = "application" ];then
                    dbname=hix_ky
				elif [ "$module" = "shop_jobs" ];then
					dbname=ky_job_shop
				elif [ "$module" = "indv_jobs" ];then
					dbname=ky_job_indv
				fi
					rds=hixqa1.cq66g54vnu5m.us-east-1.rds.amazonaws.com:1521:hixqa1
					dbms=hixqa1
            fi
				
			
######################################################## Update current workspace #######################3


copydbartifacts ()
{
			
				echo " Creation of $artifact_name begins \n"
				cd $home_dir/artifacts/$code_base
				rm -rf $home_dir/temp
				mkdir -p $home_dir/temp
				chmod -R 777 $home_dir/temp

			
			if [ "$server" = "weblogic" ];then	
				cp -R $src_dir/$stream_name/db/oracle $home_dir/temp
				cd $home_dir/temp
				tar -czf $oracle_artifact_name oracle
				cp $oracle_artifact_name $home_dir/artifacts/$code_base/$stream_name
		    fi
				
 			if [ $? -ne 0 ];then
				echo " Copy Failed at exit 9, source file doesn't exist or execute script in debug mode using -X option"  
				exit 9
            else
				echo "Copy Successfull, create $artifact_name \n"
            fi
	



}

stopserver ()
{

echo " Stopping all instances of weblogic server "
scp -i $key_home/$host_name.pem -r $current_dir/bin/stop_weblogic.sh $apps_user@$host_name:$apps_dir
scp -i $key_home/$host_name.pem -r $current_dir/bin/start_weblogic.sh $apps_user@$host_name:$apps_dir
ant -f $current_dir/config/stop_weblogic.xml -Dhostname=$host_name  -Dkey_home=$key_home -Dapps_dir=$apps_dir
}

createdb ()
{

	
			echo " DB creation is in progress \n"
			#temp_dir=`cat $artifact_dir/temp | cut -d '/' -f1-3`
			oracle_dir=$artifact_dir/$code_base/$stream_name
		if [ $? -ne 0 ];then
			echo " There was some issue in DB creation task, please correct it manually and execute command again\n"
			exit 9
		fi
			echo $oracle_dir
			scp -i $key_home/$db_staging_server.pem -r $oracle_dir/$oracle_artifact_name $db_user@$db_staging_server:$db_upload_dir
		if [ $? -ne 0 ];then
		    echo " There was some issue in DB transfer task, please correct it manually and execute command again\n"
			#sh $current_dir/bin/distribute_mail.sh $current_dir/properties/deploy_mail.txt	
			exit 11
		fi
			scp -i $key_home/$db_staging_server.pem -r $current_dir/bin/create_db.sh $db_user@$db_staging_server:$db_upload_dir
		if [ $? -ne 0 ];then
		    echo " There was some issue in DB transfer task, please correct it manually and execute command again\n"
			#sh $current_dir/bin/distribute_mail.sh $current_dir/properties/deploy_mail.txt	
			exit 12
		fi
			cd $current_dir/config
			echo " Database creation started for hostname - $hostname and for schema - $dbname \n"
			ant -f create_db.xml -Dhostname=$db_staging_server -Ddb_name=$dbname -Dkey_home=$key_home -Dartifact_name=$oracle_artifact_name -Dmodule=$module
			
		if [ $? -ne 0 ];then
		    echo " There was some issue in DB creation task, please correct it manually and execute command again\n"	
			exit 6
		fi
}

startserver ()
{

			echo " Starting servers \n"
			ant -f $current_dir/config/start_weblogic.xml -Dhostname=$host_name -Dkey_home=$key_home -Dapps_dir=$apps_dir

}

#echo "\n*******************************AUTOMATION PROGRAM START*****************************\n\n"

				#updateworkspace
				copydbartifacts
				stopserver
				createdb
				startserver


########################################## AUTOMATION PROGRAM END #################################








