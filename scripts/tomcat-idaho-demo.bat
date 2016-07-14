@echo off
echo.
echo #####################################################################
echo #                                                                   #
echo #           ::    Building idaho-demo    ::                         #
echo #                                                                   #
echo #                                                                   #
echo #####################################################################

:: Variables Definition
del "C:\logs\idaho-demo.log" /Q
SET LOG_LOCATION=C:\logs\idaho-demo.log
SET CODE_BASE=C:\hcentive-code\idaho-demo
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

cd %BUILD_DIR%\agent-build-hix

echo [PROGRESSING] :: AGENT :: > CON
call mvn clean install -f pom.xml >> "%LOG_LOCATION%" 2>&1
if "%ERRORLEVEL%" == "0" (echo [SUCCESSFUL]  :: AGENT ::) else (echo [FAILED] :: AGENT ::)
echo.

pause