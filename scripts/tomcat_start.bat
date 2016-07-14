echo off
echo.
echo ============================================
echo	Starting Tomcat
echo ============================================
echo.

del c:\apache-tomcat-6.0.20\logs\* /Q

echo [DELETED] :: Contents of Logs folder ::

rd /S c:\apache-tomcat-6.0.20\work /Q

echo [DELETED] :: Work folder ::

echo.

echo Be Ready ! TOMCAT WILL START NOW...

timeout 6

cd c:\apache-tomcat-6.0.20\bin

PAUSE

startup.bat