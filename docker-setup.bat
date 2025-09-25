@echo off
echo 🐳 MangaDx Downloader Web UI - Docker Setup (Windows)
echo ===============================================

REM Check if Docker is installed
docker --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not installed. Please install Docker Desktop first.
    echo    Visit: https://docs.docker.com/desktop/windows/install/
    pause
    exit /b 1
)

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not running. Please start Docker Desktop.
    pause
    exit /b 1
)

echo ✅ Docker is ready!

REM Create downloads directory
if not exist "downloads" mkdir downloads
echo 📁 Created downloads directory

REM Copy environment file
if not exist ".env" (
    copy ".env.example" ".env" >nul
    echo 📋 Created .env file from .env.example
    echo ⚠️  Please review and update the .env file if needed
)

echo.
echo Choose deployment mode:
echo 1. Development (with hot reload)
echo 2. Production (with nginx)
echo 3. Simple (direct access)
echo.
set /p choice="Enter your choice (1-3): "

if "%choice%"=="1" (
    echo 🛠️  Starting in development mode...
    docker-compose -f docker-compose.dev.yml up --build
) else if "%choice%"=="2" (
    echo 🚀 Starting in production mode...
    docker-compose --profile production up -d
    echo.
    echo ✅ Application started successfully!
    echo 🌐 Access the web UI at: http://localhost
    echo 📊 Direct app access: http://localhost:5000
) else (
    echo 🚀 Starting simple mode...
    docker-compose up -d
    echo.
    echo ✅ Application started successfully!
    echo 🌐 Access the web UI at: http://localhost:5000
)

echo.
echo To stop the application, run: docker-compose down
pause