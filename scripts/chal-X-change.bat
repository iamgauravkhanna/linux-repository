@echo off
echo.
echo #####################################################################
echo #                                                                   #
echo #           ::    WELCOME TO chal-X-change v0.1    ::               #
echo #                                                                   #
echo #                                                                   #
echo #####################################################################

rem The tool chal-X-change is an automated tool which peforms following task:
rem 1- Build the latest code update on local machine
rem 2- Drop and re-create the exchange database (In progress, Delivery in next version)
rem 3- Deletes the log/work folders and start the apache tomcat server

:: Variables Definition
SET LOG_LOCATION=C:\Users\Gaurav\Desktop\chal-X-change.log
SET BUILD_DIR=C:\code\parent-build

:: Change directory from where code need to be build

cd "%BUILD_DIR%"

echo.
echo ============================================
echo	1) COMPILATION OF LATEST CODE USING MAVEN
echo ============================================
echo.

:: Below commands do following job:
:: 1- Compile the code using maven command
:: 2- Capture the Exit code of last executed command
:: 3- A non-zero exit code signify that last executed command is failed else it is successful.

echo [PROGRESSING] :: service-deps :: > CON
call mvn -Dmaven.test.skip=true clean install -f service-deps.pom > "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: service-deps ::) else (echo [FAILED] :: service-deps ::)
echo.
echo [PROGRESSING] :: web-deps :: > CON
call mvn -Dmaven.test.skip=true clean install -f web-deps.pom >> "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: web-deps ::) else (echo [FAILED] :: web-deps ::)
rem echo.
rem echo [PROGRESSING] :: CSR :: > CON
rem call mvn -Dmaven.test.skip=true clean install -f pom-csr.xml >> "%LOG_LOCATION%" 2>&1
rem if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: CSR ::) else (echo [FAILED] :: CSR ::)
echo.
echo [PROGRESSING] :: INDIVIDUAL :: > CON
call mvn -Dmaven.test.skip=true clean install -f pom-indv-public.xml >> "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: INDIVIDUAL ::) else (echo [FAILED] :: INDIVIDUAL ::)
echo.
echo [PROGRESSING] :: EMPLOYER :: > CON
call mvn -Dmaven.test.skip=true clean install -f pom-sb-public.xml >> "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: EMPLOYER ::) else (echo [FAILED] :: EMPLOYER ::)
echo.
echo ============================================
echo	2) DROP AND RE-CREATTION OF EXCHANGE DB
echo ============================================
echo.
echo [PROGRESSING] :: DATABASE ::
echo.
cd "C:\code\db\mysql"
mysql -u root -e "drop database if exists pbex;create database pbex;use pbex;SET storage_engine=MYISAM;set autocommit=0;source createpublicdb.sql;"  
echo.
echo ============================================
echo	3) RENAMING FILE NAME
echo ============================================
echo.
cd \code\applications\individual-webapp-public\target\
ren individual-webapp-public-3.0.10-SNAPSHOT individual
cd \code\applications\employer-public\target\
ren employer-public-3.0.10-SNAPSHOT employer
echo.
echo ============================================
echo	4) LOGS/WORK DELETION & TOMCAT START-UP
echo ============================================
echo.

del c:\apache-tomcat-6.0.20\logs\* /Q
echo [DELETED] :: Contents of Logs folder ::
rd /S c:\apache-tomcat-6.0.20\work /Q
echo [DELETED] :: Work folder ::
echo.
echo Be Ready ! TOMCAT WILL START NOW...
timeout 5
cd c:\apache-tomcat-6.0.20\bin
PAUSE
startup.bat