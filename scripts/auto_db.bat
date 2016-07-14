@echo off
SET CODE_BASE=C:\hcentive-code\code\db\oracle
SET BUILD_DIR=%CODE_BASE%\ddl
cd %CODE_BASE%
echo drop user pbex_user cascade; | sqlplus system/Oracle1234@xe
echo create user pbex_user identified by pbex_user;  | sqlplus system/Oracle1234@xe
echo grant dba, create any table, create any sequence, drop any sequence, drop any table to pbex_user; | sqlplus system/Oracle1234@xe
echo spool pbex_user.log ;  | sqlplus pbex_user/pbex_user@xe
echo @createpublicdb.sql; | sqlplus pbex_user/pbex_user@xe
cd %BUILD_DIR%
echo drop user pbex_job cascade; | sqlplus system/Oracle1234@xe
echo create user pbex_job identified by pbex_job;  | sqlplus system/Oracle1234@xe
echo grant dba, create any table, create any sequence, drop any sequence, drop any table to pbex_job;  | sqlplus system/Oracle1234@xe
echo @batchJobsRepoSchema.sql;  | sqlplus pbex_job/pbex_job@xe