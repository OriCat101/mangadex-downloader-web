from flask import Flask, render_template, request, jsonify, send_file, redirect, url_for, flash
import os
import subprocess
import threading
import json
import time
from datetime import datetime
import queue
import uuid
import secrets

app = Flask(__name__)
app.secret_key = os.environ.get('SECRET_KEY') or secrets.token_hex(32)

# Configuration
DOWNLOAD_DIR = os.path.join(os.getcwd(), 'downloads')
if not os.path.exists(DOWNLOAD_DIR):
    os.makedirs(DOWNLOAD_DIR)

# Global variables for tracking downloads
active_downloads = {}
download_history = []

class DownloadManager:
    def __init__(self):
        self.downloads = {}
        self.progress_queue = queue.Queue()
    
    def start_download(self, url, options=None):
        download_id = str(uuid.uuid4())
        
        download_info = {
            'id': download_id,
            'url': url,
            'status': 'starting',
            'progress': 0,
            'started_at': datetime.now().isoformat(),
            'output': [],
            'error': None,
            'options': options or {}
        }
        
        self.downloads[download_id] = download_info
        
        # Start download in separate thread
        thread = threading.Thread(target=self._run_download, args=(download_id, url, options))
        thread.daemon = True
        thread.start()
        
        return download_id
    
    def _run_download(self, download_id, url, options):
        try:
            download_info = self.downloads[download_id]
            download_info['status'] = 'downloading'
            
            # Build mangadex-dl command
            cmd = ['mangadex-dl']
            cmd.append(url)
            
            # Set download path (append custom path to base dir if provided)
            download_path = DOWNLOAD_DIR
            if options and options.get('custom_path'):
                download_path = DOWNLOAD_DIR + '/' + options['custom_path']
            cmd.extend(['--path', download_path])
            
            # Add options
            if options:
                if options.get('format'):
                    cmd.extend(['--save-as', options['format']])
                if options.get('language'):
                    cmd.extend(['--language', options['language']])
                if options.get('start_chapter'):
                    cmd.extend(['--start-chapter', str(options['start_chapter'])])
                if options.get('end_chapter'):
                    cmd.extend(['--end-chapter', str(options['end_chapter'])])
                if options.get('no_oneshot'):
                    cmd.append('--no-oneshot')
                if options.get('replace'):
                    cmd.append('--replace')
                
                # Add filename customization options
                if options.get('filename_chapter'):
                    cmd.extend(['--filename-chapter', options['filename_chapter']])
                if options.get('filename_volume'):
                    cmd.extend(['--filename-volume', options['filename_volume']])
                if options.get('filename_single'):
                    cmd.extend(['--filename-single', options['filename_single']])
            
            process = subprocess.Popen(
                cmd,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                universal_newlines=True,
                bufsize=1
            )
            
            # Read output line by line
            while True:
                output = process.stdout.readline()
                if output == '' and process.poll() is not None:
                    break
                if output:
                    line = output.strip()
                    download_info['output'].append(line)
                    
                    # Try to extract progress information
                    if 'Downloaded' in line and '%' in line:
                        try:
                            progress_str = line.split('%')[0].split()[-1]
                            download_info['progress'] = float(progress_str)
                        except:
                            pass
            
            # Check if download completed successfully
            if process.returncode == 0:
                download_info['status'] = 'completed'
                download_info['progress'] = 100
                download_info['completed_at'] = datetime.now().isoformat()
            else:
                download_info['status'] = 'failed'
                download_info['error'] = f"Process exited with code {process.returncode}"
                
        except Exception as e:
            download_info = self.downloads[download_id]
            download_info['status'] = 'failed'
            download_info['error'] = str(e)
    
    def get_download_status(self, download_id):
        return self.downloads.get(download_id)
    
    def get_all_downloads(self):
        return list(self.downloads.values())

download_manager = DownloadManager()

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/download', methods=['POST'])
def start_download():
    data = request.get_json() if request.is_json else request.form
    url = data.get('url', '').strip()
    
    if not url:
        return jsonify({'error': 'URL is required'}), 400
    
    # Validate URL (basic check)
    if 'mangadex.org' not in url:
        return jsonify({'error': 'Please provide a valid MangaDex URL'}), 400
    
    options = {
        'format': data.get('format', 'raw'),
        'language': data.get('language', 'en'),
        'start_chapter': data.get('start_chapter'),
        'end_chapter': data.get('end_chapter'),
        'no_oneshot': data.get('no_oneshot', False),
        'replace': data.get('replace', False),
        'custom_path': data.get('custom_path'),
        'filename_chapter': data.get('filename_chapter'),
        'filename_volume': data.get('filename_volume'),
        'filename_single': data.get('filename_single')
    }
    
    download_id = download_manager.start_download(url, options)
    
    return jsonify({
        'success': True,
        'download_id': download_id,
        'message': 'Download started successfully'
    })

@app.route('/status/<download_id>')
def download_status(download_id):
    status = download_manager.get_download_status(download_id)
    if not status:
        return jsonify({'error': 'Download not found'}), 404
    
    return jsonify(status)

@app.route('/downloads')
def list_downloads():
    downloads = download_manager.get_all_downloads()
    # Sort by started_at, newest first
    downloads.sort(key=lambda x: x['started_at'], reverse=True)
    return render_template('downloads.html', downloads=downloads)

@app.route('/api/downloads')
def api_downloads():
    downloads = download_manager.get_all_downloads()
    downloads.sort(key=lambda x: x['started_at'], reverse=True)
    return jsonify(downloads)



@app.route('/settings')
def settings():
    return render_template('settings.html', download_dir=DOWNLOAD_DIR)

if __name__ == '__main__':
    debug = os.environ.get('FLASK_DEBUG', 'False').lower() in ['true', '1', 'yes']
    host = os.environ.get('FLASK_HOST', '0.0.0.0')
    port = int(os.environ.get('FLASK_PORT', 5000))
    app.run(debug=debug, host=host, port=port)
