@echo off
REM Check and repair disk, system file, and image corruption

echo (1/4) Running CHKDSK...
chkdsk /scan
if %errorlevel% neq 0 (
    echo CHKDSK encountered errors. Please check the output for details.
    pause
    exit /b
)

echo.
echo (2/4) Running SFC - First Scan...
sfc /scannow
if %errorlevel% neq 0 (
    echo SFC encountered errors. Please check the output for details.
    pause
    exit /b
)

echo.
echo (3/4) Running DISM to repair the system image...
dism /online /cleanup-image /restorehealth
if %errorlevel% neq 0 (
    echo DISM encountered errors. Please check the output for details.
    pause
    exit /b
)

echo.
echo (4/4) Running SFC - Second Scan...
sfc /scannow
if %errorlevel% neq 0 (
    echo SFC encountered errors. Please check the output for details.
    pause
    exit /b
)

echo.
echo All checks completed successfully. Your system should now be repaired.
pause