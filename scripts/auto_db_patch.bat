@echo off
SET CODE_BASE=C:\code_patch\db\oracle
SET BUILD_DIR=%CODE_BASE%\ddl
cd %CODE_BASE%
echo drop user pbex_user cascade; | sqlplus system/Oracle123@oracledb
echo create user pbex_user identified by pbex_user;  | sqlplus system/Oracle123@oracledb
echo grant dba, create any table, create any sequence, drop any sequence, drop any table to pbex_user; | sqlplus system/Oracle123@oracledb
echo spool pbex_user.log ;  | sqlplus pbex_user/pbex_user@oracledb
echo @createpublicdb.sql; | sqlplus pbex_user/pbex_user@oracledb
cd %BUILD_DIR%
echo drop user pbex_job cascade; | sqlplus system/Oracle123@oracledb
echo create user pbex_job identified by pbex_job;  | sqlplus system/Oracle123@oracledb
echo grant dba, create any table, create any sequence, drop any sequence, drop any table to pbex_job;  | sqlplus system/Oracle123@oracledb
echo @batchJobsRepoSchema.sql;  | sqlplus pbex_job/pbex_job@oracledb