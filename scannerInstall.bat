@echo off

@rem Detect if batch opened as administrator, found at https://stackoverflow.com/questions/4051883/batch-script-how-to-check-for-admin-rights
echo OFF
NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    echo.
    echo Administrator PRIVILEGES Detected! 
    echo ##########################################################
    echo.
    GOTO CHECKPLEX
) ELSE (
    echo.
    echo ####### ERROR: ADMINISTRATOR PRIVILEGES REQUIRED #########
    echo This script must be run as administrator to work properly!  
    echo To run as administrator, right click on the batch file and 
    echo click "Run As Administrator".
    echo ##########################################################
    echo.
    pause
    EXIT /B 1
)

:CHECKPLEX
IF NOT EXIST "%LOCALAPPDATA%\Plex Media Server" (
    GOTO PLEXNOTINSTALLED
) ELSE (
echo Plex is installed!
echo ##########################################################
echo.
GOTO CHOICE
)

:PLEXNOTINSTALLED
echo ######## ERROR: Plex installation was not found ##########
echo Please ensure the Plex Media Server is installed before
echo running this script. The installation file can be found at
echo https://www.plex.tv/media-server-downloads/
echo Plex Media Server will need to run at least once to create
echo files needed to be modified.
echo ##########################################################
echo.
pause
EXIT /B 1

:CHOICE
set /P c=Are you sure you want to install the anime scanner for Plex [Y/N]? 
if /I "%c%" EQU "Y" goto :INSTALL
if /I "%c%" EQU "N" goto :NOINSTALL

:INSTALL
echo "Plex Anime Scanner will now be installed."
pause
EXIT /B 1

:NOINSTALL
echo "Plex Anime Scanner has not been installed."
pause
EXIT /B 1