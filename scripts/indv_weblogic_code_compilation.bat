@echo off
echo.
echo #####################################################################
echo #                                                                   #
echo #           ::    Building Individual Portal    ::                  #
echo #                                                                   #
echo #                                                                   #
echo #####################################################################

rem This script aims to compile the build for deployment on Oracle-Weblogic Platform.

:: Variables Definition
del "C:\logs\indvApplication.log" /Q
SET LOG_LOCATION=C:\logs\indvApplication.log
SET CODE_BASE=C:\code
SET BUILD_DIR=%CODE_BASE%\build

echo.
echo ============================================
echo	1) Compiling. Please Wait . . . . . .
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

echo [PROGRESSING] :: INDIVIDUAL :: > CON
call mvn clean install -Dserver=weblogic -f pom.xml >> "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: INDIVIDUAL ::) else (echo [FAILED] :: INDIVIDUAL ::)
echo.

cd %CODE_BASE%\applications\individual-hix-jobs

echo [PROGRESSING] :: INDIVIDUAL JOBS :: > CON
call mvn clean install -Dserver=weblogic -f pom.xml >> "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: INDIVIDUAL JOBS ::) else (echo [FAILED] :: INDIVIDUAL JOBS ::)
echo.

pause