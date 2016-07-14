@echo off
echo.
echo #####################################################################
echo #                                                                   
echo #             Local Tomcat : C:\hcentive-code\local\cohix
echo #                                                                   
echo #                                                                   
echo #####################################################################

:: Variables Definition
del "C:\logs\local-cohix.log" /Q
SET LOG_LOCATION=C:\logs\local-cohix.log
SET CODE_BASE=C:\hcentive-code\local\co-trunk
SET BUILD_DIR=%CODE_BASE%\build

echo.
echo ============================================
echo	1) Code Compilation in Progress...
echo ============================================
echo.

cd %BUILD_DIR%\co-individual-build

echo [PROGRESSING] :: CO Individual - Productization :: > CON
call mvn clean install -f pom.xml >> "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: individual-hix ::) else (echo [FAILED] :: individual-hix ::)
echo.

:: cd %BUILD_DIR%\co-shop-build

:: echo [PROGRESSING] :: CO SHOP - Productization :: > CON
:: call mvn clean install -f pom.xml >> "%LOG_LOCATION%" 2>&1
:: if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: shop-hix ::) else (echo [FAILED] :: shop-hix ::)
:: echo.

:: cd %BUILD_DIR%\co-agent-build

:: echo [PROGRESSING] :: CO Agent - Productization :: > CON
:: call mvn clean install -f pom.xml >> "%LOG_LOCATION%" 2>&1
:: if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: agent-hix ::) else (echo [FAILED] :: agent-hix ::)
:: echo.

cd %CODE_BASE%\applications\co-shop-jobs

:: echo [PROGRESSING] :: shop-jobs :: > CON
:: call mvn clean install -f pom.xml >> "%LOG_LOCATION%" 2>&1
:: if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: shop-jobs ::) else (echo [FAILED] :: shop-jobs ::)
:: echo.

PAUSE