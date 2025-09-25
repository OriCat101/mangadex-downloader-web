#!/bin/bash

# MangaDx Downloader Web UI Startup Script

echo "Starting MangaDx Downloader Web UI..."

# Check if mangadex-downloader is installed
if ! command -v mangadx-dl &> /dev/null; then
    echo "Error: mangadex-downloader is not installed or not in PATH"
    echo "Please install it with: pip install mangadex-downloader"
    exit 1
fi

# Check if Python dependencies are installed
if ! python3 -c "import flask" &> /dev/null; then
    echo "Installing Python dependencies..."
    pip3 install -r requirements.txt
fi

# Create downloads directory if it doesn't exist
mkdir -p downloads

echo "Starting web server on http://localhost:5000"
echo "Press Ctrl+C to stop the server"

# Start the Flask application
python3 app.py
