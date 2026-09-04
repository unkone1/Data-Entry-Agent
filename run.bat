@echo off
REM Convenience launcher for Windows.
where python >nul 2>nul
if errorlevel 1 (
    echo Python was not found on PATH. Install Python 3.10+ from https://python.org and try again.
    pause
    exit /b 1
)
python -m pip install -r requirements.txt
python main.py
pause
