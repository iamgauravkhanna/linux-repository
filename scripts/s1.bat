@echo off
cls
echo.
echo #####################################################################
echo #                                                                   
echo #             Welcome
echo #                                                                   
echo #                                                                   
echo #####################################################################

SET LOG_LOCATION=C:\logs\welcome.log
echo 
echo %LOG_LOCATION%
echo 
echo [PROGRESSING] :: build-tools :: > CON 
call mvn >> "%LOG_LOCATION%" 2>&1

if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: build-tools ::) else (echo [FAILED] :: build-tools ::)

echo "ERROR LEVEL : %ERRORLEVEL%"

PAUSE

echo [PROGRESSING] :: second :: > CON


call mvn >> "%LOG_LOCATION%" 2>&1

if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: second ::) else (echo [FAILED] :: second ::)

echo "ERROR LEVEL : %ERRORLEVEL%"