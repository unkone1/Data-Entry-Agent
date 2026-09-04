@echo off
title NIELIT Data Entry Agent - Web UI
color 0A
cls
echo.
echo  ============================================
echo   NIELIT Data Entry Agent  -  Web Interface
echo  ============================================
echo.
echo  Starting server...
echo  Browser will open automatically.
echo.
echo  If browser does NOT open, go to:
echo    http://127.0.0.1:5000
echo.
echo  Press Ctrl+C to stop the server.
echo  ============================================
echo.

REM Kill any old instance on port 5000
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":5000"') do (
    taskkill /F /PID %%a >nul 2>&1
)

python -c "from app.server import run; run(open_browser=True)"
if %errorlevel% neq 0 (
    echo.
    echo  ERROR: Could not start. Make sure you ran:
    echo    pip install -r requirements.txt
    echo.
    pause
)
