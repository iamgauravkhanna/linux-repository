#!/bin/sh
master_user="hixqa1"
master_pass="hc2nt1v2"
db_identifier="publicdb"
oracle_artifact=$2
module=$3
upload_dir=/mnt/upload
dbname=$1
				echo " Database Name is $dbname and Module is $module \n"
				cd $upload_dir/pbex_backup
				rm -rf oracle
                cd $upload_dir/pbex_current
                mv oracle $upload_dir/pbex_backup
                tar -xzf $oracle_artifact
                chmod -R 777 oracle
                echo " DB creation started \n"
su - oracle  <<EOF
cd $upload_dir/pbex_current/oracle

sqlplus -S $master_user/$master_pass@$db_identifier <<EOF
 drop user $dbname cascade;
 create user $dbname identified by $dbname;
 grant dba, create any table, create any sequence, drop any sequence, drop any table to $dbname;
  exit;
EOF
EOF

		if [ "$module" = "application" ];then

su - oracle  <<EOF
cd $upload_dir/pbex_current/oracle


sqlplus -S $dbname/$dbname@$db_identifier <<EOF
spool pbex_db.log
@createpublicdb.sql;
exit;
EOF

		else
	su - oracle  <<EOF
cd $upload_dir/pbex_current/oracle/ddl


sqlplus -S $dbname/$dbname@$db_identifier <<EOF
spool pbex_db.log
@batchJobsRepoSchema.sql;
exit;
EOF
		fi