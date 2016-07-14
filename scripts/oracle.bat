@echo off
echo.
echo #####################################################################
echo #                                                                   #
echo #           ::    Starting WebLogic Services    ::                  #
echo #                                                                   #
echo #                                                                   #
echo #####################################################################
net start OracleServiceORACLEDB
net start OracleOraDb11g_home1TNSListener
pause