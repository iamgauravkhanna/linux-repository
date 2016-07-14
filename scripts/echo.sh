#!/bin/bash
#####################################################################################
##  HIXweblogic: This is a menu driven script for Weblogic Daily Rountine Task     ##
##                                                            ##
#####################################################################################

weblogic_domain=/home/ubuntu/Oracle/Middleware/user_projects/domains/base_domain 
CODE_BASE=/usr/local/applications
#file="nohup.out"

while :
	do
	clear
	echo  "#---------------------------------------------------------------#"
	echo  "#              HIXweblogic  M A I N - M E N U                   #"
	echo  "#_______________________________________________________________#"
	echo -e "\n1. Stop Weblogic Server"
	echo -e "\n2. Start Weblogic Server"
	echo -e "\n3. Clear Admin Server logs and restart Weblogic Server"
	echo -e "\n4. Check Running Status of Weblogic server & Batch Jobs"
	echo -e "\n5. Stop the Exchange Batch Jobs"
	echo -e "\n6. Start the Exchange Batch Jobs"
	echo -e "\n7. Exit"                        
	echo -e -n "Please enter option [1 - 7] CAREFULLY: "
	read opt

	case $opt in
  	1) 	echo -e "\n************ Stopping Weblogic Server *************"
		sleep 2
     		#cd $weblogic_domain
		#sudo sh stopWebLogic.sh &;;
		PID_WEBLOGIC=`pidof /home/ubuntu/Oracle/Middleware/jdk160_29/bin/java`
		sudo kill -9 -f $PID_WEBLOGIC;; 

  	2) 	echo -e "\n************ Starting Weblogic Server *************"
		sleep 2
     		cd $weblogic_domain
 		sudo sh startWebLogic.sh &
		exit 1;;

  	3) 	echo -e "\n************ Stopping Weblogic Server for clearing cache logs*************"
		sleep 2
     		#cd $weblogic_domain
		#sudo sh stopWebLogic.sh &
		PID_WEBLOGIC=`pidof /home/ubuntu/Oracle/Middleware/jdk160_29/bin/java`
                sudo kill -9 -f $PID_WEBLOGIC;;

		echo -e "\n************ Deleting logs,tmp & cache from Weblogic Admin Server *************"
		sleep 2
		cd $weblogic_domain/servers/AdminServer
		sudo rm -rf logs tmp cache
		
		echo -e "\n************ Starting Weblogic Server *************"
		sleep 2
        	cd $weblogic_domain
		sudo sh startWebLogic.sh &
		exit 1;;

  	4)    	echo -e "\n************ Check below running status *************"
		PID_WEBLOGIC=`sudo ps -ef | grep "/home/ubuntu/Oracle/Middleware/jdk160_29/bin/java" | grep -v "grep" | wc -l`
        	if [ $PID_WEBLOGIC -eq 1 ];
        	then
                	echo -e "\n[RUNNING] >> WEBLOGIC"
        	else
                	echo -e "\n[NOT RUNNING] >> WEBLOGIC"
        	fi

		PID_INDVJOB=`sudo ps -ef | grep "/usr/local/applications/individual-hix-jobs/individualJob/etc" | grep -v "grep" | wc -l`
                if [ $PID_INDVJOB -eq 1 ];
                then
                        echo -e "\n[RUNNING] >> INDIVIDUAL-HIX-JOB"
                else
                        echo -e "\n[NOT RUNNING] >> INDIVIDUAL-HIX-JOB"
                fi

		PID_SHOPJOB=`ps -ef | grep "/usr/local/applications/shop-jobs/smallgroup/etc" | grep -v "grep" | wc -l`
                if [ $PID_SHOPJOB -eq 1 ];
                then
                        echo -e "\n[RUNNING] >> SHOP-JOB"
                else
                        echo -e "\n[NOT RUNNING] >> SHOP-JOB"
                fi

		echo -e "\nPress [enter] key to continue. . ."
                read enterKey;;

	5)	echo -e "\n************ Stopping Individual-Hix-Job *************"
		sleep 2
                sudo ps -ef | grep $CODE_BASE/individual-hix-jobs/individualJob | grep -v grep | awk '{print $2}' | xargs kill -9
		echo -e "\n************ Individual-Hix-Job Stopped. *************"
		sleep 2
		echo -e "\n************ Stopping Shop-Job *************"
		sleep 2
		sudo ps -ef | grep $CODE_BASE/shop-jobs/smallgroup | grep -v grep | awk '{print $2}' | xargs kill -9
		echo -e "\n************ Shop-Job Stopped. *************"
		sleep 3;;

	6)	echo -e "\n************ Starting Individual-Hix-Job *************"
		sudo chmod -R 775 $CODE_BASE
		sleep 1
		sudo cp /mnt/jobs/indv_job/logback.xml $CODE_BASE/individual-hix-jobs/individualJob/bin/
		cd $CODE_BASE/individual-hix-jobs/individualJob/bin
		#[[ -f "$file" ]] && sudo rm -f "$file"
		sudo sh individual-hix-job &
		echo -e "\n************ Individual-Hix-Job Started. *************"
		sleep 1

		echo -e "\n************ Starting Shop-Job *************"
		sleep 1
		sudo cp /mnt/jobs/shop_job/logback.xml $CODE_BASE/shop-jobs/smallgroup/bin/
		cd $CODE_BASE/shop-jobs/smallgroup/bin
		#[[ -f "$file" ]] && sudo  rm -f "$file"
		sudo sh small-group-job &
		echo -e "\n************ Shop-Job Started. *************"
		sleep 2;;
		
	7)	echo -e -e "\n*************************************** T H A N K   Y O U !! ************************************************"
		exit 1;;

	*)	echo -e "\n\t[E R R O R] >> You have entered an invaild option. Please select option between 1-7 only"
	     	echo -e "\nPress [enter] key to continue. . ."
     		read enterKey;;
	esac
done