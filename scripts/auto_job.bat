@echo off
echo.
echo #####################################################################
echo #                                                                   #
echo #           ::    Starting Individual Batch Jobs   ::               #
echo #                                                                   #
echo #                                                                   #
echo #####################################################################

move "C:\code\applications\individual-hix-jobs\target\individualJob" "c:\j\a"

pause

move "c:\j\bin\logback.xml" "c:\j\a\individualJob\bin"

pause

rd /S c:\j\bin /Q

pause

rd /S c:\j\repo /Q

pause

move "c:\j\a\individualJob\bin" "c:\j"

pause

move "c:\j\a\individualJob\repo" "c:\j"

pause

cd "c:\j\bin"

pause