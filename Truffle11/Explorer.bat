@echo off
setlocal

REM -------------------------------
REM Variables
REM -------------------------------
set "taskbarPinned=%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"
set "taskbandReg=HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband"
set "nilesoftSource=C:\Windows\Setup\Post-Setup\Miscellaneous\Nilesoft Shell"
set "nilesoftDest=C:\Program Files\Nilesoft Shell\imports"
set "postSetupTarget=C:\Windows\Setup\Post-Setup"
set "postSetupShortcut=%USERPROFILE%\Desktop\Post-Setup.lnk"

REM -------------------------------
REM Remove all pinned items
REM -------------------------------
echo [*] Removing all pinned items from taskbar...
del /f /s /q "%taskbarPinned%\*" >nul 2>&1
reg delete "%taskbandReg%" /f >nul 2>&1
echo [OK] All taskbar pinned items removed.

REM -------------------------------
REM Copy Nilesoft Shell files
REM -------------------------------
echo [*] Copying Nilesoft Shell files...
if exist "%nilesoftSource%" (
    robocopy "%nilesoftSource%" "%nilesoftDest%" /E /NFL /NDL /NJH /NJS /NC /NS /NP >nul
    if %ERRORLEVEL% LSS 8 (
        echo [OK] Nilesoft Shell files copied.
    ) else (
        echo [!] Robocopy failed with errorlevel %ERRORLEVEL%.
    )
) else (
    echo [!] Nilesoft source folder not found: %nilesoftSource%
)

REM -------------------------------
REM Create Post-Setup desktop shortcut
REM -------------------------------
if not exist "%USERPROFILE%\Desktop" (
    echo [!] Desktop folder not found.
) else (
    echo [*] Creating Post-Setup desktop shortcut...
    powershell -NoProfile -Command "$ws = New-Object -ComObject 'WScript.Shell'; $s = $ws.CreateShortcut('%postSetupShortcut%'); $s.TargetPath='%postSetupTarget%'; $s.WorkingDirectory='%postSetupTarget%'; $s.IconLocation='shell32.dll,3'; $s.Save()"
    if exist "%postSetupShortcut%" (
        echo [OK] Shortcut created: %postSetupShortcut%
    ) else (
        echo [!] Failed to create shortcut.
    )
)

REM -------------------------------
REM Restart Explorer
REM -------------------------------
echo [*] Restarting Explorer to apply changes...
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 3 >nul
start explorer.exe
timeout /t 2 >nul

REM -------------------------------
REM Done
REM -------------------------------
echo.
echo =======================================
echo    All tasks completed successfully.
echo   Reboot your PC to finalize changes.
echo =======================================
echo.
pause
endlocal
