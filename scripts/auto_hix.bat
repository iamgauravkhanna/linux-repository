@echo off
echo.
echo #####################################################################
echo #                                                                   #
echo #           ::    Starting Auto HIX   ::                            #
echo #                                                                   #
echo #                                                                   #
echo #####################################################################

:: Variables Definition
del "C:\logs\indvApplication.log" /Q
SET LOG_LOCATION=C:\logs\indvApplication.log
SET CODE_BASE=C:\hcentive-code\code
SET BUILD_DIR=%CODE_BASE%\build

echo.
echo ============================================
echo	1) CODE COMPILATION
echo ============================================
echo.

echo [PROGRESSING] :: build-tools :: > CON
cd %CODE_BASE%\build\build-tools
call mvn -Dmaven.test.skip=true clean install -f pom.xml > "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: build-tools ::) else (echo [FAILED] :: build-tools ::)
echo.

cd "%BUILD_DIR%"

echo [PROGRESSING] :: service-deps :: > CON
call mvn -Dmaven.test.skip=true clean install -f service-deps.pom >> "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: service-deps ::) else (echo [FAILED] :: service-deps ::)
echo.
echo [PROGRESSING] :: web-deps :: > CON
call mvn -Dmaven.test.skip=true clean install -f web-deps.pom >> "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: web-deps ::) else (echo [FAILED] :: web-deps ::)
echo.

cd %BUILD_DIR%\individual-build-hix

echo [PROGRESSING] :: individual-hix :: > CON
call mvn clean install -f pom.xml >> "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: individual-hix ::) else (echo [FAILED] :: individual-hix ::)
echo.

cd %CODE_BASE%\applications\individual-hix-jobs

echo [PROGRESSING] :: individual-jobs :: > CON
call mvn clean install -f pom.xml >> "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: individual-jobs ::) else (echo [FAILED] :: individual-jobs ::)
echo.

echo ============================================
echo	2) RENAMING FILE NAME
echo ============================================
echo.
cd \code\applications\individual-hix-portal\target
ren individual-webapp-public-3.2.0 individual
echo [SUCCESSFUL]  :: FOLDER RENAMED ::
echo.

echo ==================================================
echo	3) LOGS/WORK FOLDER DELETION 
echo ==================================================
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