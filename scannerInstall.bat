@echo off

@rem Detect if batch opened as administrator, found at https://stackoverflow.com/questions/4051883/batch-script-how-to-check-for-admin-rights
NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    echo.
    echo Administrator PRIVILEGES Detected! 
    echo ----------------------------------------------------------
    echo.
    GOTO CHECKPLEX
) ELSE (
    echo.
    echo ####### ERROR: ADMINISTRATOR PRIVILEGES REQUIRED #########
    echo This script must be run as administrator to work properly!  
    echo To run as administrator, right click on the batch file and 
    echo click "Run As Administrator".
    echo ----------------------------------------------------------
    echo.
    pause
    EXIT /B 1
)

:CHECKPLEX
IF NOT EXIST "%LOCALAPPDATA%\Plex Media Server" (
    GOTO PLEXNOTINSTALLED
) ELSE (
    echo Plex is installed!
    echo ----------------------------------------------------------
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
echo ----------------------------------------------------------
echo.
pause
EXIT /B 1

:CHOICE
set /P c=Are you sure you want to install the anime scanner for Plex [Y/N]? 
if /I "%c%" EQU "Y" goto :CHECKSCANNER
if /I "%c%" EQU "N" goto :NOINSTALL

:CHECKSCANNER
echo.
echo Scanning for zip files in directory %~dp0
echo ----------------------------------------------------------
IF NOT EXIST "%~dp0\Absolute-Series-Scanner-master.zip" (
    set /A zip1=0
	GOTO CHECKHAMA
) ELSE (
    set /A zip1=1
	GOTO CHECKHAMA	
)

:CHECKHAMA

IF NOT EXIST "%~dp0\Hama.bundle-master.zip" (
    set /A zip2=0
	GOTO DOWNLOADCONFIRM
) ELSE (
    set /A zip2=1
	GOTO DOWNLOADCONFIRM	
)

:DOWNLOADCONFIRM
IF %zip1%==0 (
echo NOT found: Absolute-Series-Scanner-master.zip
) ELSE (
echo Found: 	Absolute-Series-Scanner-master.zip
)
IF %zip2%==0 (
echo NOT found: Hama.bundle-master.zip
) ELSE (
echo Found: 	Hama.bundle-master.zip
)

IF %zip1%==1 (
	IF %zip2%==1 (
		echo.
		echo Both zip files found!
		echo ----------------------------------------------------------
		GOTO INSTALL
	)
)
GOTO MISSINGFILES

:MISSINGFILES
echo.
set /P c=Would you like to download the missing zip files [Y/N]? 
if /I "%c%" EQU "Y" goto :DOWNLOAD
if /I "%c%" EQU "N" goto :NOINSTALL

:DOWNLOAD

IF %zip1%==0 (
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/ZeroQI/Absolute-Series-Scanner/archive/master.zip', '%~dp0\Absolute-Series-Scanner-master.zip')"
powershell -Command "Invoke-WebRequest https://github.com/ZeroQI/Absolute-Series-Scanner/archive/master.zip -OutFile %~dp0\Absolute-Series-Scanner-master.zip"
)
IF %zip2%==0 (
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/ZeroQI/Hama.bundle/archive/master.zip', '%~dp0\Hama.bundle-master.zip')"
powershell -Command "Invoke-WebRequest https://github.com/ZeroQI/Hama.bundle/archive/master.zip -OutFile %~dp0\Hama.bundle-master.zip"
)

GOTO CHECKSCANNER

:INSTALL
tar -xf %~dp0\Hama.bundle-master.zip -C %~dp0
tar -xf %~dp0\Absolute-Series-Scanner-master.zip -C %~dp0
echo.
echo Extracted
echo --------------

REN %~dp0\Hama.bundle-master Hama.bundle
echo.
echo Renamed
echo ---------------------------

xcopy /s /e /i "%~dp0\Hama.bundle" "%LOCALAPPDATA%\Plex Media Server\Plug-ins\Hama.bundle"
xcopy /s /e "%~dp0\Absolute-Series-Scanner-master" "%LOCALAPPDATA%\Plex Media Server\"
pause
EXIT /B 1

:NOINSTALL
echo "Plex Anime Scanner has not been installed."
pause
EXIT /B 1