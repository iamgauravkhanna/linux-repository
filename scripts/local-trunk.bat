@echo off
echo.
echo #####################################################################
echo #                                                                   #
echo #             PMS Build Module - local-trunk                        #
echo #                                                                   #
echo #                                                                   #
echo #####################################################################


del "C:\logs\local-trunk.log" /Q
SET LOG_LOCATION=C:\logs\local-trunk.log
SET PROD_BASE=C:\hcentive-code\private-exchange
SET PMS_BASE=C:\hcentive-code\trunk

echo.
:: echo xxxxxxxxxxxxx	Building Product Part	xxxxxxxxxxxxx
:: echo.
:: 
:: cd %PROD_BASE%\build\build-tools

:: echo [PROGRESSING] :: build-tools :: > CON
:: call mvn -Dmaven.test.skip=true clean install -f pom.xml > "%LOG_LOCATION%" 2>&1
:: if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: build-tools ::) else (echo [FAILED] :: build-tools ::)
:: echo.

:: cd %PROD_BASE%\build

:: echo [PROGRESSING] :: service-deps :: > CON
:: call mvn -Dmaven.test.skip=true clean install -f service-deps.pom >> "%LOG_LOCATION%" 2>&1
:: if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: service-deps ::) else (echo [FAILED] :: service-deps ::)
:: echo.
:: echo [PROGRESSING] :: web-deps :: > CON
:: call mvn -Dmaven.test.skip=true clean install -f web-deps.pom >> "%LOG_LOCATION%" 2>&1
:: if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: web-deps ::) else (echo [FAILED] :: web-deps ::)
:: echo.

:: cd %PROD_BASE%\build\individual-build-hix

:: echo [PROGRESSING] :: individual-hix :: > CON
:: call mvn clean install -f pom.xml >> "%LOG_LOCATION%" 2>&1
:: if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: indv-hix ::) else (echo [FAILED] :: indv-hix ::)
:: echo.

echo xxxxxxxxxxxxx	Building PMS Part	xxxxxxxxxxxxx
echo.

cd %PMS_BASE%\build\build-tools

echo [PROGRESSING] :: pms-build-tools :: > CON
call mvn -Dmaven.test.skip=true clean install -f pom.xml > "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: pms-build-tools ::) else (echo [FAILED] :: pms-build-tools ::)
echo.

cd %PMS_BASE%\build\

echo [PROGRESSING] :: service-deps :: > CON
call mvn -Dmaven.test.skip=true clean install -f service-deps.pom >> "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: service-deps ::) else (echo [FAILED] :: service-deps ::)
echo.

echo [PROGRESSING] :: web-deps :: > CON
call mvn -Dmaven.test.skip=true clean install -f web-deps.pom >> "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: web-deps ::) else (echo [FAILED] :: web-deps ::)
echo.

cd %PMS_BASE%\build\pms-build
echo [PROGRESSING] :: pms-build :: > CON
call mvn clean install -f pom.xml >> "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: pms-build ::) else (echo [FAILED] :: pms-build ::)
echo.

cd %PMS_BASE%\modules\pms-web
echo [PROGRESSING] :: pms-job :: > CON
call mvn clean install -f pom.xml >> "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: pms-job ::) else (echo [FAILED] :: pms-job ::)
echo.

PAUSE