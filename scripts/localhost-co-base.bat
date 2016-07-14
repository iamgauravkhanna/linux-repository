@echo off
echo.
echo #####################################################################
echo #                                                                   
echo #             Local Tomcat : C:\hcentive-code\local\COHIX_Base
echo #                                                                   
echo #                                                                   
echo #####################################################################

:: Variables Definition
del "C:\logs\COHIX_Base-Local.log" /Q
SET LOG_LOCATION=C:\logs\COHIX_Base-Local.log
SET CODE_BASE=C:\hcentive-code\local\COHIX_Base
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

:: cd %BUILD_DIR%\agent-build-hix

:: echo [PROGRESSING] :: agent-hix :: > CON
:: #call mvn -Dmaven.test.skip=true clean install >> "%LOG_LOCATION%" 2>&1
:: #if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: agent-hix ::) else (echo [FAILED] :: agent-hix ::)
:: #echo.

cd %BUILD_DIR%\individual-build-hix

echo [PROGRESSING] :: individual-hix-portal :: > CON
call mvn -Dmaven.test.skip=true clean install >> "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: individual-hix-portal ::) else (echo [FAILED] :: individual-hix-portal ::)
echo.

cd %CODE_BASE%\applications\individual-hix-jobs

echo [PROGRESSING] :: individual-jobs :: > CON
call mvn -Dmaven.test.skip=true clean install >> "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: individual-jobs ::) else (echo [FAILED] :: individual-jobs ::)
echo.

cd %CODE_BASE%\applications\shop-jobs

echo [PROGRESSING] :: shop-jobs :: > CON
call mvn -Dmaven.test.skip=true clean install >> "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: shop-jobs ::) else (echo [FAILED] :: shop-jobs ::)
echo.

PAUSE