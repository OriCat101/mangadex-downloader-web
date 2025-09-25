# MangaDex Downloader Web
> [!CAUTION]
> This entire application was AI generated to test opencode so it may very well have issues I'm unaware of

## ✨ Features
### Core Functionality
- **Real-time Progress Tracking** - Live download progress with detailed logging
- **Multiple Output Formats** - Raw images, PDF, EPUB, CBZ, and CB7 support
- **Chapter Range Selection** - Download specific chapters or complete series
- **Multi-language Support** - Download manga in any available language

## 🚀 Quick Start
### Docker (Recommended)
1. **Clone and start:**
   ```bash
   docker-compose up -d
   ```

2. **Access the application:**
   ```
   http://localhost:5000
   ```

That's it! The application will be running with all dependencies included.

### Manual Installation
1. **Prerequisites:**
   ```bash
   # Install Python dependencies
   pip install mangadx-downloader
   pip install -r requirements.txt
   ```

2. **Run the application:**
   ```bash
   python app.py
   ```

## 📖 Usage Guide
### Basic Download
1. Open the web interface at `http://localhost:5000`
2. Paste a MangaDex URL into the input field
3. Select your preferred format and language
4. Click "Start Download" and monitor progress in real-time

### Advanced Options
- **Format Selection**: Choose between Raw Images, PDF, EPUB, CBZ, or CB7
- **Language Filter**: Download manga in specific languages
- **Chapter Ranges**: Use syntax like `1-10` or `5,7,9-12`
- **Quality Settings**: Select image quality preferences

### Managing Downloads
- **View History**: See all past downloads with status and timestamps
- **Browse Files**: Navigate downloaded content with built-in file browser
- **Re-download**: Easily retry failed downloads
- **API Access**: Use REST endpoints for automation

## 🐳 Docker Configuration
### Environment Variables
Key configuration options:
```env
FLASK_DEBUG (defaults to False)
FLASK_HOST (defaults to '0.0.0.0')
FLASK_PORT (defaults to 5000)
SECRET_KEY=your-secret-key-here (optional)
```

### Docker Compose Profiles
**Development with hot reload:**
```bash
docker-compose -f docker-compose.dev.yml up -d
```

**Production deployment:**
```bash
docker-compose up -d
```

## 🔧 Configuration
### Download Directory
By default, files are saved to `./downloads/`. Modify this in `app.py`:
```python
DOWNLOAD_DIR = os.path.join(os.getcwd(), 'downloads')
```

### Supported Formats
| Format | Description | Use Case |
|--------|-------------|----------|
| Raw Images | Individual PNG/JPG files | Maximum quality, custom readers |
| PDF | Portable Document Format | Universal compatibility |
| EPUB | E-book format | E-readers, mobile apps |
| CBZ | Comic Book ZIP | Comic readers |
| CB7 | Comic Book 7-Zip | Better compression |

### Language Codes
Common language options:
- `en` - English
- `ja` - Japanese  
- `es` - Spanish
- `fr` - French
- `de` - German
- `ko` - Korean
- `zh` - Chinese
- `pt` - Portuguese

## 🛠️ Development
### Project Structure
```
maangadx-dl-web/
├── app.py                 # Flask application & API
├── requirements.txt       # Python dependencies
├── Dockerfile            # Container configuration
├── docker-compose.yml    # Docker orchestration
├── templates/            # Jinja2 HTML templates
│   ├── base.html         # Base layout
│   ├── index.html        # Main download interface
│   ├── downloads.html    # Download history
│   └── settings.html     # Configuration
├── static/               # Frontend assets
│   ├── css/style.css    # Styling
│   └── js/app.js        # JavaScript functionality
└── downloads/           # Downloaded content
```

## Dependencies
- **Flask**: Web framework
- **mangadx-downloader**: Core download functionality
- **requests**: HTTP client library

## 📝 License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments
- **[mansuf](https://github.com/mansuf)** - Creator of the excellent [mangadex-downloader](https://github.com/mansuf/mangadex-downloader) tool

## ⚠️ Disclaimr
This project is an independent web interface for the mangadx-downloader tool. It is not affiliated with or endorsed by MangaDex. Please respect MangaDex's terms of service.

---
