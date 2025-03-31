@echo off
title YOUTUBE DOWNLOADER
chcp 65001 >nul
setlocal enabledelayedexpansion

:: Clear screen
cls

:: Display ASCII Art
echo.
echo.       
echo.	██╗   ██╗██╗██████╗ ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     
echo.	██║   ██║██║██╔══██╗██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     
echo. 	██║   ██║██║██║  ██║██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     
echo. 	╚██╗ ██╔╝██║██║  ██║██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     
echo. 	╚████╔╝ ██║██████╔╝██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗
echo. 	  ╚═══╝  ╚═╝╚═════╝ ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝
                                                                          

echo.
echo -------------------------------------------------------------------
echo   Welcome to the YouTube Downloader! Powered by TurtleNopes
echo -------------------------------------------------------------------
echo.

:: Check if yt-dlp is installed
where yt-dlp >nul 2>nul
if %errorlevel% neq 0 (
    echo YT-DLP is not installed.
    echo Press ENTER to install YT-DLP...
    pause >nul
    echo Installing YT-DLP...
    curl -Lo yt-dlp.exe https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe
    echo YT-DLP installed successfully!
)

:: Check if ffmpeg is installed
where ffmpeg >nul 2>nul
if %errorlevel% neq 0 (
    echo FFMPEG is not installed.
    echo Press ENTER to install FFMPEG...
    pause >nul
    echo Downloading FFMPEG...
    curl -Lo ffmpeg.zip https://github.com/BtbN/FFmpeg-Builds/releases/latest/download/ffmpeg-n4.4-win64-lgpl.zip
    powershell -command "Expand-Archive -Path ffmpeg.zip -DestinationPath . -Force"
    move /Y ffmpeg-*/bin/ffmpeg.exe .
    del ffmpeg.zip
    echo FFMPEG installed successfully!
)

:: Ask for YouTube link
set /p yt_link=Enter YouTube link: 
if "%yt_link%"=="" (
    echo No link entered. Exiting...
    exit /b
)

:: Fetch video details
for /f "tokens=*" %%i in ('yt-dlp --get-title --get-duration "%yt_link%"') do (
    if not defined title (
        set "title=%%i"
    ) else (
        set "duration=%%i"
    )
)

:: Display video details
echo.
echo -------------------------------------------------------------------
echo  Title       : %title%
echo  Duration    : %duration%
echo -------------------------------------------------------------------
echo.

:: Ask for format choice
echo Choose format:
echo [1] Video (MP4)
echo [2] Audio (MP3)
set /p choice=Enter 1 or 2: 

:: Set output folder (Videos directory)
set output_folder=%USERPROFILE%\Videos

if "%choice%"=="1" (
    echo Downloading video...
    yt-dlp -o "%output_folder%\%%(title)s.%%(ext)s" "%yt_link%"
) else if "%choice%"=="2" (
    echo Downloading audio...
    yt-dlp -x --audio-format mp3 -o "%output_folder%\%%(title)s.%%(ext)s" "%yt_link%"
) else (
    echo Invalid choice. Exiting...
    exit /b
)

echo Download complete! Saved in %output_folder%
pause
