#!/bin/sh
###############################################################################################################
#  validation.sh: Script will be used to validate directory structure 										  #
#  Author - Pardeep Chahal                                                                                    #
###############################################################################################################

	home_dir=/mnt
	cd $home_dir
	server=$1
if [ ! -d "upload" ];then
		echo "Directory does not exist, creating required directory structure"
		sudo mkdir -p upload 
		sudo chmod -R 777 upload
		cd $home_dir/upload
		mkdir -p $server $server/current  $server/backup $server/temp logs
		chmod -R 777 $server logs
		exit 0
else
		cd $home_dir
		sudo chmod -R 777 upload
		cd upload
	if [ ! -d $server ];then
		echo "$server directory does not exist, creating required directory structure"
		mkdir -p $server $server/current  $server/backup $server/temp logs
		chmod -R 777 $server logs
		exit 0
	else
		echo " Directory already exist, proceeding with transfer files"
		exit 0
	fi	
	
fi