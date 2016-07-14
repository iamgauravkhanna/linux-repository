@echo off
echo.
echo #####################################################################
echo #                                                                   #
echo #           ::    WELCOME TO Xdoow v0.1    ::               #
echo #                                                                   #
echo #                                                                   #
echo #####################################################################

rem Developed By RAVI MOTWANI

rem This script aims to compile the build for deployment on Oracle-Weblogic Platform.

:: Variables Definition
del "C:\Xdoow\Xdoow_build.log" /Q
SET LOG_LOCATION=C:\i\Xdoow_build.log
SET CODE_BASE=C:\code
SET BUILD_DIR=%CODE_BASE%\build

echo.
echo ============================================
echo	1) COMPILATION OF LATEST CODE USING MAVEN
echo ============================================
echo.

::cd %CODE_BASE%\build\build-tools
::call mvn -Dmaven.test.skip=true clean install -f pom.xml > "%LOG_LOCATION%" 2>&1

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

echo [PROGRESSING] :: INDIVIDUAL :: > CON
call mvn clean install -Dserver=weblogic -P prod -f pom.xml >> "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: INDIVIDUAL ::) else (echo [FAILED] :: INDIVIDUAL ::)
echo.

cd %BUILD_DIR%\shop-build-hix

echo [PROGRESSING] :: SHOP :: > CON
call mvn clean install -Dserver=weblogic -P prod -f pom.xml >> "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: SHOP ::) else (echo [FAILED] :: SHOP ::)
echo.

cd %BUILD_DIR%\agent-build-hix

echo [PROGRESSING] :: AGENT :: > CON
call mvn clean install -Dserver=weblogic -P prod -f pom.xml >> "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: AGENT ::) else (echo [FAILED] :: AGENT ::)
echo.

cd %CODE_BASE%\modules\shop

echo [PROGRESSING] :: SMALL-GROUP-INITIAL :: > CON
call mvn -Dmaven.test.skip=true clean install –P prod –f pom.xml >> "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: SMALL-GROUP-INITIAL ::) else (echo [FAILED] :: SMALL-GROUP-INITIAL ::)
echo.

cd %CODE_BASE%\applications\shop-jobs

echo [PROGRESSING] :: SMALL-GROUP-FINAL :: > CON
call mvn -Dmaven.test.skip=true clean install –P prod –f pom.xml >> "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: SMALL-GROUP-FINAL ::) else (echo [FAILED] :: SMALL-GROUP-FINAL ::)
echo.
pause