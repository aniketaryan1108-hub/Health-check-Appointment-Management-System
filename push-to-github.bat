@echo off
setlocal
cd /d "%~dp0"

set REPO_NAME=Aniket
set GIT_EXE=

if exist "C:\Program Files\Git\bin\git.exe" set "GIT_EXE=C:\Program Files\Git\bin\git.exe"
if exist "C:\Program Files (x86)\Git\bin\git.exe" set "GIT_EXE=C:\Program Files (x86)\Git\bin\git.exe"

if "%GIT_EXE%"=="" (
    echo Git is not installed.
    echo Download from: https://git-scm.com/download/win
    echo Then run this script again.
    pause
    exit /b 1
)

echo Using Git: %GIT_EXE%
echo.

if not exist ".git" (
    "%GIT_EXE%" init
    "%GIT_EXE%" branch -M main
)

"%GIT_EXE%" add .
"%GIT_EXE%" status

echo.
set /p CONFIRM=Commit and push to GitHub repo "%REPO_NAME%"? (Y/N): 
if /i not "%CONFIRM%"=="Y" exit /b 0

"%GIT_EXE%" commit -m "Health Check Appointment Management System - complete project"

echo.
echo Create repo on GitHub first: https://github.com/new
echo   Repository name: %REPO_NAME%
echo   Do NOT add README if you push existing code
echo.
set /p GITHUB_USER=Enter your GitHub username: 

"%GIT_EXE%" remote remove origin 2>nul
"%GIT_EXE%" remote add origin https://github.com/%GITHUB_USER%/%REPO_NAME%.git
"%GIT_EXE%" push -u origin main

if errorlevel 1 (
    echo.
    echo Push failed. Try:
    echo   1. Create repo https://github.com/new named %REPO_NAME%
    echo   2. Login: gh auth login   OR use GitHub Desktop
    echo   3. Run this script again
) else (
    echo.
    echo SUCCESS! Repo: https://github.com/%GITHUB_USER%/%REPO_NAME%
)

pause
