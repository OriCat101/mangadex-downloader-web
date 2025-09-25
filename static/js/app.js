// Main JavaScript for MangaDex Downloader Web UI

// Utility functions
function formatBytes(bytes, decimals = 2) {
    if (bytes === 0) return '0 Bytes';
    
    const k = 1024;
    const dm = decimals < 0 ? 0 : decimals;
    const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    
    return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
}

function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleString();
}

function showNotification(message, type = 'info') {
    // Create notification element
    const notification = document.createElement('div');
    notification.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
    notification.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
    notification.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    // Add to body
    document.body.appendChild(notification);
    
    // Auto remove after 5 seconds
    setTimeout(() => {
        if (notification.parentNode) {
            notification.remove();
        }
    }, 5000);
}

// Form validation
function validateUrl(url) {
    try {
        const urlObj = new URL(url);
        return urlObj.hostname.includes('mangadex');
    } catch {
        return false;
    }
}

// Download management
class DownloadManager {
    constructor() {
        this.activeDownloads = new Map();
    }
    
    addDownload(downloadId, url) {
        this.activeDownloads.set(downloadId, {
            id: downloadId,
            url: url,
            status: 'starting',
            progress: 0,
            startTime: Date.now()
        });
    }
    
    updateDownload(downloadId, status) {
        if (this.activeDownloads.has(downloadId)) {
            const download = this.activeDownloads.get(downloadId);
            Object.assign(download, status);
            
            if (status.status === 'completed' || status.status === 'failed') {
                // Keep completed/failed downloads for a while before cleanup
                setTimeout(() => {
                    this.activeDownloads.delete(downloadId);
                }, 60000); // 1 minute
            }
        }
    }
    
    getDownload(downloadId) {
        return this.activeDownloads.get(downloadId);
    }
    
    getAllDownloads() {
        return Array.from(this.activeDownloads.values());
    }
}

// Global download manager instance
const downloadManager = new DownloadManager();

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    // Initialize tooltips
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
    
    // Initialize popovers
    const popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
    popoverTriggerList.map(function (popoverTriggerEl) {
        return new bootstrap.Popover(popoverTriggerEl);
    });
    
    // Auto-hide alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert:not(.alert-permanent)');
    alerts.forEach(alert => {
        setTimeout(() => {
            if (alert.parentNode) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            }
        }, 5000);
    });
    
    // Add loading states to buttons
    const forms = document.querySelectorAll('form');
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            const submitBtn = form.querySelector('button[type="submit"]');
            if (submitBtn) {
                const originalText = submitBtn.innerHTML;
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
                submitBtn.disabled = true;
                
                // Re-enable after 5 seconds as fallback
                setTimeout(() => {
                    submitBtn.innerHTML = originalText;
                    submitBtn.disabled = false;
                }, 5000);
            }
        });
    });
});

// Keyboard shortcuts
document.addEventListener('keydown', function(e) {
    // Ctrl+/ or Cmd+/ to focus search/URL input
    if ((e.ctrlKey || e.metaKey) && e.key === '/') {
        e.preventDefault();
        const urlInput = document.getElementById('url');
        if (urlInput) {
            urlInput.focus();
        }
    }
    
    // Escape to clear modals or cancel current action
    if (e.key === 'Escape') {
        const modals = document.querySelectorAll('.modal.show');
        modals.forEach(modal => {
            const bsModal = bootstrap.Modal.getInstance(modal);
            if (bsModal) {
                bsModal.hide();
            }
        });
    }
});

// Online/offline status
window.addEventListener('online', function() {
    showNotification('Connection restored', 'success');
});

window.addEventListener('offline', function() {
    showNotification('Connection lost - downloads may be interrupted', 'warning');
});

// Export for use in other scripts
window.MangaDexUI = {
    downloadManager,
    showNotification,
    validateUrl,
    formatBytes,
    formatDate
};
