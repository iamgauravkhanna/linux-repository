#!/bin/sh
###############################################################################################################
#  deploy_pbex.sh: Script will be used to deploy public exchange modules on weblogic and tomcat servers       #
#                                                                                  							  #
###############################################################################################################

	if [ $# -lt 4 ];then
			echo " \n wrong number of arguments passed, please pass correct arguments, For example: \n"
			echo " Select one of below formats to execute this script: \n"
			echo " sh deploy_pbex.sh revision_number server_name hostname branchname/tagname/trunkname\n"
			echo " Select below format to deploy revision - 48900 on application server weblogic and host xyz for branch 3.0.20-HixCSC \n"
			echo " sh deploy_pbex.sh 48900 weblogic xyz 3.0.20-HixCSC \n"
		        echo " Select below format to deploy revision -head on application server tomcat and host xyz for trunk\n"
			echo " sh deploy_pbex.sh head tomcat xyz private-exchange\n"
			exit 1
	fi
			current_dir=/var/jenkins/projects/prd-hix/bin/abs-build-scripts
			cd $current_dir/bin
			dos2unix *
			cd $current_dir/properties
			. ./setdeploy.env
			logname=$logs_dir/deployment_`date '+%d-%m-%Y'`.log
			
# DB Name assignment start

                if [ "$host_name" = "ec2-107-20-72-245.compute-1.amazonaws.com" ];then
                    dbname=pbex_pk
                fi
				if [ "$host_name" = "EXQA.demo.hcentive.com" ];then
                    dbname=PBEX_QA1
                fi
                if [ "$host_name" = "hix.dev.demo.hcentive.com" ];then
                    dbname=hix_dev
                fi

# DB Name assignment finish

deploy ()
{

			echo "########################## Deployment Begins ##########################\n\n"
			scp -i $key_home/$host_name.pem -r $current_dir/bin/$deployment_file.sh $apps_user@$host_name:$apps_dir
		if [ $? -ne 0 ];then
			echo " There was some issue in transfer task, please correct it manually and execute command again\n"
			exit 12
		fi
			
			
	if [ "$server_name" = "tomcat" ];then
			echo " ############ deployment begins for tomcat ############### \n"
			ant -f $current_dir/config/$deployment_file.xml -Dhostname=$host_name -Dserver_name=$server_name -Dlogname=$logname -Dapps_dir=$apps_dir -Dkey_home=$key_home -Dport_number=$port_number -Ddb_name=$dbname
		if [ $? -ne 0 ];then
			echo "Subject: Status of deployment operation submitted for branch - $stream_name, Target Server - $host_name " 
			echo "\n There was some issue in hix deployment task on $host_name for code_base - $stream_name, please correct it manually and execute command again\n"  
			#sh $current_dir/bin/distribute_mail.sh $current_dir/properties/deploy_mail.txt
			exit 7
		else
			echo "Subject: Status of deployment operation submitted for branch - $stream_name, Target Server - $host_name " 
			echo "\n Deployment completed successfully for branch - $stream_name, revision - $revision_number, server - $server_name and host - $host_name " 
			echo "\n Test application on below URL's - " 
			echo "\n https://$host_name/agent"
			echo "\n https://$host_name/employer"
			echo "\n https://$host_name/individual"
			#sh $current_dir/bin/distribute_mail.sh $current_dir/properties/deploy_mail.txt
		fi
	elif [ "$server_name" = "weblogic" ];then
			echo " ############ deployment begins for weblogic ############### \n"
			#scp -i $key_home/$host_name.pem -r $current_dir/undeploy_weblogic.xml $apps_user@$host_name:$apps_dir
			scp -i $key_home/$host_name.pem -r $current_dir/config/pom.xml $apps_user@$host_name:$apps_dir
			scp -i $key_home/$host_name.pem -r $current_dir/bin/start.sh $apps_user@$host_name:$apps_dir
			scp -i $key_home/$host_name.pem -r $current_dir/bin/deploy_weblogic.sh $apps_user@$host_name:$apps_dir
			scp -i $key_home/$host_name.pem -r $current_dir/bin/start_weblogic.sh $apps_user@$host_name:$apps_dir
		if [ $? -ne 0 ];then
			echo " There was some issue in transfer task, please correct it manually and execute command again\n"
			exit 10
		fi
			ant -f $current_dir/config/$deployment_file.xml -Dhostname=$host_name -Dserver_name=$server_name -Dlogname=$logname -Dapps_dir=$apps_dir -Dkey_home=$key_home -Dport_number=$port_number -Ddb_name=$dbname
		if [ $? -ne 0 ];then
			echo " There was some issue in undeployment task, please correct it manually and execute command again\n"
			exit 5
		fi
			echo " DB creation is in progress \n"
			temp_dir=`cat $artifact_dir/temp | cut -d '/' -f1-3`
			oracle_dir=$artifact_dir/$temp_dir
		if [ $? -ne 0 ];then
			echo " There was some issue in DB creation task, please correct it manually and execute command again\n"
			exit 9
		fi
			echo $oracle_dir

			scp -i $key_home/$db_staging_server.pem -r $oracle_dir/$oracle_artifact_name $db_user@$db_staging_server:$db_upload_dir
			scp -i $key_home/$db_staging_server.pem -r $current_dir/bin/create_db.sh $db_user@$db_staging_server:$db_upload_dir
		if [ $? -ne 0 ];then
		    echo " There was some issue in DB transfer task, please correct it manually and execute command again\n"
			echo " There was some issue in DB transfer task, please correct it manually and execute command again\n" 
			#sh $current_dir/bin/distribute_mail.sh $current_dir/properties/deploy_mail.txt	
			exit 11
		fi
			cd $current_dir/config
			#ant -f $current_dir/config/create_db.xml -Dhostname=$db_staging_server -Ddb_name=$dbname -Dlogname=$logname -Dkey_home=$key_home -Dartifact_name=$oracle_artifact_name
			
		if [ $? -ne 0 ];then
		    echo " There was some issue in DB creation task, please correct it manually and execute command again\n"
			echo " There was some issue in DB creation task, please correct it manually and execute command again\n" 
			#sh $current_dir/bin/distribute_mail.sh $current_dir/properties/deploy_mail.txt		
			exit 6
		fi
			echo " Restart weblogic and deploy the application \n"
			ant -f $current_dir/config/deploy_target_weblogic.xml -Dhostname=$host_name -Dlogname=$logname -Dapps_dir=$apps_dir -Dkey_home=$key_home -Dport_number=$port_number
		if [ $? -ne 0 ];then
			echo " There was some issue in deployment task, please correct it manually and execute command again\n"
			echo " There was some issue in deployment task, please correct it manually and execute command again\n" 
			#sh $current_dir/bin/distribute_mail.sh $current_dir/properties/deploy_mail.txt	
			exit 7
		fi
			echo " Deployment on weblogic server for host - $host_name is completed successully, please execute batch jobs manually and start testing \n"
			echo "Subject: Status of deployment operation submitted for branch - $stream_name, Target Server - $host_name " 
			echo "\nDeployment completed successfully for branch - $stream_name, revision - $revision_number, server - $server_name and host - $host_name " 
			echo "\nTest application on below URL's - " 
			echo "\nhttp://$host_name:$port_number/agent"
			echo "\nhttp://$host_name:$port_number/employer"
			echo "\nhttp://$host_name:$port_number/individual"
			echo "\nNote: For more details login on - https://build.hcentive.com and check Public Exchange dashboard "
			#sh $current_dir/bin/distribute_mail.sh $current_dir/properties/deploy_mail.txt		
	fi

}

transferfiles ()
{


			echo " Transfering artifacts at target server at location : $target_upload_dir/temp"
	for i in `cat $artifact_dir/temp`
		do
			scp -i $key_home/$host_name.pem -r $artifact_dir/$i $apps_user@$host_name:$target_upload_dir/temp
		if [ $? -ne 0 ];then
		    echo " Transfer of artifacts failed, please check logs and take corrective action\n"
			echo " Transfer of artifacts failed, please check logs and take corrective action\n" 
			#sh $current_dir/bin/distribute_mail.sh $current_dir/properties/deploy_mail.txt		
			exit 9
		fi
		done
			# Call deploy Function 
			deploy
}


validation ()
{
			echo " Check whether build exists or not " 
			cd $artifact_dir
			rm -rf temp
	for i in `find . -name $artifact_name` 
		do
		echo $i >> temp
	done

	if [ -s temp ];then
			artifact_temp=`cat $artifact_dir/temp`
			echo " Release $artifact_name already exist at $artifact_dir/$artifact_temp, proceeding with deployment \n "
			echo " Validating Directory structure on target machine \n"
			scp -i $key_home/$host_name.pem -r $current_dir/bin/validation.sh $apps_user@$host_name:$apps_dir
		if [ $? -ne 0 ];then
		    echo " There was some issue in copy, please correct it manually and execute command again\n"
			echo " There was some issue in copy, please correct it manually and execute command again\n" 
			#sh $current_dir/bin/distribute_mail.sh $current_dir/properties/deploy_mail.txt		
			exit 8
		fi
			ant -f $current_dir/config/validation.xml -Dhostname=$host_name -Dserver_name=$server_name -Dlogname=$logname -Dapps_dir=$apps_dir -Dkey_home=$key_home
		if [ $? -ne 0 ];then
		    echo " There was some issue in validation, please correct it manually and execute command again\n"
			echo " There was some issue in validation, please correct it manually and execute command again\n" 
			#sh $current_dir/bin/distribute_mail.sh $current_dir/properties/deploy_mail.txt		
			exit 8
		fi
			echo " Calling transferfiles function \n"
			transferfiles
	else
			echo " Release $release_number doesn't exist, please create new release and try again"
			exit 1
	fi

}

#echo "\n*******************************AUTOMATION PROGRAM START*****************************\n\n"

                     validation         		


########################################## AUTOMATION PROGRAM END #################################







