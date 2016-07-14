#!/bin/bash

#####################################################################################
##  aws3 : This script will untar the files					      ##
#####################################################################################


cd /mnt/upload

sudo chmod -R 777 *

sudo tar -zxvf individual.tar

sudo tar -zxvf agent.tar

sudo tar -zxvf employer.tar

sudo tar -zxvf config.tar

sudo tar -zxvf smallgroup.tar

sudo chmod -R 777 *