# MangaDx Downloader Web UI

A modern, user-friendly web interface for the [mangadex-downloader](https://github.com/mansuf/mangadex-downloader) command-line tool. This Flask-based web application provides an intuitive way to download manga from MangaDx with real-time progress tracking and file management.

## Features

- **Easy-to-use web interface** - No command-line knowledge required
- **Real-time download progress** - Watch your downloads progress with live updates
- **Multiple output formats** - Support for Raw Images, PDF, EPUB, CBZ, and CB7
- **Download management** - View download history and manage completed downloads
- **File browser** - Browse and download your completed manga files
- **Multi-language support** - Download manga in various languages
- **Chapter range selection** - Download specific chapter ranges
- **Responsive design** - Works on desktop, tablet, and mobile devices

## Screenshots

### Main Download Interface
Clean and intuitive interface for starting downloads with various options.

### Download Progress Tracking
Real-time progress updates with detailed logging output.

### File Management
Browse and download your completed manga files.

## Prerequisites

- Python 3.7 or higher
- `mangadex-downloader` command-line tool installed and available in PATH

## Installation & Usage

### 🐳 Docker (Recommended)

The easiest way to run the application is using Docker:

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd maangadx-dl-web
   ```

2. **Quick start with Docker Compose:**
   ```bash
   # Start the application
   ./docker-deploy.sh start
   
   # Or use docker-compose directly
   docker-compose up -d
   ```

3. **Access the web interface:**
   ```
   http://localhost:5000
   ```

#### Docker Commands

```bash
# Development mode (with hot reload)
./docker-deploy.sh dev

# View logs
./docker-deploy.sh logs

# Stop the application
./docker-deploy.sh stop

# Clean up everything
./docker-deploy.sh clean
```

### 🐍 Manual Installation

1. **Install mangadex-downloader first:**
   ```bash
   pip install mangadex-downloader
   ```

2. **Clone or download this repository:**
   ```bash
   git clone <repository-url>
   cd maangadx-dl-web
   ```

3. **Install Python dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

4. **Start the web server:**
   ```bash
   python app.py
   ```

5. **Open your web browser and navigate to:**
   ```
   http://localhost:5000
   ```

### 📱 How to Use

1. **Start downloading:**
   - Paste a MangaDx URL into the input field
   - Choose your preferred format and options
   - Click "Start Download" and watch the progress

## Configuration

### Download Directory
By default, files are downloaded to the `downloads/` directory in the project folder. You can modify this by changing the `DOWNLOAD_DIR` variable in `app.py`.

### Supported Formats
- **Raw Images** - Individual image files
- **PDF** - Portable Document Format
- **EPUB** - Electronic Publication format
- **CBZ** - Comic Book Archive (ZIP)
- **CB7** - Comic Book Archive (7-Zip)

### Supported Languages
The web UI supports all languages available in mangadex-downloader, including:
- English (en)
- Japanese (ja)
- Spanish (es)
- French (fr)
- German (de)
- Italian (it)
- Portuguese (pt)
- Korean (ko)
- Chinese (zh)

## 🐳 Docker Configuration

### Environment Variables

Copy `.env.example` to `.env` and customize:

```bash
cp .env.example .env
```

Key variables:
- `FLASK_ENV` - Set to `production` or `development`
- `SECRET_KEY` - Change this for security
- `DOWNLOAD_DIR` - Directory for downloaded files

### Production Deployment

For production with nginx reverse proxy:

```bash
# Start with nginx proxy
docker-compose --profile production up -d

# Access via nginx (port 80)
http://localhost
```

### Volume Mounts

- `./downloads:/app/downloads` - Downloaded files
- `downloads_data` - Persistent volume for downloads

## API Endpoints

The web UI also provides REST API endpoints:

- `POST /download` - Start a new download
- `GET /status/<download_id>` - Get download status
- `GET /api/downloads` - List all downloads
- `GET /files` - List downloaded files

## Troubleshooting

### "mangadex-dl command not found"
Make sure mangadex-downloader is installed and available in your system PATH:
```bash
pip install mangadex-downloader
```

### Downloads failing
1. Check that the MangaDx URL is valid
2. Ensure you have internet connectivity
3. Some manga may require authentication - this feature may be added in future versions

### Permission errors
Ensure the web application has write permissions to the download directory.

## Development

### Project Structure
```
maangadex-dl-web/
├── app.py                 # Main Flask application
├── requirements.txt       # Python dependencies
├── templates/            # HTML templates
│   ├── base.html         # Base template
│   ├── index.html        # Main download page
│   ├── downloads.html    # Download history
│   ├── files.html        # File browser
│   └── settings.html     # Settings page
├── static/               # Static assets
│   ├── css/
│   │   └── style.css    # Custom styles
│   └── js/
│       └── app.js       # JavaScript functionality
└── downloads/           # Downloaded files (created automatically)
```

### Running in Development Mode
```bash
export FLASK_ENV=development
python app.py
```

### Running in Production
For production deployment, consider using a WSGI server like Gunicorn:
```bash
pip install gunicorn
gunicorn -w 4 -b 0.0.0.0:5000 app:app
```

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## License

This project is licensed under the MIT License - see the original [mangadex-downloader](https://github.com/mansuf/mangadex-downloader) project for more details.

## Disclaimer

This web UI is not affiliated with MangaDx or the original mangadex-downloader project. It's an independent frontend interface for the command-line tool.

## Acknowledgments

- [mansuf](https://github.com/mansuf) for the excellent [mangadex-downloader](https://github.com/mansuf/mangadex-downloader) tool
- Bootstrap team for the UI framework
- Flask team for the web framework
