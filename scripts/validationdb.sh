#!/bin/sh
###############################################################################################################
#  validationdb.sh: Script will be used to validate directory structure on rds										  #
#    						                                                                                  #
###############################################################################################################

	home_dir=/mnt
	cd $home_dir
	project=phix
if [ ! -d "upload" ];then
		echo "Directory does not exist, creating required directory structure"
		sudo mkdir -p upload 
		sudo chmod -R 777 upload
		cd $home_dir/upload
		mkdir -p $project $project/current  $project/package
		chmod -R 777 $project
		exit 0
else
		cd $home_dir
		sudo chmod -R 777 upload
		cd upload
	if [ ! -d $project ];then
		echo "$server directory does not exist, creating required directory structure"
		mkdir -p $project $project/current  $project/package
		chmod -R 777 $project
		exit 0
	else
		echo " Directory already exist, proceeding with transfer files"
		exit 0
	fi	
	
fi