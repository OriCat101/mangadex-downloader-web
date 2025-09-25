@echo off
echo Starting MangaDx Downloader Web UI...

REM Check if mangadx-downloader is installed
mangadx-dl --version >nul 2>&1
if errorlevel 1 (
    echo Error: mangadx-downloader is not installed or not in PATH
    echo Please install it with: pip install mangadx-downloader
    pause
    exit /b 1
)

REM Check if Python dependencies are installed
python -c "import flask" >nul 2>&1
if errorlevel 1 (
    echo Installing Python dependencies...
    pip install -r requirements.txt
)

REM Create downloads directory if it doesn't exist
if not exist "downloads" mkdir downloads

echo Starting web server on http://localhost:5000
echo Press Ctrl+C to stop the server

REM Start the Flask application
python app.py