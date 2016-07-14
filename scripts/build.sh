#!/bin/sh
#####################################################################################################################
##  build.sh: Script will be used to compile and build source code of public exchange modules                       #
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

			echo " $1 and $2 and $3 and $4 "
			current_dir=/var/jenkins/projects/prd-hix/bin/abs-build-scripts
			cd $current_dir
			svn update
			cd $current_dir/properties
			. ./setbuild.env
			echo " Branch specified is $stream_name and Release is $revision_number " 
			echo $artifact_name
			echo $src_dir
			echo $oracle_artifact_name
			
			    if [ "$host_name" = "ec2-107-20-72-245.compute-1.amazonaws.com" ];then
                    dbname=pbex_pk
                fi
				if [ "$host_name" = "EXQA.demo.hcentive.com" ];then
                    dbname=hix_qa1
					rds=hixqa1.cq66g54vnu5m.us-east-1.rds.amazonaws.com:1521:hixqa1
					dbms=hixqa1
                fi
                if [ "$host_name" = "hix.dev.demo.hcentive.com" ];then
                    dbname=hix_dev1
					rds=hixqa1.cq66g54vnu5m.us-east-1.rds.amazonaws.com:1521:hixqa1
					dbms=hixqa1
                fi
				
				if [ "$host_name" = "ex1.demo.hcentive.com" ];then
                    dbname=PBEX_EX1
					rds=hixqa1.cq66g54vnu5m.us-east-1.rds.amazonaws.com:1521:hixqa1
					dbms=hixqa1
                fi
				
				if [ "$host_name" = "54.225.235.219" ];then
                    dbname=exqa_new
					rds=hixqa1.cq66g54vnu5m.us-east-1.rds.amazonaws.com:1521:hixqa1
					dbms=hixqa1
                fi
				
				if [ "$host_name" = "54.225.90.208" ];then
                    dbname=hix_ky
					rds=hixqa1.cq66g54vnu5m.us-east-1.rds.amazonaws.com:1521:hixqa1
					dbms=hixqa1
                fi
				
			
######################################################## Update current workspace #######################3

updateworkspace()
{
			
				echo " updating local workspace $src_dir to $revision_number"
				cd $src_dir
				echo $src_dir
				# Code doesn't exist
    if [ ! -d "$stream_name" ] ; then
		if  [ "$revision_number" = "head" ];then
				echo " Code does not exist, checkout fresh code !!!" 
				cd $src_dir
				echo $svn_base_url/$code_base/$stream_name
				svn co $svn_base_url/$code_base/$stream_name 
		else
				echo " Code does not exist, checkout code from $revision_number !!!" 
				cd $src_dir
				echo $svn_base_url/$code_base/$stream_name 
				svn co -r $revision_number $svn_base_url/$code_base/$stream_name 
		fi
    else
				echo "Code does exist "
	    if [ "$revision_number" = "head" ];then
				echo " Updating existing code "
				cd $src_dir/$stream_name
				echo $svn_base_url/$code_base/$stream_name 
				svn update 
		else
				echo " Code does exist, updating workspace from revision $revision_number \n"
				cd $src_dir/$stream_name
				echo $svn_base_url/$code_base/$stream_name 
				svn update -r $revision_number 
		fi
    fi
			if [ $? -ne 0 ];then
				echo " Build Failed at exit 9, please check logs at $logs_dir/"$stream_name"_"$revision_number".log for more details "
				exit 9 
			fi

}

dbproperties ()
{

				cd $src_dir/$stream_name/build/build-db
			if [ -f $src_dir/$stream_name/build/build-db/db.properties ];then
				rm $src_dir/$stream_name/build/build-db/db.properties 
			fi
			if [ -f $src_dir/$stream_name/build/build-db/temp.properties ];then
				rm $src_dir/$stream_name/build/build-db/temp.properties
			fi
				svn update
				sed 's/DBNAME/'$dbname'/g' db.properties > temp.properties
				mv temp.properties db.properties
				sed 's/RDS/'$rds'/g' db.properties > temp.properties
				mv temp.properties db.properties
				sed 's/DBMS/'$dbms'/g' db.properties > temp.properties
				mv temp.properties db.properties
}

buildsourcecode ()
{			
				echo "Compilation begins " 
    if [ "$stream_name" = "$trunk" ];then
				echo "Compilation starts for trunk" 
        
    else
				cd $src_dir/$stream_name/build/build-tools
        if [ ! -f "pom.xml" ]; then
				echo "Code does not exist, please checkout fresh code and try again!!!"  
				exit 1
        else
				echo "Compilation starts for branch $stream_name"
				echo "Compilation starts for branch $stream_name" 
				mvn $installcommand -Pprod 
			if [ $? -ne 0 ];then
				echo " Build Failed at exit 10, please check logs at $logs_dir/"$stream_name"_"$revision_number".log for more details "  > $current_dir/properties/build_mail.txt
				#sh $current_dir/bin/distribute_mail.sh $current_dir/properties/build_mail.txt
				exit 10
            else
				echo "Build Successfull"
            fi

				cd $src_dir/$stream_name/build
				echo " ########### Building code for service-deps ###########################"
				mvn -Dmaven.test.skip=true $installcommand -Pprod -f service-deps.pom 
            if [ $? -ne 0 ];then
				echo " Build Failed at exit 1, please check logs at $logs_dir/"$stream_name"_"$revision_number".log for more details "  > $current_dir/properties/build_mail.txt
				#sh $current_dir/bin/distribute_mail.sh $current_dir/properties/build_mail.txt
				exit 1
            else
				echo "Build Successfull"
            fi
				echo "#################  Building code for web-deps #############################"
				mvn -Dmaven.test.skip=true $installcommand -Pprod -f web-deps.pom 
			if [ $? -ne 0 ];then
				echo " Build Failed at exit 2, please check logs at $logs_dir/"$stream_name"_"$revision_number".log for more details "  > $current_dir/properties/build_mail.txt
				#sh $current_dir/bin/distribute_mail.sh $current_dir/properties/build_mail.txt
				exit 2
            else
				echo "Build Successfull"
            fi
				cd $src_dir/$stream_name/build/individual-build-hix
				echo "#############################Building code for individual-build-hix#############################"
		    if [ "$server" = "weblogic" ];then
				echo " Building for $server "
				mvn $installcommand -Dserver=$server -Pprod -f pom.xml 
		    else 
				echo " Building for $server  "
				mvn $installcommand -Pprod -f pom.xml 
		    fi
		    if [ $? -ne 0 ];then
				echo " Build Failed at exit 3, please check logs at $logs_dir/"$stream_name"_"$revision_number".log for more details "
				echo " Build Failed at exit 3, please check logs at $logs_dir/"$stream_name"_"$revision_number".log for more details " > $current_dir/properties/build_mail.txt
				#sh $current_dir/bin/distribute_mail.sh $current_dir/properties/build_mail.txt
				exit 3
            else
				echo "Build Successfull"
            fi
				cd $src_dir/$stream_name/build/shop-build-hix
				echo "#############################Building code for shop-build-hix#############################"
            if [ "$server" = "weblogic" ];then
				echo "Building for $server "
				mvn $installcommand -Dserver=$server -Pprod -f pom.xml 
		    else 
				echo " Building for $server  "
				mvn $installcommand -Pprod -f pom.xml 
		    fi
		    if [ $? -ne 0 ];then
				echo " Build Failed at exit 4, please check logs at $logs_dir/"$stream_name"_"$revision_number".log for more details "
				echo " Build Failed at exit 4, please check logs at $logs_dir/"$stream_name"_"$revision_number".log for more details " > $current_dir/properties/build_mail.txt
				#sh $current_dir/bin/distribute_mail.sh $current_dir/properties/build_mail.txt
				exit 4
            else
				echo "Build Successfull"
            fi
				cd $src_dir/$stream_name/build/agent-build-hix
				echo "########################### Building code for agent-build-hix #############################"
		    if [ "$server" = "weblogic" ];then
				echo " Building for $server  "
				mvn $installcommand -Dserver=$server -Pprod -f pom.xml 
		    else 
				echo " Building for $server  "
				mvn $installcommand -Pprod -f pom.xml 
		    fi
		    if [ $? -ne 0 ];then
				echo " Build Failed at exit 5, please check logs at $logs_dir/"$stream_name"_"$revision_number".log for more details "
				echo " Build Failed at exit 5, please check logs at $logs_dir/"$stream_name"_"$revision_number".log for more details " > $current_dir/properties/build_mail.txt
				#sh $current_dir/bin/distribute_mail.sh $current_dir/properties/build_mail.txt
				exit 5
            else
				echo "Build Successfull"
            fi
				cd $src_dir/$stream_name/modules/shop
				echo "############################# Building code for shop #############################"
				mvn -Dmaven.test.skip=true $installcommand -Pprod -f pom.xml 
		    if [ $? -ne 0 ];then
				echo " Build Failed at exit 6, please check logs at $logs_dir/"$stream_name"_"$revision_number".log for more details " > $current_dir/properties/build_mail.txt
				#sh $current_dir/bin/distribute_mail.sh $current_dir/properties/build_mail.txt
				exit 6
            else
				echo "Build Successfull"
            fi
				cd $src_dir/$stream_name/applications/shop-jobs
				echo "############################# Building code for shop-jobs #############################"
				mvn -Dmaven.test.skip=true $installcommand -Pprod -f pom.xml 
		    if [ $? -ne 0 ];then
				echo " Build Failed at exit 7, please check logs at $logs_dir/"$stream_name"_"$revision_number".log for more details "  > $current_dir/properties/build_mail.txt
				#sh $current_dir/bin/distribute_mail.sh $current_dir/properties/build_mail.txt
				exit 7
              else
				echo "Build Successfull"
            fi
				cd $src_dir/$stream_name/applications/individual-hix-jobs
				echo "############################# Building code for individual-hix-jobs #############################"
				mvn -Dmaven.test.skip=true $installcommand -Pprod -f pom.xml 
		    if [ $? -ne 0 ];then
				echo " Build Failed at exit 8, please check logs at $logs_dir/"$stream_name"_"$revision_number".log for more details "
				exit 8
            else
				echo "Build Successfull"
            fi
        fi
    fi

}


copyartifacts ()
{
			
				cd $src_dir/$stream_name/applications/employer-hix-portal
				employer_release_number=`cat pom.xml | grep version |head -1 |cut -d ">" -f2 | cut -d "<" -f1`
				cd $src_dir/$stream_name/applications/individual-hix-portal
				individual_release_number=`cat pom.xml | grep version |head -1 |cut -d ">" -f2 | cut -d "<" -f1`
				cd $src_dir/$stream_name/applications/agent-hix-portal
				agent_release_number=`cat pom.xml | grep version |head -1 |cut -d ">" -f2 | cut -d "<" -f1`
				echo " Creation of $artifact_name begins \n"
				cd $home_dir/artifacts/$code_base
				rm -rf $home_dir/temp
				mkdir -p $home_dir/temp
				chmod -R 777 $home_dir/temp
				
		if [ ! -d $stream_name ];then
				echo " Release doesn't exist, create new release folder and copy files"  
				mkdir -p $home_dir/artifacts/$code_base/$stream_name
				cp -R $src_dir/$stream_name/applications/agent-hix-portal/target/agent-hix-portal-$agent_release_number $home_dir/temp
			if [ $? -ne 0 ];then
				echo " Copy Failed, source file doesn't exist or execute script in debug mode using -X option"  
				exit 1
			fi
				cp -R $src_dir/$stream_name/applications/individual-hix-portal/target/individual-webapp-public-$individual_release_number $home_dir/temp
			if [ $? -ne 0 ];then
				echo " Copy Failed, source file doesn't exist or execute script in debug mode using -X option"  
				exit 1
			fi
				cp -R $src_dir/$stream_name/applications/employer-hix-portal/target/employer-public-$employer_release_number $home_dir/temp
			if [ $? -ne 0 ];then
				echo " Copy Failed, source file doesn't exist or execute script in debug mode using -X option"  
				exit 1
			fi
			
			if [ "$server" = "weblogic" ];then	
				cp -R $src_dir/$stream_name/db/oracle $home_dir/temp
				cd $home_dir/temp
				tar -czf $oracle_artifact_name oracle
				cp $oracle_artifact_name $home_dir/artifacts/$code_base/$stream_name
	        	else
				cp -R $src_dir/$stream_name/db/mysql $home_dir/temp
		     fi
				cp -R $src_dir/$stream_name/config $home_dir/temp
				cp -R $src_dir/$stream_name/applications/shop-jobs/target $home_dir/temp
				mv $home_dir/temp/target $home_dir/temp/shop-jobs
				cp -R $src_dir/$stream_name/applications/individual-hix-jobs/target $home_dir/temp
				mv $home_dir/temp/target $home_dir/temp/individual-hix-jobs
				cd $home_dir/temp
				tar -czf $artifact_name *
				cp $home_dir/temp/$artifact_name $home_dir/artifacts/$code_base/$stream_name
				
				
		else
				echo $oracle_artifact_name
				cd $home_dir/artifacts/$code_base/$stream_name
			if [ -f "$artifact_name" ]; then
				echo "Release does exist, deleting existing release!!!"  
				rm $artifact_name
			fi
				cp -R $src_dir/$stream_name/applications/agent-hix-portal/target/agent-hix-portal-$agent_release_number $home_dir/temp
			if [ $? -ne 0 ];then
				echo " Copy Failed, source file doesn't exist or execute script in debug mode using -X option"  
				exit 1
			fi
				cp -R $src_dir/$stream_name/applications/individual-hix-portal/target/individual-webapp-public-$individual_release_number $home_dir/temp
			if [ $? -ne 0 ];then
				echo " Copy Failed, source file doesn't exist or execute script in debug mode using -X option"  
				exit 1
			fi
				cp -R $src_dir/$stream_name/applications/employer-hix-portal/target/employer-public-$employer_release_number $home_dir/temp
			if [ $? -ne 0 ];then
				echo " Copy Failed, source file doesn't exist or execute script in debug mode using -X option"  
				exit 1
			fi
			
			if [ "$server" = "weblogic" ];then	
				cp -R $src_dir/$stream_name/db/oracle $home_dir/temp
				cd $home_dir/temp
				tar -czf $oracle_artifact_name oracle
				cp $oracle_artifact_name $home_dir/artifacts/$code_base/$stream_name
	        	else
				cp -R $src_dir/$stream_name/db/mysql $home_dir/temp
		     fi
				cp -R $src_dir/$stream_name/config $home_dir/temp
				cp -R $src_dir/$stream_name/applications/shop-jobs/target $home_dir/temp
				mv $home_dir/temp/target $home_dir/temp/shop-jobs
				cp -R $src_dir/$stream_name/applications/individual-hix-jobs/target $home_dir/temp
				mv $home_dir/temp/target $home_dir/temp/individual-hix-jobs
				cd $home_dir/temp
				tar -czf $artifact_name *
				cp $home_dir/temp/$artifact_name $home_dir/artifacts/$code_base/$stream_name
		fi
				
 			if [ $? -ne 0 ];then
				echo " Copy Failed at exit 9, source file doesn't exist or execute script in debug mode using -X option"  
				exit 9
            else
				echo "Copy Successfull, create $artifact_name \n"
				echo " archive $artifact_name created successfully and copied at $home_dir/artifacts/$code_base/$stream_name\n"
				echo "Subject: Status of PRD-HIX build operation submitted for branch - $stream_name" > $current_dir/properties/build_mail.txt
				echo "\nCompilation completed successfully for branch - $stream_name and server - $server, please proceed with deployment" >> $current_dir/properties/build_mail.txt
				echo "\nNote: For more details login on - https://build.hcentive.com and check Public Exchange Dashboard ">> $current_dir/properties/build_mail.txt
				#sh $current_dir/bin/distribute_mail.sh $current_dir/properties/build_mail.txt
            fi
	



}

#echo "\n*******************************AUTOMATION PROGRAM START*****************************\n\n"

				#updateworkspace
				dbproperties
				buildsourcecode
				copyartifacts


########################################## AUTOMATION PROGRAM END #################################








