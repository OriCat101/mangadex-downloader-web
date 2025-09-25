#!/bin/bash

# Docker deployment script for MangaDx Downloader Web UI

set -e

echo "🐳 MangaDx Downloader Web UI - Docker Deployment"
echo "================================================"

# Function to check if Docker is installed and running
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo "❌ Docker is not installed. Please install Docker first."
        echo "   Visit: https://docs.docker.com/get-docker/"
        exit 1
    fi

    if ! docker info &> /dev/null; then
        echo "❌ Docker daemon is not running. Please start Docker."
        exit 1
    fi

    if ! command -v docker-compose &> /dev/null; then
        echo "❌ Docker Compose is not installed. Please install Docker Compose."
        echo "   Visit: https://docs.docker.com/compose/install/"
        exit 1
    fi
}

# Function to display usage
usage() {
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start         Start the application (production mode)"
    echo "  dev           Start in development mode"
    echo "  stop          Stop the application"
    echo "  restart       Restart the application"
    echo "  logs          Show application logs"
    echo "  build         Build the Docker image"
    echo "  clean         Stop and remove containers, networks, and volumes"
    echo "  help          Show this help message"
    echo ""
}

# Main script logic
case "${1:-start}" in
    "start")
        echo "🚀 Starting MangaDx Downloader Web UI (Production Mode)..."
        check_docker
        
        # Create downloads directory
        mkdir -p downloads
        
        # Copy environment file if it doesn't exist
        if [ ! -f .env ]; then
            cp .env.example .env
            echo "📋 Created .env file from .env.example"
            echo "⚠️  Please review and update the .env file with your settings"
        fi
        
        # Start with nginx proxy
        docker-compose --profile production up -d
        
        echo "✅ Application started successfully!"
        echo "🌐 Access the web UI at: http://localhost"
        echo "📊 Direct app access: http://localhost:5000"
        ;;
        
    "dev")
        echo "🛠️  Starting MangaDx Downloader Web UI (Development Mode)..."
        check_docker
        
        mkdir -p downloads
        docker-compose -f docker-compose.dev.yml up --build
        ;;
        
    "stop")
        echo "🛑 Stopping MangaDx Downloader Web UI..."
        docker-compose down
        docker-compose -f docker-compose.dev.yml down 2>/dev/null || true
        echo "✅ Application stopped"
        ;;
        
    "restart")
        echo "🔄 Restarting MangaDx Downloader Web UI..."
        $0 stop
        sleep 2
        $0 start
        ;;
        
    "logs")
        echo "📋 Showing application logs..."
        docker-compose logs -f mangadx-web
        ;;
        
    "build")
        echo "🔨 Building Docker image..."
        check_docker
        docker-compose build --no-cache
        echo "✅ Build completed"
        ;;
        
    "clean")
        echo "🧹 Cleaning up Docker resources..."
        docker-compose down -v --remove-orphans
        docker-compose -f docker-compose.dev.yml down -v --remove-orphans 2>/dev/null || true
        docker system prune -f
        echo "✅ Cleanup completed"
        ;;
        
    "help"|"-h"|"--help")
        usage
        ;;
        
    *)
        echo "❌ Unknown command: $1"
        usage
        exit 1
        ;;
esac