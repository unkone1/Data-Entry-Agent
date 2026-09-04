@echo off
REM Builds a standalone Windows .exe (Chrome + matching ChromeDriver still
REM required on the machine that runs it -- only the Python app is bundled).
python -m pip install -r requirements.txt pyinstaller
python -m PyInstaller --name "NIELIT-Data-Entry-Agent" --onefile --windowed main.py
echo.
echo Build complete. Find the executable in the dist\ folder.
pause
