@echo off
echo.
echo #####################################################################
echo #                                                                  
echo #             Local Tomcat : C:\hcentive-code\local\private-exchange
echo #                                                                  
echo #                                                                  
echo #####################################################################

:: Variables Definition
del "C:\logs\private-exchange.log" /Q
SET LOG_LOCATION=C:\logs\private-exchange.log
SET CODE_BASE=C:\hcentive-code\local\phix
SET BUILD_DIR=%CODE_BASE%\build

echo.
echo ============================================
echo	1) Code Compilation in Progress...
echo ============================================
echo.

cd %BUILD_DIR%

echo [PROGRESSING] :: build-compilation :: > CON
call mvn clean install -f build-all-pom.xml >> "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: build-compilation ::) else (echo [FAILED] :: build-compilation ::)
echo.

cd %CODE_BASE%\build-db

echo [PROGRESSING] :: applying-db-patches :: > CON
call mvn clean install -P phix >> "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: applying-db-patches ::) else (echo [FAILED] :: applying-db-patches ::)
echo.

PAUSE