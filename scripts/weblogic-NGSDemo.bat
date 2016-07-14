@echo off
echo.
echo #####################################################################
echo #                                                                   
echo #             Weblogic Code Compilation : C:\hcentive-code\server\NGSDemo      
echo #                                                                   
echo #                                                                   
echo #####################################################################

:: Variables Definition
del "C:\logs\server-NGSDemo.log" /Q
SET LOG_LOCATION=C:\logs\server-NGSDemo.log
SET CODE_BASE=C:\hcentive-code\server\NGSDemo
SET BUILD_DIR=%CODE_BASE%\build

echo.
echo ============================================
echo	1) Code Compilation in Progress...
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

cd %BUILD_DIR%\agent-build-hix

echo [PROGRESSING] :: agent-hix :: > CON
call mvn clean install -Dserver=weblogic -f pom.xml -P prod >> "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: agent-hix ::) else (echo [FAILED] :: agent-hix ::)
echo.

cd %CODE_BASE%\applications\individual-hix-jobs

echo [PROGRESSING] :: individual-jobs :: > CON
call mvn clean install -Dserver=weblogic -f pom.xml -P prod >> "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: individual-jobs ::) else (echo [FAILED] :: individual-jobs ::)
echo.

cd %CODE_BASE%\build\shop-job-build

echo [PROGRESSING] :: shop-jobs :: > CON
call mvn clean install -Dserver=weblogic -f pom.xml -P prod >> "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: shop-jobs ::) else (echo [FAILED] :: shop-jobs ::)
echo.

PAUSE